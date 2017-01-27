CC=cc
CFLAGS=-Wall
LDFLAGS=-locilib

OBJECTS=testdb.c

TARGET=testdb

$(TARGET): $(OBJECTS)
	$(CC) $(CFLAGS) $(OBJECTS) -o $@ $(LDFLAGS)

all: $(TARGET)

.PHONY: clean
clean:
	rm -f *~ *.o $(TARGET)

