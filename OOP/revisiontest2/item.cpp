#include <iostream>

class Item{
    private: 
        int reference;
        float cost_price;
    public:
        Item(int ref, float cost) : reference(ref), cost_price(cost) {}
        void display(){
            std::cout << "Reference:" << reference << ", Cost Price: " << cost_price << std::endl;
        }
};


class DiscountedItem : public Item{
    private:
        float discount_rate;
    public:
        DiscountedItem(int ref, float cost, float discount) : Item(ref, cost), discount_rate(discount) {}
        void display(){
            Item::display();
            std::cout << "Discount Rate: " << discount_rate << std::endl;
        }

};

int main(){
    Item item1(123, 15.50);
    DiscountedItem item2(456, 25.99, 0.20);
    
    std::cout << "Item 1:" << std::endl;
    item1.display();
    
    std::cout << "\nDiscounted Item 2:" << std::endl;
    item2.display();
    
    return 0;
}