CXX := g++
CXXFLAGS := -std=c++17 -Wall -Wextra -pedantic -O2

all: my_factorial

my_factorial: my_factorial.cpp
	$(CXX) $(CXXFLAGS) -o $@ $<

clean:
	rm -f my_factorial

.PHONY: all clean
