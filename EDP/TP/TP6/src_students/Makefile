all:	release


all: release

release:
	g++ --std=c++11 -O2 main.cpp -o main

debug:
	g++ --std=c++11 -O0 -g -DWAVE_DEBUG=1 main.cpp -o main

clean:
	rm -f main
