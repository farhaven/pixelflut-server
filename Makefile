CC = gcc
CFLAGS = -Wall -c `pkg-config --cflags sdl2` -Wall -O3
LDFLAGS = `pkg-config --libs sdl2` -lm -lpthread -O3
EXE = pixel

# configuration
PIXEL_WIDTH = 1920
PIXEL_HEIGHT = 1000
PORT = 1234

DEFINES = -DPIXEL_WIDTH=$(PIXEL_WIDTH) -DPIXEL_HEIGHT=$(PIXEL_HEIGHT) -DPORT=$(PORT) -D_DEFAULT_SOURCE
IP = $(shell ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $$2}' | cut -f1 -d'/')
INFO = $(IP):$(PORT) $(PIXEL_WIDTH)x$(PIXEL_HEIGHT)

all: $(EXE)

$(EXE): main.o
	$(CC) -o $@ main.o $(LDFLAGS)

main.o: main.c
	$(CC) $(CFLAGS) $(DEFINES) $< -o $@

clean:
	rm -rf *.o $(EXE)

run:
	make
	./pixel &
	convert -size 320x20 xc:Transparent -pointsize 20 -fill black -draw "text 2,19 '$(INFO)'" -fill white -draw "text 0,17 '$(INFO)'" ip.png
	watch -n 10 python client.py 127.0.0.1 $(PORT) ip.png > /dev/null
