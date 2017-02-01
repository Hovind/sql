CC=cc
CFLAGS=-Wall
LDFLAGS=-locilib

OBJECTS=parties-4-5.c

TARGET=parties-4-5

$(TARGET): $(OBJECTS)
	$(CC) $(CFLAGS) $(OBJECTS) -o $@ $(LDFLAGS)

all: $(TARGET)

.PHONY: clean
clean:
	rm -f *~ *.o $(TARGET)

