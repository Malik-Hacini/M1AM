#include <iostream>
#include <cstdio>
#include <stdio.h>
#include <stdlib.h>
#include <cstring>
#include "tp2.h"

int make_computation (int *x) {
    int i ;
    for ( i =1; i <=4; i++)
        *x = *x * i ;
    return *x ;
}

// Helper function to get day of week based on day of month (for testing)
const char* getDayOfWeek(int day) {
    const char* days[] = {"Sunday", "Monday", "Tuesday", "Wednesday", 
                         "Thursday", "Friday", "Saturday"};
    return days[day % 7];  // Simple arbitrary assignment based on day % 7
}
int main (void) {
    int k ;
    printf ( "Give an integer for the computation " ) ;
    std::cin >> k ;
    std::cout << "Function make_computation returns " <<
    make_computation (&k) << " and the value of k is " << k << std::endl ;
    
    // Test PPoint class
    printf("\n=== Testing PPoint class ===\n");
    
    // Create a point
    PPoint point1(10, 20);
    point1.display();
    
    // Test copy constructor
    PPoint point2 = point1;  // This calls the copy constructor
    point2.display();
    
    // Modify one point
    point1.setX(30);
    printf("After modifying point1:\n");
    point1.display();
    point2.display();  // Should still have original values
    
    printf("=== End of PPoint test ===\n\n");
    
    return 0;
}


Date::Date(int d, int m, int y) : m_day(d), m_month(m), m_year(y) {
    const char* day_name = getDayOfWeek(d);
    m_day_of_week = new char[strlen(day_name) + 1];  // Allocate memory
    strcpy(m_day_of_week, day_name);                 // Copy the string
}

Date::Date(time_t t) {
    struct tm *timeinfo = localtime(&t);
    m_day = timeinfo->tm_mday;
    m_month = timeinfo->tm_mon + 1;
    m_year = timeinfo->tm_year + 1900;
    
    const char* day_name = getDayOfWeek(m_day);
    m_day_of_week = new char[strlen(day_name) + 1];  // Allocate memory
    strcpy(m_day_of_week, day_name);                 // Copy the string
}

// Copy constructor
Date::Date(const Date& other) : m_day(other.m_day), m_month(other.m_month), m_year(other.m_year) {
    m_day_of_week = new char[strlen(other.m_day_of_week) + 1];  // Allocate new memory
    strcpy(m_day_of_week, other.m_day_of_week);                 // Copy the string
}

// Destructor
Date::~Date() {
    delete[] m_day_of_week;  // Free the allocated memory
}

void Date::display() {
    printf("%s, ", m_day_of_week);  // Display day of week first
    switch (m_month) {
        case 1: printf("%d January %d\n", m_day, m_year); break;
        case 2: printf("%d February %d\n", m_day, m_year); break;
        case 3: printf("%d March %d\n", m_day, m_year); break;
        case 4: printf("%d April %d\n", m_day, m_year); break;
        case 5: printf("%d May %d\n", m_day, m_year); break;
        case 6: printf("%d June %d\n", m_day, m_year); break;
        case 7: printf("%d July %d\n", m_day, m_year); break;
        case 8: printf("%d August %d\n", m_day, m_year); break;
        case 9: printf("%d September %d\n", m_day, m_year); break;
        case 10: printf("%d October %d\n", m_day, m_year); break;
        case 11: printf("%d November %d\n", m_day, m_year); break;
        case 12: printf("%d December %d\n", m_day, m_year); break;
    }
}

void Date::happy_birthday(char* name, Date birth_date) {
    if (birth_date.m_day == m_day && birth_date.m_month == m_month) {
        printf("Happy Birthday, %s! You are %i years old !\n", 
               name, m_year - birth_date.m_year);
    }
}

// PPoint class implementation

// Constructor: takes two integers and allocates memory for pointers
PPoint::PPoint(int x_val, int y_val) {
    x = new int(x_val);  // Allocate memory and store x_val
    y = new int(y_val);  // Allocate memory and store y_val
    printf("PPoint constructor: allocated memory for coordinates (%d, %d)\n", x_val, y_val);
}

// Copy constructor: creates deep copy of another PPoint
PPoint::PPoint(const PPoint& other) {
    x = new int(*(other.x));  // Allocate new memory and copy the value
    y = new int(*(other.y));  // Allocate new memory and copy the value
    printf("PPoint copy constructor: created copy of point (%d, %d)\n", *(other.x), *(other.y));
}

// Destructor: frees allocated memory
PPoint::~PPoint() {
    printf("PPoint destructor: freeing memory for point (%d, %d)\n", *x, *y);
    delete x;  // Free memory for x coordinate
    delete y;  // Free memory for y coordinate
}

// Getter methods
int PPoint::getX() const {
    return *x;  // Dereference pointer to get the value
}

int PPoint::getY() const {
    return *y;  // Dereference pointer to get the value
}

// Setter methods
void PPoint::setX(int x_val) {
    *x = x_val;  // Dereference pointer and assign new value
}

void PPoint::setY(int y_val) {
    *y = y_val;  // Dereference pointer and assign new valueWhy are there so much Date::~Date everywhere in the code ? is this not redefinx²x²
}

// Display method
void PPoint::display() const {
    printf("Point coordinates: (%d, %d)\n", *x, *y);
}