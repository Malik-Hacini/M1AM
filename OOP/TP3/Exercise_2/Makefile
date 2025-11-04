# Directories
SRC_DIR := src
INCLUDE_DIR := include
BIN_DIR := bin

# Executable name
TARGET := $(BIN_DIR)/trip_planner

CXX := g++
CXXFLAGS := -Wall -Wextra -std=c++17 -I$(INCLUDE_DIR)

# Source files
SRCS := $(wildcard $(SRC_DIR)/*.cpp)

# Object files
OBJS := $(SRCS:$(SRC_DIR)/%.cpp=$(BIN_DIR)/%.o)

# Default rule: build the executable
all: $(TARGET)

$(TARGET): $(OBJS)
	@mkdir -p $(BIN_DIR)
	$(CXX) $(CXXFLAGS) $^ -o $@

$(BIN_DIR)/%.o: $(SRC_DIR)/%.cpp
	@mkdir -p $(BIN_DIR)
	$(CXX) $(CXXFLAGS) -c $< -o $@

clean:
	rm -f $(BIN_DIR)/*.o $(TARGET)

.PHONY: all clean
