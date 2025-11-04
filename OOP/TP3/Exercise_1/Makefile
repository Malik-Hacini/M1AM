# Directories
SRC_DIR := src
INCLUDE_DIR := include
BIN_DIR := bin

# Executable name
TARGET := $(BIN_DIR)/my_factorial

CXX := g++
CXXFLAGS := -Wall -Wextra -std=c++17 -I$(INCLUDE_DIR)

# Source files
SRCS := $(wildcard $(SRC_DIR)/*.cpp)

# Default rule: build the executable
all: $(TARGET)

$(TARGET): $(SRCS)
	@mkdir -p $(BIN_DIR)
	$(CXX) $(CXXFLAGS) $^ -o $@

clean:
	rm -f $(TARGET)

.PHONY: all clean
