#include <iostream>
#include <string>
#include <cstring>

// ============================================================================
// Location class (from Question 1) - needed for Train_ticket
// ============================================================================

class Location {
private:
    char* city;
    char* country;

public:
    Location(const char* c, const char* co);
    Location(const Location& other);
    Location& operator=(const Location& other);
    ~Location();
    
    const char* getCity() const;
    const char* getCountry() const;
    bool same_country(const Location& loc) const;
    
    friend std::ostream& operator<<(std::ostream& os, const Location& loc);
};

// Location implementation
Location::Location(const char* c, const char* co) {
    city = new char[strlen(c) + 1];
    strcpy(city, c);
    country = new char[strlen(co) + 1];
    strcpy(country, co);
}

Location::Location(const Location& other) {
    city = new char[strlen(other.city) + 1];
    strcpy(city, other.city);
    country = new char[strlen(other.country) + 1];
    strcpy(country, other.country);
}

Location& Location::operator=(const Location& other) {
    if (this != &other) {
        delete[] city;
        delete[] country;
        city = new char[strlen(other.city) + 1];
        strcpy(city, other.city);
        country = new char[strlen(other.country) + 1];
        strcpy(country, other.country);
    }
    return *this;
}

Location::~Location() {
    delete[] city;
    delete[] country;
}

const char* Location::getCity() const {
    return city;
}

const char* Location::getCountry() const {
    return country;
}

bool Location::same_country(const Location& loc) const {
    return strcmp(country, loc.country) == 0;
}

std::ostream& operator<<(std::ostream& os, const Location& loc) {
    os << loc.city << ", " << loc.country;
    return os;
}

// ============================================================================
// Given Time class from the exam
// ============================================================================

class Time {
private:
    int hour, minutes;
public:
    Time(int h, int m) {
        hour = h;
        minutes = m;
    }
    std::string get_time() const {
        std::string s;
        s.append(std::to_string(hour)).append(":").append(std::to_string(minutes));
        return s;
    }
};

// Question 4: Train_ticket class definition

class Train_ticket {
private:
    // Departure location (composed of city and country)
    Location* departure_location;
    
    // Arrival location (composed of city and country)
    Location* arrival_location;
    
    // C-style array of 2 Time instances: [0] = departure time, [1] = arrival time
    Time* times[2];  // Statically allocated array of 2 pointers
    
    // Raw price (float)
    float raw_price;
    
    // Reduction rate (float) - percentage as decimal (e.g., 0.20 for 20%)
    float reduction_rate;

public:
    // Constructor: initializes a Train_ticket with departure and arrival info
    // Takes: departure city, departure country, arrival city, arrival country,
    //        departure hour, departure minutes, arrival hour, arrival minutes, raw price
    // The reduction rate is initially 0 (unknown)
    Train_ticket(const char* dep_city, const char* dep_country,
                 const char* arr_city, const char* arr_country,
                 int dep_hour, int dep_min,
                 int arr_hour, int arr_min,
                 float price);
    
    // Copy constructor - performs deep copy of all dynamically allocated members
    Train_ticket(const Train_ticket& other);
    
    // Assignment operator - handles deep copy and self-assignment
    Train_ticket& operator=(const Train_ticket& other);
    
    // Destructor - frees all dynamically allocated memory
    ~Train_ticket();
    
    // Setter for reduction rate
    // Example: if reduction percentage is 20%, pass 0.20
    void set_reduction_rate(float rate);
    
    // Getter for reduction rate
    float get_reduction_rate() const;
    
    // ticket_price method - computes the actual price after applying reduction
    // Formula: actual_price = raw_price * (1 - reduction_rate)
    float ticket_price() const;
    
    // international_train method - returns true if departure and arrival countries differ
    bool international_train() const;
    
    // Display method - prints all ticket information
    void display() const;
    
    // Getters for testing
    const Location* get_departure_location() const;
    const Location* get_arrival_location() const;
    float get_raw_price() const;
};


// ============================================================================
// IMPLEMENTATION OF Train_ticket METHODS
// ============================================================================

// Constructor
Train_ticket::Train_ticket(const char* dep_city, const char* dep_country,
                           const char* arr_city, const char* arr_country,
                           int dep_hour, int dep_min,
                           int arr_hour, int arr_min,
                           float price) {
    // Create departure location (dynamically allocated)
    departure_location = new Location(dep_city, dep_country);
    
    // Create arrival location (dynamically allocated)
    arrival_location = new Location(arr_city, arr_country);
    
    // Create departure time (index 0)
    times[0] = new Time(dep_hour, dep_min);
    
    // Create arrival time (index 1)
    times[1] = new Time(arr_hour, arr_min);
    
    // Set raw price
    raw_price = price;
    
    // Initialize reduction rate to 0 (unknown at creation)
    reduction_rate = 0.0f;
}

// Copy constructor - performs DEEP COPY
Train_ticket::Train_ticket(const Train_ticket& other) {
    // Deep copy departure location
    departure_location = new Location(*other.departure_location);
    
    // Deep copy arrival location
    arrival_location = new Location(*other.arrival_location);
    
    // Deep copy departure time
    times[0] = new Time(*other.times[0]);
    
    // Deep copy arrival time
    times[1] = new Time(*other.times[1]);
    
    // Copy primitive types (no dynamic allocation needed)
    raw_price = other.raw_price;
    reduction_rate = other.reduction_rate;
}
// Assignment operator
// Assignment operator
Train_ticket& Train_ticket::operator=(const Train_ticket& other) {
    if (this != &other) {  // Check for self-assignment
        // Delete old memory
        delete departure_location;
        delete arrival_location;
        delete times[0];
        delete times[1];
        
        // Deep copy from other
        departure_location = new Location(*other.departure_location);
        arrival_location = new Location(*other.arrival_location);
        times[0] = new Time(*other.times[0]);
        times[1] = new Time(*other.times[1]);
        
        raw_price = other.raw_price;
        reduction_rate = other.reduction_rate;
    }
    return *this;
}

