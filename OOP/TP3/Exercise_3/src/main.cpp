#include "MyCollection.hpp"
#include <iostream>
#include <vector>


void init(MyCollection<int> &c, int &k) {
    size_t size = c.get_size();
    size_t capacity = c.get_capacity();

    if (k < 1) {
        std::cout << "Error: k must be strictly positive." << std::endl;
        return;
    }

    if (size + k > capacity) {
        std::cout << "Error: Not enough capacity in the collection." << std::endl;
        return;
    }

    for (int i = 0; i < k; i++) {
        int value = rand() % 10;
        c.insert_elem(value);
    }
}


void init(std::vector<int> &v, int &k) {
    if (k < 1) {
        std::cout << "Error: k must be strictly positive." << std::endl;
        return;
    }

    for (int i = 0; i < k; i++) {
        int value = rand() % 10;
        v.push_back(value);
    }
}


int fac(int n) {
    for (int i = n - 1; i > 1; i--) {
        n *= i;
    }
    return n;
}

void apply_fact(const MyCollection<int> &c, MyCollection<int> &res) {
    size_t csize = c.get_size();
    size_t rcapacity = res.get_capacity();


    if (csize > rcapacity) {
        std::cout << "Error: Not enough capacity in the result collection." << std::endl;
        return;
    }

    for (size_t i = 0; i < csize; i++) {
        int value = c.get_elem(i);
        int insert = fac(value);
        res.insert_elem(insert);
    }
}


void apply_fact(const std::vector<int> &v, std::vector<int> &res) {
    for (int value : v) {
        int insert = fac(value);
        res.push_back(insert);
    }

}


int main() {
    std::cout << "=== MyCollection Tests ===" << std::endl << std::endl;

    //  Normal insertion 
    std::cout << "Test 1: Filling collection to exact capacity" << std::endl;
    MyCollection<int> col1(4);
    std::cout << "Initial state: " << col1 << std::endl;
    int k1 = 4;
    init(col1, k1);
    std::cout << "After init(k=4): " << col1 << std::endl;
    std::cout << "Size: " << col1.get_size() << " / Capacity: " << col1.get_capacity() << std::endl;
    std::cout << std::endl;

    // Partial fill and factorial application
    std::cout << "Test 2: Partial fill and factorial transformation" << std::endl;
    MyCollection<int> col2(6);
    std::cout << "Initial state: " << col2 << std::endl;
    int k2 = 4;
    init(col2, k2);
    std::cout << "After init(k=4): " << col2 << std::endl;
    
    MyCollection<int> colResult(6);
    apply_fact(col2, colResult);
    std::cout << "Factorial result: " << colResult << std::endl;
    std::cout << std::endl;

    // attempting to exceed capacity
    std::cout << "Test 3: Error handling - exceeding capacity" << std::endl;
    MyCollection<int> col3(3);
    std::cout << "Collection with capacity 3: " << col3 << std::endl;
    int k3 = 5;
    init(col3, k3);
    std::cout << "After attempting init(k=5): " << col3 << std::endl;
    std::cout << std::endl;

    // invalid k value
    std::cout << "Test 4: Error handling - invalid k value" << std::endl;
    MyCollection<int> col4(5);
    int k4 = -1;
    init(col4, k4);
    std::cout << "Collection remains: " << col4 << std::endl;
    std::cout << std::endl;

    // out of bounds access
    std::cout << "Test 5: Error handling - out of bounds access" << std::endl;
    MyCollection<int> col5(3);
    int k5 = 2;
    init(col5, k5);
    std::cout << "Collection with 2 elements: " << col5 << std::endl;
    std::cout << "Accessing element at index 1 (valid): " << col5.get_elem(1) << std::endl;
    std::cout << "Accessing element at index 5 (invalid): " << col5.get_elem(5) << std::endl;
    std::cout << std::endl;

    //Insufficient result capacity for factorial
    std::cout << "Test 6: Error handling - insufficient result capacity" << std::endl;
    MyCollection<int> col6(4);
    int k6 = 4;
    init(col6, k6);
    std::cout << "Source collection: " << col6 << std::endl;
    MyCollection<int> colSmall(2);
    std::cout << "Small result collection (capacity 2): " << colSmall << std::endl;
    apply_fact(col6, colSmall);
    std::cout << std::endl;

    std::cout << "=== std::vector Tests ===" << std::endl << std::endl;

    // Vector with normal initialization
    std::cout << "Test 7: Vector initialization" << std::endl;
    std::vector<int> vec1;
    std::cout << "Empty vector size: " << vec1.size() << std::endl;
    int k7 = 5;
    init(vec1, k7);
    std::cout << "After init(k=5), size: " << vec1.size() << " - Elements: ";
    for (int v : vec1) std::cout << v << " ";
    std::cout << std::endl << std::endl;

    // Vector factorial transformation
    std::cout << "Test 8: Vector factorial transformation" << std::endl;
    std::vector<int> vecResult;
    apply_fact(vec1, vecResult);
    std::cout << "Factorial result, size: " << vecResult.size() << " - Elements: ";
    for (int v : vecResult) std::cout << v << " ";
    std::cout << std::endl << std::endl;

    //  Vector with invalid k
    std::cout << "Test 9: Vector error handling - invalid k" << std::endl;
    std::vector<int> vec2;
    int k9 = 0;
    init(vec2, k9);
    std::cout << "Vector after init(k=0), size: " << vec2.size() << std::endl;
    std::cout << std::endl;

    // Large vector initialization
    std::cout << "Test 10: Large vector initialization" << std::endl;
    std::vector<int> vec3;
    int k10 = 10;
    init(vec3, k10);
    std::cout << "After init(k=10), size: " << vec3.size() << " - First 5 elements: ";
    for (size_t i = 0; i < 5 && i < vec3.size(); i++) {
        std::cout << vec3[i] << " ";
    }
    std::cout << "..." << std::endl;

    return 0;
}