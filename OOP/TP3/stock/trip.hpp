#ifndef TRIP_HPP
#define TRIP_HPP

#include "date.hpp"

class Trip {
    private:
        Date m_start_date;
        Date m_end_date;
        int m_price;

    public:
        Trip(int day_start, int month_start, int year_start,
             int day_end, int month_end, int year_end,
             int price);
        
        Trip(Date start, Date end, int price);
        
        void display();
};

#endif // TRIP_HPP