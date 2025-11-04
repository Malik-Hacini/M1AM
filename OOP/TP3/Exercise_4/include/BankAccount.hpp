#ifndef BANKACCOUNT_HPP
#define BANKACCOUNT_HPP

#include "money.hpp"
#include <iostream>

template <class Type_currency> class BankAccount;

template <class Type_currency>
std::ostream &operator << (std::ostream &o, const BankAccount<Type_currency> &b) {
    o << "Owner: " << b.owner_name << ", Balance: " << b.balance;
    return o;
}


template <class Type_currency>
class BankAccount {
    private:
        char* owner_name;
        Type_currency balance;

    public:
        friend std::ostream &operator << <>(std::ostream &o, const BankAccount<Type_currency> &b);

        BankAccount(const char* name, Type_currency initial_balance);
        BankAccount(const BankAccount& other);
        ~BankAccount();

        // Getters
        const Type_currency get_balance() const { return balance; }
        const char* get_owner_name() const { return owner_name; }

        bool credit_balance();
};

template <class Type_currency>
BankAccount<Type_currency>::BankAccount(const char* name, Type_currency initial_balance) {
    owner_name = new char[strlen(name) + 1];
    strcpy(owner_name, name);
    balance = initial_balance;
}

template <class Type_currency>
BankAccount<Type_currency>::BankAccount(const BankAccount& other) {
    owner_name = new char[strlen(other.owner_name) + 1];
    strcpy(owner_name, other.owner_name);
    balance = other.balance;
}

template <class Type_currency>
BankAccount<Type_currency>::~BankAccount() {
    delete[] owner_name;
}

template <class Type_currency>
bool BankAccount<Type_currency>::credit_balance() {
    if (check_type(balance)) {
        if (balance.get_value() > 0) {
            return true;
        }
        return false;
    }
    std::cout << "Money type not supported." << std::endl;
    return false;
}

#endif // BANKACCOUNT_HPP