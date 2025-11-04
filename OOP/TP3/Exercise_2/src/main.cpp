#include "date.hpp"
#include "trip.hpp"
#include <iostream>

int main() {
    std::cout << "=== Exercise 2: Date and Trip with Operator Overloading ===" << std::endl;
    std::cout << std::endl;

    Date d1(15, 3, 2025);
    Date d2(20, 3, 2025);
    Date d3(10, 4, 2025);
    
    std::cout << "Date 1: " << d1 << std::endl;
    std::cout << "Date 2: " << d2 << std::endl;
    std::cout << "Date 3: " << d3 << std::endl;
    std::cout << std::endl;

    // Test operator< (calls before())
    std::cout << "Testing operator<:" << std::endl;
    std::cout << "d1 < d2: " << (d1 < d2 ? "true" : "false") << std::endl;
    std::cout << "d2 < d1: " << (d2 < d1 ? "true" : "false") << std::endl;
    std::cout << std::endl;

    // Test operator- (calls difference())
    std::cout << "Testing operator-:" << std::endl;
    std::cout << "d2 - d1 = " << (d2 - d1) << " days" << std::endl;
    std::cout << "d3 - d1 = " << (d3 - d1) << " days" << std::endl;
    std::cout << std::endl;

    // Create trips
    std::cout << "Creating trips:" << std::endl;
    Trip trip1(10, 6, 2025, 20, 6, 2025, 500);
    Trip trip2(d1, d3, 800);
    
    std::cout << "Trip 1: " << trip1 << std::endl;
    std::cout << "Trip 2: " << trip2 << std::endl;
    std::cout << std::endl;

    // Compare trip dates using overloaded operators
    std::cout << "Comparing trip dates:" << std::endl;
    if (trip1.get_start_date() < trip2.get_start_date()) {
        std::cout << "Trip 1 starts before Trip 2" << std::endl;
    } else {
        std::cout << "Trip 2 starts before Trip 1" << std::endl;
    }
    
    int days_between = trip2.get_start_date() - trip1.get_end_date();
    std::cout << "Days between trips: " << days_between << " days" << std::endl;

    return 0;
}
