#include <iostream>
using namespace std;


// Exercice 8
class Complex {
private:
    float real;
    float imaginary;
public:
    Complex(float r = 0.0, float i = 0.0) : real(r), imaginary(i) {}
    void print_complex() {
        if (imaginary >= 0) {
            cout << real << " + " << imaginary << "i" << endl;
        } else {
            cout << real << " - " << -imaginary << "i" << endl;
        }
    }
    
    Complex operator+(const Complex& other) {
        return Complex(real + other.real, imaginary + other.imaginary);
    }
    
    friend Complex operator+(const Complex& c1, const Complex& c2);
};

Complex operator+(const Complex& c1, const Complex& c2) {
    return Complex(c1.real + c2.real, c1.imaginary + c2.imaginary);
}

int main() {
    Complex c1(3.5, 2.5);  
    Complex c2(1.5, -1.0); 
    
    cout << "First complex number: ";
    c1.print_complex();
    
    cout << "Second complex number: ";
    c2.print_complex();
    
    Complex sum1 = c1 + c2;
    cout << "Sum (using method): ";
    sum1.print_complex();
    
    Complex sum2 = operator+(c1, c2);
    cout << "Sum (using independent function): ";
    sum2.print_complex();
    
    return 0;
}