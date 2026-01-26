#include <iostream>
#include <string>

using namespace std;

#define VAT_DISC 0.18
#define VAT_NOTDISC 0.2

class Item {
    protected:
       int reference;
       string designation;  // C++ string, not char!
       int in_stock;
       float VAT;
       float cost_price;
    
    public:
        Item(int ref, string des, float vat, float cost);
        float compute_sale_price() const;
        Item& operator+=(int quantity);  // operator+=, returns reference
        void print_data(ostream& os) const;    // const method

};


Item::Item(int ref, string des, float vat, float cost) 
    : reference(ref), designation(des), in_stock(0), VAT(vat), cost_price(cost) {}

float Item::compute_sale_price() const {
    return cost_price * (1 + VAT);
}

Item& Item::operator+=(int quantity){
    in_stock += quantity;
    return *this;  // return the current object by reference
}

void Item::print_data(ostream& os) const {
    os << "Reference: " << reference << ", Designation: " << designation 
       << ", In Stock: " << in_stock << ", Cost Price: " << cost_price 
       << ", Cost Price: " << cost_price << endl;
}

class DiscountedItem : public Item {
    friend ostream& operator<<(ostream& os, const DiscountedItem& item);
    private:
        float discount_rate;
    public:
        DiscountedItem(int ref, string des, float cost, float discount) 
            : Item(ref, des, VAT_DISC, cost), discount_rate(discount) {}
        float compute_sale_price() const {
            float base_price = Item::compute_sale_price();
            return base_price - (discount_rate * cost_price);  // Subtract absolute amount
        }
        void print_data(ostream& os) const {
            Item::print_data(os);
            os << "Discount Rate: " << discount_rate 
               << ", Sale Price: " << compute_sale_price() << endl;
        }
};



class NotDiscountedItem : public Item {
     friend ostream& operator<<(ostream& os, const NotDiscountedItem& item);
     public:
        NotDiscountedItem(int ref, string des, float cost) 
            : Item(ref, des, VAT_NOTDISC, cost) {}
};


class DeliverableItem : public NotDiscountedItem {
    friend ostream& operator<<(ostream& os, const DeliverableItem& item);
    private:
        float transport_price;
    public:
        DeliverableItem(int ref, string des, float cost, float transport) 
            : NotDiscountedItem(ref, des, cost), transport_price(transport) {}
        bool transport_price_adequate() const {
            return transport_price < 0.03 * compute_sale_price();
        }
        void print_data(ostream& os) const {
            NotDiscountedItem::print_data(os);
            os << "Transport Price: " << transport_price 
               << ", Adequate Transport Price: " 
               << (transport_price_adequate() ? "Yes" : "No") << endl;
        }
};

// Operator<< overloadings
ostream& operator<<(ostream& os, const DiscountedItem& item) {
    item.print_data(os);
    return os;
}

ostream& operator<<(ostream& os, const NotDiscountedItem& item) {
    item.print_data(os);
    return os;
}

ostream& operator<<(ostream& os, const DeliverableItem& item) {
    item.print_data(os);
    return os;
}


int main(){
    Item item1(123, "scarf", 0.1, 15.60);
    DiscountedItem item2(456, "socks", 9.9, 0.2);
    NotDiscountedItem item3(789, "coat", 200.5);
    DeliverableItem item4(1011, "seat", 400, 27.3);

    item1 += 20;
    item1.print_data(cout);
    
    // Test operator<< overloadings
    cout << "\nTesting operator<<:\n";
    cout << "Item2: " << item2;
    cout << "Item3: " << item3;
    cout << "Item4: " << item4;

    return 0;
}