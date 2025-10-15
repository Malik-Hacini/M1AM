
#include "TP1.cpp"  // Include the Date class definition
#include <cstring>
#include <iostream>
// When passing a pointer, to increment the value pointed to by the pointer, 
// you need to dereference the pointer first.
void plusone(int *px) {
    (*px)++;
}


// When passing by reference, you can modify the original variable directly.
void addOne(int &y) {
    y++;
}

int main(){
    int y = 5;
    y = 3; // Can modify y directly since it is in the main function's scope
    plusone(&y); // Pass the address of y to plusone to not duplicate memory
    addOne(y); // Pass y by reference to addOne to avoid copying memory
    

    // Exercise 4 - Dynamic Date object creation
    Date *d;
    d = new Date(1, 1, 2025); // Dynamically allocate memory for a Date object
    
    delete d; // Free the allocated memory to prevent memory leaks
}



// Page 18 : Example 1
class MyString {
    private :
    char *s;
    int len;
    public :
    MyString(const MyString &t) {
    s = new char[strlen(t.s)+1];
    strcpy(s,t.s);
    len = t.len;
    }
    // Exercise: write its "classical" constructor
    MyString(const char *str) {
        len = strlen(str);
        s = new char[len+1];
        strcpy(s,str);
    }

    ~MyString() {
        delete[] s;
    }
};


// Exercise 6: Array_of_float class
class Array_of_float {
private:
    float* array;  // Dynamic array of floats
    int length;    // Length of the array

public:
    // Constructor: allocates memory for array of length len, initializes all elements to x
    Array_of_float(int len, float x) {
        length = len;
        array = new float[length];  // Allocate dynamic memory
        
        // Initialize all elements with value x
        for (int i = 0; i < length; i++) {
            array[i] = x;
        }
    }
    
    // Copy constructor: creates a deep copy of another Array_of_float
    Array_of_float(const Array_of_float& other) {
        length = other.length;
        array = new float[length];  // Allocate new memory
        
        // Copy all elements from the other array
        for (int i = 0; i < length; i++) {
            array[i] = other.array[i];
        }
    }
    
    // Destructor: frees the dynamically allocated memory
    ~Array_of_float() {
        delete[] array;  // Free the allocated memory
    }
    
    // Getters (needed for the display_array function)
    float* getArray() const {
        return array;
    }
    
    int getLength() const {
        return length;
    }
    
    // Optional: Overload [] operator for easy access
    float& operator[](int index) {
        return array[index];
    }
    
    const float& operator[](int index) const {
        return array[index];
    }
};

// Independent function to display the contents of an Array_of_float
// Note: We need getters in Array_of_float because the array and length are private
void display_array(const Array_of_float& arr) {
    std::cout << "Array contents: [";
    for (int i = 0; i < arr.getLength(); i++) {
        std::cout << arr.getArray()[i];
        if (i < arr.getLength() - 1) {
            std::cout << ", ";
        }
    }
    std::cout << "]" << std::endl;
    std::cout << "Array length: " << arr.getLength() << std::endl;
}

// Example usage and test function
void test_Array_of_float() {
    std::cout << "\n=== Testing Array_of_float ===\n";
    
    // Create an array of length 5, all elements initialized to 3.14
    Array_of_float arr1(5, 3.14f);
    std::cout << "Original array:" << std::endl;
    display_array(arr1);
    
    // Test copy constructor
    Array_of_float arr2 = arr1;  // This calls the copy constructor
    std::cout << "\nCopied array:" << std::endl;
    display_array(arr2);
    
    // Modify the original array to show deep copy worked
    arr1[0] = 999.0f;
    std::cout << "\nAfter modifying original array:" << std::endl;
    std::cout << "Original: ";
    display_array(arr1);
    std::cout << "Copy (should be unchanged): ";
    display_array(arr2);
    
    std::cout << "\n=== Test completed ===\n";
}