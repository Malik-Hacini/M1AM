// C++ OOP Workshop - TP1
// Learning Object-Oriented Programming concepts in C++
// Author: M1AM Student

#include <iostream>
#include <string>

using namespace std;

// =====================================================
// Date Class Exercise
// =====================================================

class Date {
private:
    int day;
    int month;
    int year;
    
    // Private helper method to validate if a date is correct
    // This is encapsulation - internal logic hidden from users
    bool isValidDate(int d, int m, int y) const {
        // Basic range checks
        if (y < 1970) return false;  // Unix epoch minimum
        if (m < 1 || m > 12) return false;
        if (d < 1) return false;
        
        // Days per month (not handling leap years for simplicity)
        int daysInMonth[] = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
        
        // Simple leap year check for February
        if (m == 2 && isLeapYear(y)) {
            return d <= 29;
        }
        
        return d <= daysInMonth[m - 1];
    }
    
    // Another private helper method
    bool isLeapYear(int y) const {
        return (y % 4 == 0 && y % 100 != 0) || (y % 400 == 0);
    }

public:
    // Constructor with validation
    // If invalid date provided, defaults to Unix Epoch (1 January 1970)
    Date(int d, int m, int y) {
        if (isValidDate(d, m, y)) {
            day = d;
            month = m;
            year = y;
            cout << "✓ Valid date created: ";
        } else {
            // Default to Unix Epoch
            day = 1;
            month = 1;
            year = 1970;
            cout << "⚠ Invalid date (" << d << "/" << m << "/" << y 
                 << ") - defaulting to Unix Epoch: ";
        }
        display();
    }
    
    // Default constructor (Unix Epoch)
    Date() : day(1), month(1), year(1970) {
        cout << "Default date created (Unix Epoch): ";
        display();
    }
    
    // Public methods to access private data (getters)
    // const methods promise not to modify the object
    int getDay() const { return day; }
    int getMonth() const { return month; }
    int getYear() const { return year; }
    
    // Method to display the date
    void display() const {
        cout << day << "/" << month << "/" << year << endl;
    }
    
    // Method to set a new date with validation
    bool setDate(int d, int m, int y) {
        if (isValidDate(d, m, y)) {
            day = d;
            month = m;
            year = y;
            return true;
        }
        return false;  // Date not changed if invalid
    }
};

int main() {
    cout << "=== C++ Date Class Exercise ===\n" << endl;
    
    cout << "Creating various Date objects:\n" << endl;
    
    // Valid dates
    Date date1(25, 12, 2023);  // Christmas 2023
    Date date2(29, 2, 2024);   // Leap year date
    
    cout << endl;
    
    // Invalid dates - should default to Unix Epoch
    Date date3(32, 1, 2023);   // Invalid day
    Date date4(15, 13, 2023);  // Invalid month
    Date date5(15, 6, 1969);   // Year before Unix Epoch
    Date date6(29, 2, 2023);   // Not a leap year
    
    cout << endl;
    
    // Default constructor
    Date date7;  // Should be Unix Epoch
    
    cout << "\n=== Accessing Date Components ===\n" << endl;
    cout << "Date1 components: " << date1.getDay() << "/" 
         << date1.getMonth() << "/" << date1.getYear() << endl;
    
    cout << "\n=== Trying to modify a date ===\n" << endl;
    if (date1.setDate(1, 1, 2025)) {
        cout << "Date1 successfully changed to: ";
        date1.display();
    } else {
        cout << "Failed to change date1" << endl;
    }
    
    // Try invalid modification
    if (!date1.setDate(50, 20, 2025)) {
        cout << "Correctly rejected invalid date (50/20/2025)" << endl;
        cout << "Date1 remains: ";
        date1.display();
    }
    
    return 0;
}

/* 
PEDAGOGICAL NOTES for Python programmers:

1. PRIVATE vs PUBLIC:
   - C++: explicitly declare private/public sections
   - Python: convention with underscore (_private), but not enforced
   
2. CONST METHODS:
   - C++ "const" after method = promise not to modify object state
   - Python: no equivalent, relies on programmer discipline
   
3. MEMBER INITIALIZER LISTS:
   - Date() : day(1), month(1), year(1970) { }
   - More efficient than assignment in constructor body
   - Python __init__ doesn't have this concept
   
4. VALIDATION PATTERN:
   - Private helper methods (isValidDate, isLeapYear)
   - Constructor validates and provides safe defaults
   - Public setter (setDate) also validates before changing
   
5. BOOLEAN RETURN VALUES:
   - setDate returns true/false to indicate success
   - Caller can check if operation succeeded
   - More explicit than Python exceptions for simple validation
*/
