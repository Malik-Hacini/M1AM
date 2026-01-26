# Compiler and flags
CXX = g++
CXXFLAGS = -Wall -std=c++11

# Executable name
TARGET = store

# Source files
SRCS = item.cpp discounteditem.cpp notdiscounteditem.cpp deliverableitem.cpp main.cpp

# Object files (replace .cpp with .o)
OBJS = $(SRCS:.cpp=.o)

# Default target: build the executable
all: $(TARGET)

# Link object files to create executable
$(TARGET): $(OBJS)
	$(CXX) $(CXXFLAGS) -o $(TARGET) $(OBJS)

# Compile .cpp files to .o files
%.o: %.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

# Clean target: remove executable and object files
clean:
	rm -f $(TARGET) $(OBJS)

# Phony targets (not actual files)
.PHONY: all clean
