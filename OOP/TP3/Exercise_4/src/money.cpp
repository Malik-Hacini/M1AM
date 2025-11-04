#include "money.hpp"

std::ostream &operator << (std::ostream &o, const Dollar &d) {
    o << d.value << " $";
    return o;
}

std::ostream &operator << (std::ostream &o, const Euro &e) {
    o << e.get_value() << " €";
    return o;
}

std::ostream &operator << (std::ostream &o, const Pound &p) {
    o << p.get_value() << " £";
    return o;
}


void Dollar::set_value(float val) {
    value = val;
}

void Euro::set_value(float val) {
    value = val;
}

void Pound::set_value(float val) {
    value = val;
}
