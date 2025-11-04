#include "date.hpp"
#include <iostream>
#include <cstdio>
#include <cstdlib>
#include <cstring>

// Constructors (from reference implementation)

Date::Date(int d, int m, int y) : m_day(d), m_month(m), m_year(y), m_day_name(nullptr) {
    // Note: day_name based on day number (1-7) not actual day of week calculation
    switch (d % 7)
    {
    case 1: m_day_name = (char*)"Monday"; break;
    case 2: m_day_name = (char*)"Tuesday"; break;
    case 3: m_day_name = (char*)"Wednesday"; break;
    case 4: m_day_name = (char*)"Thursday"; break;
    case 5: m_day_name = (char*)"Friday"; break;
    case 6: m_day_name = (char*)"Saturday"; break;
    case 0: m_day_name = (char*)"Sunday"; break;
    default: m_day_name = (char*)"Unknown";
    };
}

Date::Date(time_t t) : m_day_name(nullptr) {
    struct tm *timeinfo = localtime(&t);
    m_day = timeinfo->tm_mday;
    m_month = timeinfo->tm_mon + 1;
    m_year = timeinfo->tm_year + 1900;

    switch (timeinfo->tm_wday)
    {
    case 1: m_day_name = (char*)"Monday"; break;
    case 2: m_day_name = (char*)"Tuesday"; break;
    case 3: m_day_name = (char*)"Wednesday"; break;
    case 4: m_day_name = (char*)"Thursday"; break;
    case 5: m_day_name = (char*)"Friday"; break;
    case 6: m_day_name = (char*)"Saturday"; break;
    case 0: m_day_name = (char*)"Sunday"; break;
    default: m_day_name = (char*)"Unknown";
    };
}

Date::Date(const Date &d){
    m_day = d.m_day;
    m_month = d.m_month;
    m_year = d.m_year;
    // Just copy the pointer since it points to string literals
    m_day_name = d.m_day_name;
}

// Destructor (from reference implementation)
Date::~Date() {
    // Don't free m_day_name as it points to string literals
}

// Methods (from reference implementation)
void Date::display() {
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

// Getters (from reference implementation)
int Date::get_day() {
    return m_day;
}

int Date::get_month() {
    return m_month;
}

int Date::get_year() {
    return m_year;
}

char* Date::get_day_name() {
    return m_day_name;
}

// Setters (from reference implementation)
void Date::set_day(int d) {
    m_day = d;
    switch (d % 7)
    {
    case 1: m_day_name = (char*)"Monday"; break;
    case 2: m_day_name = (char*)"Tuesday"; break;
    case 3: m_day_name = (char*)"Wednesday"; break;
    case 4: m_day_name = (char*)"Thursday"; break;
    case 5: m_day_name = (char*)"Friday"; break;
    case 6: m_day_name = (char*)"Saturday"; break;
    case 0: m_day_name = (char*)"Sunday"; break;
    default: m_day_name = (char*)"Unknown";
    }
}

void Date::set_month(int m) {
    m_month = m;
}

void Date::set_year(int y) {
    m_year = y;
}

// Other functions (from reference implementation)
bool before(const Date &d1, const Date &d2) {
    if(d1.m_year < d2.m_year) return true;
    if(d1.m_year == d2.m_year && d1.m_month < d2.m_month) return true;
    if(d1.m_year == d2.m_year && d1.m_month == d2.m_month && d1.m_day < d2.m_day) return true;
    return false;
}

int difference(const Date &d1, const Date &d2) {
    if(before(d1, d2)) {
        return (d2.m_year - d1.m_year)*365 + (d2.m_month - d1.m_month)*30 + (d2.m_day - d1.m_day);
    }
    printf("Error: d1 is not before d2\n");
    return 0;
}

int duration(const Date &d1, const Date &d2) {
    if(before(d1, d2)) {
        return difference(d1, d2);
    }
    return difference(d2, d1);
}

// ==========================================
// NEW FOR LAB 3: OPERATOR OVERLOADING
// ==========================================

// Member function operator< - calls before()
bool Date::operator<(const Date &other) const {
    return before(*this, other);
}

// Member function operator- - calls difference()
int Date::operator-(const Date &other) const {
    return difference(other, *this);
}

// Friend function for cout (stream output)
std::ostream& operator<<(std::ostream &o, const Date &d) {
    o << d.m_day << "/";
    if (d.m_month < 10) o << "0";
    o << d.m_month << "/" << d.m_year;
    return o;
}

// ==========================================
// Independent (non-member) operator functions
// Commented out to avoid ambiguity - uncomment to test
// ==========================================
/*
bool operator<(const Date &d1, const Date &d2) {
    return before(d1, d2);
}

int operator-(const Date &d1, const Date &d2) {
    return difference(d2, d1);
}
*/
