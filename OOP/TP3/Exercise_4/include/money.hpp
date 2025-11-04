#ifndef MONEY_HPP
#define MONEY_HPP

#include <iostream>
#include <cstring>

class Dollar{
    private:
        float value;

    public:
        friend std::ostream &operator << (std::ostream &o, const Dollar &d);

        Dollar() : value(0.0f) {}
        Dollar(float val) : value(val) {}

        float get_value() const { return value; }
        void set_value(float val);
};


class Euro{
    private:
        float value;

    public:
        friend std::ostream &operator << (std::ostream &o, const Euro &e);

        Euro() : value(0.0f) {}
        Euro(float val) : value(val) {}

        float get_value() const { return value; }
        void set_value(float val);
};


class Pound{
    private:
        float value;

    public:
        friend std::ostream &operator << (std::ostream &o, const Pound &p);
        
        Pound() : value(0.0f) {}
        Pound(float val) : value(val) {}

        float get_value() const { return value; }
        void set_value(float val);
};

template<class Type_currency>
bool check_type(Type_currency object){
    if (typeid(object) == typeid(Dollar) || typeid(object) == typeid(Euro) || typeid(object) == typeid(Pound)){
        return true;
    }
    return false;
}

#endif 