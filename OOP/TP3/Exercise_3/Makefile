#Directories
SRC_DIR := src
INCLUDE_DIR := include
BIN_DIR := bin

#Source files
SRCS := $(wildcard $(SRC_DIR)/*.cpp)


# Dossiers
SRC_DIR := src
INCLUDE_DIR := include
BIN_DIR := bin

# Nom de l'exécutable
TARGET := $(BIN_DIR)/app

CXX := g++
CXXFLAGS := -Wall -Wextra -std=c++17 -I$(INCLUDE_DIR)

# Fichiers source
SRCS := $(wildcard $(SRC_DIR)/*.cpp)

# Règle par défaut : construire l'exécutable
all: $(TARGET)

$(TARGET): $(SRCS)
	@mkdir -p $(BIN_DIR)
	$(CXX) $(CXXFLAGS) $^ -o $@

clean:
	rm -f $(TARGET)

.PHONY: all clean