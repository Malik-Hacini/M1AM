#include "trip.hpp"
#include <stdio.h>
#include <stdlib.h>

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

void Trip::display() {
    printf("Trip from ");
    m_start_date.display();
    printf(" to ");
    m_end_date.display();
    printf("Price: %d\n", m_price);
}