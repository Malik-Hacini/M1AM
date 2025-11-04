#ifndef DATE_HPP
#define DATE_HPP

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

        // Destrutor
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

};



// Other functions
bool before(const Date &d1, const Date &d2);
int difference(const Date &d1, const Date &d2);
int duration(const Date &d1, const Date &d2);

#endif // DATE_HPP