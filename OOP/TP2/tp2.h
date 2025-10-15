#ifndef TP2_H
#define TP2_H

#include <ctime>
#include <cstring>

// Function declaration (just the signature)
int make_computation(int *x);

// Date class declaration
class Date {
private:
    int m_day;
    int m_month;
    int m_year;
    char* m_day_of_week;  // New attribute for day of the week

public:
    // Constructors
    Date(int d, int m, int y);
    Date(time_t t);
    Date(const Date& other);  // Copy constructor
    
    // Destructor
    ~Date();
    
    // Methods
    void display();
    void happy_birthday(char* name, Date birth_date);
};

// PPoint class declaration
class PPoint {
private:
    int* x;  // Pointer to integer for x coordinate
    int* y;  // Pointer to integer for y coordinate

public:
    // Constructor
    PPoint(int x_val, int y_val);
    
    // Copy constructor (needed for pointer management)
    PPoint(const PPoint& other);
    
    // Destructor (needed to free allocated memory)
    ~PPoint();
    
    // Methods to access coordinates
    int getX() const;
    int getY() const;
    void setX(int x_val);
    void setY(int y_val);
    void display() const;
};

#endif