#include "money.hpp"
#include "BankAccount.hpp"
#include <iostream>

int main() {
    Dollar d(100.5);
    Euro e(50); 

    if (check_type(d) && check_type(e)) {
        BankAccount<Dollar> b1("Paul", d);
        if (b1.credit_balance())
            std::cout << "This account has a credit balance \n";
        else std::cout << "This account has a debit balance \n";

        BankAccount<Euro> b2("Mark", e);
        if (b2.credit_balance())
            std::cout << "This account has a credit balance \n";

        else std::cout << "This account has a debit balance \n";
    }
    return 0;
}