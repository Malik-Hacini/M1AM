#include <iostream>
#include <string>

class Person {
private:
    std::string name;
    int age;
public:
    Person(const std::string& n, int a) : name(n), age(a) {}
    void setAge(int a) { age = a; }
    int getAge() const { return age; }
    std::string getName() const { return name; }
    void display() const {
        std::cout << name << ", age " << age << std::endl;
    }
};

int main() {
    std::cout << "=== DEREFERENCING EXPLAINED STEP BY STEP ===\n" << std::endl;
    
    // Create a regular object
    Person bob("Bob", 30);
    
    std::cout << "1. We have an object:" << std::endl;
    std::cout << "   Person bob(\"Bob\", 30);" << std::endl;
    std::cout << "   bob = ";
    bob.display();
    
    // Get the address
    std::cout << "\n2. Get the address of bob:" << std::endl;
    std::cout << "   &bob = " << &bob << " (this is the memory address)" << std::endl;
    
    // Create a pointer
    Person* ptr = &bob;
    std::cout << "\n3. Store the address in a pointer:" << std::endl;
    std::cout << "   Person* ptr = &bob;" << std::endl;
    std::cout << "   ptr = " << ptr << " (pointer stores bob's address)" << std::endl;
    
    // Dereference the pointer
    std::cout << "\n4. Dereference the pointer to get the object:" << std::endl;
    std::cout << "   *ptr = the object bob" << std::endl;
    std::cout << "   *ptr = ";
    (*ptr).display();
    
    std::cout << "\n5. Two ways to access members:" << std::endl;
    std::cout << "   a) ptr->getAge() = " << ptr->getAge() << std::endl;
    std::cout << "   b) (*ptr).getAge() = " << (*ptr).getAge() << std::endl;
    std::cout << "   Both are equivalent!" << std::endl;
    
    std::cout << "\n6. Modifying through the pointer:" << std::endl;
    std::cout << "   ptr->setAge(40);" << std::endl;
    ptr->setAge(40);
    std::cout << "   Now bob = ";
    bob.display();
    std::cout << "   The original bob was modified!" << std::endl;
    
    std::cout << "\n\n=== VISUAL MEMORY DIAGRAM ===\n" << std::endl;
    std::cout << "Memory Address: " << &bob << std::endl;
    std::cout << "┌─────────────────────────────────┐" << std::endl;
    std::cout << "│  bob (the actual object)        │" << std::endl;
    std::cout << "│  ┌──────────────────────────┐   │" << std::endl;
    std::cout << "│  │ name: \"Bob\"             │   │" << std::endl;
    std::cout << "│  │ age: 40                  │   │" << std::endl;
    std::cout << "│  └──────────────────────────┘   │" << std::endl;
    std::cout << "└─────────────────────────────────┘" << std::endl;
    std::cout << "         ↑" << std::endl;
    std::cout << "         │ ptr points here" << std::endl;
    std::cout << "         │" << std::endl;
    std::cout << "┌─────────────────┐" << std::endl;
    std::cout << "│ ptr = " << ptr << " │ (stores address)" << std::endl;
    std::cout << "└─────────────────┘" << std::endl;
    
    std::cout << "\n\n=== OPERATOR SUMMARY ===\n" << std::endl;
    std::cout << "bob      = the object itself" << std::endl;
    std::cout << "&bob     = address of bob = " << &bob << std::endl;
    std::cout << "ptr      = pointer storing address = " << ptr << std::endl;
    std::cout << "*ptr     = dereference to get object (same as bob)" << std::endl;
    std::cout << "bob.     = access member of object (dot operator)" << std::endl;
    std::cout << "ptr->    = access member through pointer (arrow operator)" << std::endl;
    std::cout << "(*ptr).  = dereference first, then access (same as ptr->)" << std::endl;
    
    std::cout << "\n\n=== PASSING TO FUNCTIONS ===\n" << std::endl;
    
    // Example functions
    auto byValue = [](Person p) { 
        std::cout << "   Inside function: "; p.display(); 
    };
    auto byReference = [](Person& p) { 
        std::cout << "   Inside function: "; p.display(); 
    };
    auto byPointer = [](Person* p) { 
        std::cout << "   Inside function: "; p->display(); 
    };
    
    std::cout << "If you have: Person bob(\"Bob\", 40);" << std::endl;
    std::cout << "\n  Pass by value:     func(bob)" << std::endl;
    std::cout << "                     ";
    byValue(bob);
    
    std::cout << "\n  Pass by reference: func(bob)" << std::endl;
    std::cout << "                     ";
    byReference(bob);
    
    std::cout << "\n  Pass by pointer:   func(&bob)  ← Need & to get address!" << std::endl;
    std::cout << "                     ";
    byPointer(&bob);
    
    std::cout << "\n\nIf you have: Person* ptr = &bob;" << std::endl;
    std::cout << "\n  Pass by value:     func(*ptr)  ← Need * to dereference!" << std::endl;
    std::cout << "                     ";
    byValue(*ptr);
    
    std::cout << "\n  Pass by reference: func(*ptr)  ← Need * to dereference!" << std::endl;
    std::cout << "                     ";
    byReference(*ptr);
    
    std::cout << "\n  Pass by pointer:   func(ptr)   ← Already a pointer!" << std::endl;
    std::cout << "                     ";
    byPointer(ptr);
    
    std::cout << "\n\n=== KEY TAKEAWAYS ===\n" << std::endl;
    std::cout << "1. & has two meanings:" << std::endl;
    std::cout << "   - In types (Person&): reference" << std::endl;
    std::cout << "   - In expressions (&bob): address-of" << std::endl;
    std::cout << "\n2. * has two meanings:" << std::endl;
    std::cout << "   - In types (Person*): pointer" << std::endl;
    std::cout << "   - In expressions (*ptr): dereference" << std::endl;
    std::cout << "\n3. -> is shorthand:" << std::endl;
    std::cout << "   - ptr->method() is the same as (*ptr).method()" << std::endl;
    std::cout << "\n4. When passing to functions:" << std::endl;
    std::cout << "   - Object → use as-is for value/reference" << std::endl;
    std::cout << "   - Object → use & for pointer parameter" << std::endl;
    std::cout << "   - Pointer → use * for value/reference parameter" << std::endl;
    std::cout << "   - Pointer → use as-is for pointer parameter" << std::endl;
    
    return 0;
}
