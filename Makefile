CC = clang
CFLAGS = -Wall -c `pkg-config --cflags sdl2` -Wall -O3
LDFLAGS = `pkg-config --libs sdl2` -lm -lpthread -O3
EXE = pixel

all: $(EXE)

$(EXE): main.o ringbuf.o
	$(CC) $(LDFLAGS) main.o ringbuf.o -o $@

main.o: main.c
	$(CC) $(CFLAGS) $< -o $@

ringbuf.o: ringbuf.c
	$(CC) $(CFLAGS) $< -o $@

clean:
	rm -rf *.o $(EXE)