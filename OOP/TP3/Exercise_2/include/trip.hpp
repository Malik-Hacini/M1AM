#ifndef TRIP_HPP
#define TRIP_HPP

#include "date.hpp"
#include <iostream>

class Trip {
    private:
        Date m_start_date;
        Date m_end_date;
        int m_price;

    public:
        // Constructors (from reference implementation)
        Trip(int day_start, int month_start, int year_start,
             int day_end, int month_end, int year_end,
             int price);
        
        Trip(Date start, Date end, int price);
        
        // Methods (from reference implementation)
        void display();

        // Getters - NEW FOR LAB 3
        Date get_start_date() const { return m_start_date; }
        Date get_end_date() const { return m_end_date; }
        int get_price() const { return m_price; }
        int get_duration() const;

        // Friend for cout - NEW FOR LAB 3
        friend std::ostream& operator<<(std::ostream &o, const Trip &t);
};

#endif // TRIP_HPP
