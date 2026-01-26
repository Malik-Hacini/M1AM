#include <iostream>

class Shape{
public:
    virtual double area() = 0;
};

class Circle : public Shape{
    private:
        double radius;
    public:
        Circle(double r) : radius(r) {}
        double area() override {
            return 3.14159 * radius * radius;
        }
};



class Rectangle : public Shape{
    private:
        double width;
        double height;
    public:
        Rectangle(double w, double h) : width(w), height(h) {}
        double area() override {
            return width * height;
        }
};

int main(){
    Shape* shp;
    shp = new Circle(5.0);
    std::cout << "Circle Area: " << shp->area() << std::endl;

    delete shp; // Clean up memory!

    shp = new Rectangle(4.0, 6.0);
    std::cout << "Rectangle Area: " << shp->area() << std::endl;

    delete shp; // Clean up memory!
    return 0;
}