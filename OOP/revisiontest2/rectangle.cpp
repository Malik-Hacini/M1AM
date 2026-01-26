#include <iostream>

class Rectangle {
    private:
        int width;
        int height;
    public:
        Rectangle() : width(1), height(1) {}

        Rectangle(const int id, int w, int h) : width(w), height(h) {}

        int getArea(){
            return width * height;
        };
        void display(){
            std::cout << "Width: " << width << ", Height: " << height << std::endl;
        };
        bool isSquare(){
            return width == height;
        };
        void scale(int factor){
            width *= factor;
            height *= factor;
        };
};



int main() {
    // r1 using default constructor
    Rectangle r1;
    std::cout << "r1: ";
    r1.display();
    std::cout << "Is r1 a square? " << (r1.isSquare() ? "Yes" : "No") << std::endl;
    
    // r2 with width=4, height=4
    Rectangle r2(4, 4);
    std::cout << "\nr2: ";
    r2.display();
    std::cout << "Is r2 a square? " << (r2.isSquare() ? "Yes" : "No") << std::endl;
    
    // Scale r1 by factor 5
    std::cout << "\nScaling r1 by factor 5..." << std::endl;
    r1.scale(5);
    std::cout << "r1 after scaling: ";
    r1.display();
    std::cout << "Area of r1: " << r1.getArea() << std::endl;
    
    return 0;
}