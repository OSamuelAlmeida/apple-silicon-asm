.PHONY: all

all: build/hello_world

run: build/hello_world
	./build/hello_world

build/hello_world: build/hello_world.o
	ld -macos_version_min 14.0.0 -o build/hello_world build/hello_world.o -lSystem -syslibroot `xcrun -sdk macosx --show-sdk-path` -e _start -arch arm64 -dead_strip

build/hello_world.o: hello_world.asm
	as hello_world.asm -o build/hello_world.o

clean:
	rm -rf build/*