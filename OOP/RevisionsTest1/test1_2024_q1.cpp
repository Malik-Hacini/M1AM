#include <iostream>
#include <cstring>

// Question 1: Declaration of class Location

class Location {
private:
    // Private data members
    char* city;      // Pointer to dynamically allocated string for city name
    char* country;   // Pointer to dynamically allocated string for country name

public:
    // Constructor - initializes a Location with city and country
    Location(const char* c, const char* co);
    
    // Copy constructor - creates a deep copy of another Location
    Location(const Location& other);
    
    // Assignment operator - assigns one Location to another with deep copy
    Location& operator=(const Location& other);
    
    // Destructor - frees dynamically allocated memory
    ~Location();
    
    // Getter for city - returns the city name
    const char* getCity() const;
    
    // Getter for country - returns the country name
    const char* getCountry() const;
    
    // Setter for city - sets a new city name
    void setCity(const char* c);
    
    // Setter for country - sets a new country name
    void setCountry(const char* co);
    
    // same_country method - compares country with another Location's country
    // Returns true if both locations have the same country, false otherwise
    bool same_country(const Location& loc) const;
    
    // Display method - prints the location information
    void display() const;
    
    // Friend function declaration for operator<< overloading
    // Must be friend to access private members city and country
    friend std::ostream& operator<<(std::ostream& os, const Location& loc);
};

// Operator << overloading - allows using cout << location
// Signature: ostream& operator<<(ostream& os, const Location& loc)
// - Returns ostream& to allow chaining (e.g., cout << loc1 << loc2)
// - First parameter: ostream& (the output stream, like cout)
// - Second parameter: const Location& (the object to print)
// - Declared as friend to access private members
std::ostream& operator<<(std::ostream& os, const Location& loc) {
    os << loc.city << ", " << loc.country;
    return os;  // Return the stream to allow chaining
}

// Implementation of methods

// Constructor: Initializes city and country with dynamic memory allocation
Location::Location(const char* c, const char* co) {
    // Allocate memory and copy city string
    city = new char[strlen(c) + 1];
    strcpy(city, c);
    
    // Allocate memory and copy country string
    country = new char[strlen(co) + 1];
    strcpy(country, co);
}

// Copy constructor: Creates a deep copy to avoid shallow copy issues
Location::Location(const Location& other) {
    city = new char[strlen(other.city) + 1];
    strcpy(city, other.city);
    
    country = new char[strlen(other.country) + 1];
    strcpy(country, other.country);
}

// Assignment operator: Handles self-assignment and performs deep copy
Location& Location::operator=(const Location& other) {
    if (this != &other) {  // Check for self-assignment
        // Delete old memory
        delete[] city;
        delete[] country;
        
        // Allocate new memory and copy
        city = new char[strlen(other.city) + 1];
        strcpy(city, other.city);
        
        country = new char[strlen(other.country) + 1];
        strcpy(country, other.country);
    }
    return *this;
}

// Destructor: Frees dynamically allocated memory to prevent memory leaks
Location::~Location() {
    delete[] city;
    delete[] country;
}

// Getter methods
const char* Location::getCity() const {
    return city;
}

const char* Location::getCountry() const {
    return country;
}

// Setter methods
void Location::setCity(const char* c) {
    delete[] city;  // Free old memory
    city = new char[strlen(c) + 1];
    strcpy(city, c);
}

void Location::setCountry(const char* co) {
    delete[] country;  // Free old memory
    country = new char[strlen(co) + 1];
    strcpy(country, co);
}

// same_country: Compares this location's country with another location's country
// Takes a const reference to avoid copying and to not modify the parameter
// Returns bool: true if countries match, false otherwise
// Marked const because it doesn't modify the current object
bool Location::same_country(const Location& loc) const {
    return strcmp(country, loc.country) == 0;
}

// Display method: Shows location information
void Location::display() const {
    std::cout << city << ", " << country << std::endl;
}

// Test program
int main() {
    // Create some locations
    Location paris("Paris", "France");
    Location lyon("Lyon", "France");
    Location london("London", "UK");
    
    std::cout << "Testing Location class:\n" << std::endl;
    
    // Display locations
    std::cout << "Location 1: ";
    paris.display();
    
    std::cout << "Location 2: ";
    lyon.display();
    
    std::cout << "Location 3: ";
    london.display();
    
    std::cout << "\nTesting same_country method:\n" << std::endl;
    
    // Test same_country
    if (paris.same_country(lyon)) {
        std::cout << "Paris and Lyon are in the same country" << std::endl;
    } else {
        std::cout << "Paris and Lyon are NOT in the same country" << std::endl;
    }
    
    if (paris.same_country(london)) {
        std::cout << "Paris and London are in the same country" << std::endl;
    } else {
        std::cout << "Paris and London are NOT in the same country" << std::endl;
    }
    
    std::cout << "\n=== Testing operator<< overloading ===\n" << std::endl;
    
    // Using operator<< instead of display()
    std::cout << "Using operator<<:" << std::endl;
    std::cout << "Location 1: " << paris << std::endl;
    std::cout << "Location 2: " << lyon << std::endl;
    std::cout << "Location 3: " << london << std::endl;
    
    // Demonstrating chaining
    std::cout << "\nChaining multiple locations: " << std::endl;
    std::cout << paris << " -> " << lyon << " -> " << london << std::endl;
    
    return 0;
}
