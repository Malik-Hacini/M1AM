#include <iostream>
#include <string>

// Simple class for demonstration
class Person {
private:
    std::string name;
    int age;
    
public:
    Person(const std::string& n, int a) : name(n), age(a) {
        std::cout << "  [Constructor called for " << name << "]" << std::endl;
    }
    
    // Copy constructor - to see when copies are made
    Person(const Person& other) : name(other.name), age(other.age) {
        std::cout << "  [COPY constructor called for " << name << "]" << std::endl;
    }
    
    void setAge(int a) { age = a; }
    int getAge() const { return age; }
    std::string getName() const { return name; }
    
    void display() const {
        std::cout << "    " << name << ", age " << age << std::endl;
    }
};

// ============================================================================
// METHOD 1: PASS BY VALUE (makes a COPY)
// ============================================================================
void modifyByValue(Person p) {  // p is a COPY of the original
    std::cout << "  Inside modifyByValue - before change:" << std::endl;
    p.display();
    
    p.setAge(999);  // Modifies the COPY, not the original!
    
    std::cout << "  Inside modifyByValue - after change:" << std::endl;
    p.display();
}

// ============================================================================
// METHOD 2: PASS BY REFERENCE (no copy, direct access to original)
// ============================================================================
void modifyByReference(Person& p) {  // p is a REFERENCE to the original
    std::cout << "  Inside modifyByReference - before change:" << std::endl;
    p.display();
    
    p.setAge(888);  // Modifies the ORIGINAL!
    
    std::cout << "  Inside modifyByReference - after change:" << std::endl;
    p.display();
}

// ============================================================================
// METHOD 3: PASS BY CONST REFERENCE (read-only access, no copy)
// ============================================================================
void displayByConstReference(const Person& p) {  // const = can't modify
    std::cout << "  Inside displayByConstReference:" << std::endl;
    p.display();
    
    // p.setAge(777);  // ERROR! Can't modify through const reference
}

// ============================================================================
// METHOD 4: PASS BY POINTER (pass the address)
// ============================================================================
void modifyByPointer(Person* p) {  // p is a POINTER to the original
    if (p == nullptr) {  // Always check for null!
        std::cout << "  Null pointer!" << std::endl;
        return;
    }
    
    std::cout << "  Inside modifyByPointer - before change:" << std::endl;
    p->display();  // Use -> to access members through pointer
    
    p->setAge(666);  // Modifies the ORIGINAL!
    
    std::cout << "  Inside modifyByPointer - after change:" << std::endl;
    p->display();
}

// ============================================================================
// METHOD 5: PASS BY CONST POINTER (read-only through pointer)
// ============================================================================
void displayByConstPointer(const Person* p) {  // const = can't modify
    if (p == nullptr) {
        std::cout << "  Null pointer!" << std::endl;
        return;
    }
    
    std::cout << "  Inside displayByConstPointer:" << std::endl;
    p->display();
    
    // p->setAge(555);  // ERROR! Can't modify through const pointer
}

// ============================================================================
// SPECIAL: Understanding DEREFERENCING
// ============================================================================
void demonstrateDereferencing() {
    std::cout << "\n=== UNDERSTANDING DEREFERENCING ===\n" << std::endl;
    
    Person alice("Alice", 25);
    Person* ptr = &alice;  // ptr stores the ADDRESS of alice
    
    std::cout << "alice (the object itself):" << std::endl;
    alice.display();
    
    std::cout << "\nptr (the pointer - stores address):" << std::endl;
    std::cout << "  Address stored in ptr: " << ptr << std::endl;
    
    std::cout << "\n*ptr (dereferencing - gets the object):" << std::endl;
    (*ptr).display();  // *ptr gets the object, then use .
    
    std::cout << "\nptr-> (shorthand for (*ptr).):" << std::endl;
    ptr->display();  // Equivalent to (*ptr).display()
    
    std::cout << "\n&alice (address-of operator - gets the address):" << std::endl;
    std::cout << "  Address of alice: " << &alice << std::endl;
}

// ============================================================================
// MAIN DEMONSTRATION
// ============================================================================
int main() {
    std::cout << "=== CREATING ORIGINAL PERSON ===" << std::endl;
    Person bob("Bob", 30);
    bob.display();
    
    // ========================================================================
    std::cout << "\n\n=== METHOD 1: PASS BY VALUE ===" << std::endl;
    std::cout << "Calling modifyByValue(bob)..." << std::endl;
    modifyByValue(bob);  // Passes a COPY
    
    std::cout << "\nAfter modifyByValue, original bob is:" << std::endl;
    bob.display();
    std::cout << "👉 Age is still 30! The function modified a COPY, not the original." << std::endl;
    
    // ========================================================================
    std::cout << "\n\n=== METHOD 2: PASS BY REFERENCE ===" << std::endl;
    std::cout << "Calling modifyByReference(bob)..." << std::endl;
    modifyByReference(bob);  // Passes a REFERENCE (alias)
    
    std::cout << "\nAfter modifyByReference, original bob is:" << std::endl;
    bob.display();
    std::cout << "👉 Age changed to 888! The function modified the ORIGINAL." << std::endl;
    
    // Reset for next test
    bob.setAge(30);
    
    // ========================================================================
    std::cout << "\n\n=== METHOD 3: PASS BY CONST REFERENCE ===" << std::endl;
    std::cout << "Calling displayByConstReference(bob)..." << std::endl;
    displayByConstReference(bob);  // Read-only reference
    std::cout << "👉 Can read but cannot modify. No copy made (efficient!)." << std::endl;
    
    // ========================================================================
    std::cout << "\n\n=== METHOD 4: PASS BY POINTER ===" << std::endl;
    std::cout << "Calling modifyByPointer(&bob)..." << std::endl;
    std::cout << "(Notice: we pass &bob, which is bob's ADDRESS)" << std::endl;
    modifyByPointer(&bob);  // Pass the ADDRESS of bob
    
    std::cout << "\nAfter modifyByPointer, original bob is:" << std::endl;
    bob.display();
    std::cout << "👉 Age changed to 666! The function modified the ORIGINAL through the pointer." << std::endl;
    
    // Reset for next test
    bob.setAge(30);
    
    // ========================================================================
    std::cout << "\n\n=== METHOD 5: PASS BY CONST POINTER ===" << std::endl;
    std::cout << "Calling displayByConstPointer(&bob)..." << std::endl;
    displayByConstPointer(&bob);  // Read-only pointer
    std::cout << "👉 Can read through pointer but cannot modify." << std::endl;
    
    // ========================================================================
    demonstrateDereferencing();
    
    // ========================================================================
    std::cout << "\n\n=== WORKING WITH DYNAMICALLY ALLOCATED OBJECTS ===" << std::endl;
    Person* charlie_ptr = new Person("Charlie", 35);
    
    std::cout << "\nWe have: Person* charlie_ptr = new Person(...);" << std::endl;
    std::cout << "charlie_ptr is a POINTER to a Person object on the heap" << std::endl;
    
    std::cout << "\nAccessing through pointer:" << std::endl;
    charlie_ptr->display();  // Use -> for pointers
    
    std::cout << "\nPassing pointer to function:" << std::endl;
    modifyByPointer(charlie_ptr);  // Already a pointer, pass it directly
    
    std::cout << "\nAlternative: pass by reference using *charlie_ptr:" << std::endl;
    modifyByReference(*charlie_ptr);  // *charlie_ptr dereferences to get the object
    charlie_ptr->display();
    
    delete charlie_ptr;  // Clean up heap memory
    
    return 0;
}
