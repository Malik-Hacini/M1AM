#include "trip.hpp"
#include <iostream>
#include <cstdio>

// Constructors (from reference implementation)

Trip::Trip(int day_start, int month_start, int year_start,
           int day_end, int month_end, int year_end,
           int price)
    : m_start_date(day_start, month_start, year_start),
      m_end_date(day_end, month_end, year_end),
      m_price(price) {}

Trip::Trip(Date start, Date end, int price)
    : m_start_date(start),
      m_end_date(end),
      m_price(price) {}

// Methods (from reference implementation)
void Trip::display() {
    printf("Trip from ");
    m_start_date.display();
    printf(" to ");
    m_end_date.display();
    printf("Price: %d\n", m_price);
}

// ==========================================
// NEW FOR LAB 3: Additional functionality
// ==========================================

// Get duration using operator overloading
int Trip::get_duration() const {
    // Using the overloaded - operator from Date class
    return m_end_date - m_start_date;
}

// Friend function for cout (stream output)
std::ostream& operator<<(std::ostream &o, const Trip &t) {
    o << "Trip from " << t.m_start_date 
      << " to " << t.m_end_date 
      << " (Price: " << t.m_price << " EUR, Duration: " 
      << (t.m_end_date - t.m_start_date) << " days)";
    return o;
}