// Destructor - frees all dynamically allocated memory
Train_ticket::~Train_ticket() {
    delete departure_location;
    delete arrival_location;
    delete times[0];
    delete times[1];
}

// Setter for reduction rate
// Example: set_reduction_rate(0.20) for 20% reduction
void Train_ticket::set_reduction_rate(float rate) {
    reduction_rate = rate;
}

// Getter for reduction rate
float Train_ticket::get_reduction_rate() const {
    return reduction_rate;
}

// ticket_price - computes actual price after applying reduction
// Formula: actual_price = raw_price * (1 - reduction_rate)
// Example: raw_price = 100, reduction_rate = 0.20 -> actual = 100 * 0.80 = 80
float Train_ticket::ticket_price() const {
    return raw_price * (1.0f - reduction_rate);
}

// international_train - checks if departure and arrival countries are different
// Returns true if international (different countries), false if domestic (same country)
bool Train_ticket::international_train() const {
    // Use the same_country method from Location class
    // If they are in the same country, it's NOT international
    return !departure_location->same_country(*arrival_location);
}

// Display method - prints all ticket information
void Train_ticket::display() const {
    std::cout << "=== Train Ticket ===" << std::endl;
    std::cout << "From: " << *departure_location << std::endl;
    std::cout << "To: " << *arrival_location << std::endl;
    std::cout << "Departure time: " << times[0]->get_time() << std::endl;
    std::cout << "Arrival time: " << times[1]->get_time() << std::endl;
    std::cout << "Raw price: €" << raw_price << std::endl;
    std::cout << "Reduction rate: " << (reduction_rate * 100) << "%" << std::endl;
    std::cout << "Actual price: €" << ticket_price() << std::endl;
    std::cout << "International: " << (international_train() ? "Yes" : "No") << std::endl;
}

// Getters for testing
const Location* Train_ticket::get_departure_location() const {
    return departure_location;
}

const Location* Train_ticket::get_arrival_location() const {
    return arrival_location;
}

float Train_ticket::get_raw_price() const {
    return raw_price;
}


// ============================================================================
// TEST PROGRAM
// ============================================================================

int main() {
    std::cout << "=== Testing Train_ticket class ===\n" << std::endl;
    
    // Test 1: Create a domestic train ticket (France to France)
    std::cout << "--- Test 1: Domestic train (Paris to Lyon) ---" << std::endl;
    Train_ticket domestic("Paris", "France", "Lyon", "France",
                         9, 30,    // Departure: 9:30
                         12, 45,   // Arrival: 12:45
                         100.0f);  // Raw price: €100
    
    domestic.display();
    std::cout << std::endl;
    
    // Test 2: Create an international train ticket (France to Belgium)
    std::cout << "--- Test 2: International train (Paris to Brussels) ---" << std::endl;
    Train_ticket international("Paris", "France", "Brussels", "Belgium",
                               14, 20,   // Departure: 14:20
                               16, 45,   // Arrival: 16:45
                               150.0f);  // Raw price: €150
    
    international.display();
    std::cout << std::endl;
    
    // Test 3: Apply reduction rate (20% discount)
    std::cout << "--- Test 3: Applying 20% reduction to domestic ticket ---" << std::endl;
    domestic.set_reduction_rate(0.20f);  // 20% reduction
    std::cout << "Reduction rate set to: " << (domestic.get_reduction_rate() * 100) << "%" << std::endl;
    std::cout << "Raw price: €" << domestic.get_raw_price() << std::endl;
    std::cout << "Ticket price after reduction: €" << domestic.ticket_price() << std::endl;
    std::cout << std::endl;
    
    // Test 4: Apply different reduction rate (50% discount)
    std::cout << "--- Test 4: Applying 50% reduction to international ticket ---" << std::endl;
    international.set_reduction_rate(0.50f);  // 50% reduction
    std::cout << "Reduction rate set to: " << (international.get_reduction_rate() * 100) << "%" << std::endl;
    std::cout << "Raw price: €" << international.get_raw_price() << std::endl;
    std::cout << "Ticket price after reduction: €" << international.ticket_price() << std::endl;
    std::cout << std::endl;
    
    // Test 5: Copy constructor
    std::cout << "--- Test 5: Testing copy constructor ---" << std::endl;
    Train_ticket copy_ticket = domestic;  // Calls copy constructor
    std::cout << "Original ticket:" << std::endl;
    domestic.display();
    std::cout << "\nCopied ticket:" << std::endl;
    copy_ticket.display();
    
    // Modify the copy to verify deep copy
    std::cout << "\nModifying copied ticket's reduction rate to 30%..." << std::endl;
    copy_ticket.set_reduction_rate(0.30f);
    std::cout << "Original ticket price: €" << domestic.ticket_price() << std::endl;
    std::cout << "Copied ticket price: €" << copy_ticket.ticket_price() << std::endl;
    std::cout << "(Different prices confirm deep copy worked!)" << std::endl;
    
    return 0;
}
