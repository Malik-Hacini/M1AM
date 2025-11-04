#ifndef DATE_HPP
#define DATE_HPP

#include <iostream>
#include <time.h>

class Date {
    private:
        int m_day;
        int m_month;
        int m_year;
        char* m_day_name;

    public:
        // Constructors
        Date(int d, int m, int y);
        Date(time_t t);
        Date(const Date &d);

        // Destructor
        ~Date();

        // Getters
        int get_day();
        int get_month();
        int get_year();
        char* get_day_name();
        
        // Setters
        void set_day(int d);
        void set_month(int m);
        void set_year(int y);

        // Methods
        void display();
        void happy_birthday(char* name, Date birth_date);

        // Operator overloading (member functions) - NEW FOR LAB 3
        bool operator<(const Date &other) const;
        int operator-(const Date &other) const;

        // Friend functions for accessing private members
        friend bool before(const Date &d1, const Date &d2);
        friend int difference(const Date &d1, const Date &d2);
        friend int duration(const Date &d1, const Date &d2);
        friend std::ostream& operator<<(std::ostream &o, const Date &d);
};

// Other functions (from Lab 1/2)
bool before(const Date &d1, const Date &d2);
int difference(const Date &d1, const Date &d2);
int duration(const Date &d1, const Date &d2);

// Independent operator functions (non-member) - NEW FOR LAB 3
// NOTE: These are commented out to avoid ambiguity with member operators
// Uncomment these and comment out member operators to test independent version
// bool operator<(const Date &d1, const Date &d2);
// int operator-(const Date &d1, const Date &d2);

#endif // DATE_HPP
