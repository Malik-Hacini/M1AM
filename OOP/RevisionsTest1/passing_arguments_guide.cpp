/*
 * COMPLETE GUIDE TO PASSING ARGUMENTS IN C++
 * ===========================================
 * 
 * This guide explains the 5 main ways to pass arguments and how to work with them.
 */

// ============================================================================
// OPERATORS YOU NEED TO KNOW
// ============================================================================

/*
 * & - Has TWO different meanings depending on context:
 * 
 * 1. In TYPE declaration: means "reference"
 *    void func(Person& p)  // p is a reference to a Person
 * 
 * 2. In EXPRESSION: means "address-of" 
 *    &bob  // Get the address (memory location) of bob
 * 
 * * - Has TWO different meanings depending on context:
 * 
 * 1. In TYPE declaration: means "pointer"
 *    Person* ptr;  // ptr is a pointer to a Person
 * 
 * 2. In EXPRESSION: means "dereference" (get the object the pointer points to)
 *    *ptr  // Get the object that ptr points to
 * 
 * -> - Arrow operator: shorthand for accessing members through a pointer
 *    ptr->method()  is the same as  (*ptr).method()
 */

// ============================================================================
// METHOD 1: PASS BY VALUE
// ============================================================================

void func1(Person p) {
    // p is a COPY of the original
    p.setAge(100);  // Modifies the COPY only
}

/*
 * HOW TO CALL:
 *   Person bob("Bob", 30);
 *   func1(bob);  // Pass the object directly
 * 
 * WHAT HAPPENS:
 *   - Copy constructor is called
 *   - A NEW object is created (the copy)
 *   - Function works with the copy
 *   - Original is NOT modified
 * 
 * MEMORY DIAGRAM:
 *   Original bob (in caller):        Copy p (in function):
 *   ┌──────────────┐                ┌──────────────┐
 *   │ name: "Bob"  │                │ name: "Bob"  │
 *   │ age: 30      │                │ age: 100     │  ← Changed!
 *   └──────────────┘                └──────────────┘
 *   Different objects in memory!
 * 
 * WHEN TO USE:
 *   - When you want to work with a copy
 *   - Small objects (int, float, small structs)
 * 
 * DISADVANTAGES:
 *   - Slow for large objects (copy is expensive)
 *   - Can't modify the original
 */

// ============================================================================
// METHOD 2: PASS BY REFERENCE
// ============================================================================

void func2(Person& p) {
    // p is an ALIAS (another name) for the original
    p.setAge(100);  // Modifies the ORIGINAL!
}

/*
 * HOW TO CALL:
 *   Person bob("Bob", 30);
 *   func2(bob);  // Pass the object directly (looks same as by-value!)
 * 
 * WHAT HAPPENS:
 *   - NO copy is made
 *   - p is just another name for the original bob
 *   - Any changes to p affect the original
 * 
 * MEMORY DIAGRAM:
 *   Original bob (in caller):
 *   ┌──────────────┐
 *   │ name: "Bob"  │  ← p is just another name for this!
 *   │ age: 100     │  ← Changed through p
 *   └──────────────┘
 *   Only ONE object in memory!
 * 
 * WHEN TO USE:
 *   - When you want to modify the original
 *   - To avoid expensive copying
 * 
 * SYNTAX TO REMEMBER:
 *   - Use . (dot) to access members: p.setAge(100)
 *   - Same as if p were a regular object
 */

// ============================================================================
// METHOD 3: PASS BY CONST REFERENCE
// ============================================================================

void func3(const Person& p) {
    // p is an ALIAS (read-only) for the original
    int age = p.getAge();  // Can read
    // p.setAge(100);       // ERROR! Can't modify through const reference
}

/*
 * HOW TO CALL:
 *   Person bob("Bob", 30);
 *   func3(bob);  // Pass the object directly
 * 
 * WHAT HAPPENS:
 *   - NO copy is made (efficient!)
 *   - p is a read-only alias to the original
 *   - Cannot modify through p
 * 
 * WHEN TO USE:
 *   - When you only need to READ (not modify)
 *   - MOST COMMON for passing objects efficiently
 *   - Best practice for getters and display functions
 * 
 * WHY IT'S IMPORTANT:
 *   - Fast (no copy)
 *   - Safe (can't accidentally modify)
 *   - This is what you should use most of the time!
 */

// ============================================================================
// METHOD 4: PASS BY POINTER
// ============================================================================

void func4(Person* p) {
    // p is a POINTER (stores the address of the original)
    if (p != nullptr) {  // Always check!
        p->setAge(100);   // Use -> to access members
        // OR
        (*p).setAge(100); // Dereference first, then use .
    }
}

/*
 * HOW TO CALL:
 *   Person bob("Bob", 30);
 *   func4(&bob);  // Pass the ADDRESS of bob using &
 * 
 * WHAT HAPPENS:
 *   - NO copy is made
 *   - p stores the memory address of bob
 *   - Function accesses bob through the pointer
 *   - Changes affect the original
 * 
 * MEMORY DIAGRAM:
 *   Original bob (in caller):     Pointer p (in function):
 *   ┌──────────────┐              ┌──────────────┐
 *   │ name: "Bob"  │  ←───────────│ [address]    │
 *   │ age: 100     │              └──────────────┘
 *   └──────────────┘              p points to bob
 * 
 * WHEN TO USE:
 *   - When you need to pass nullptr (no object)
 *   - C-style code or working with legacy code
 *   - When you already have a pointer
 * 
 * SYNTAX TO REMEMBER:
 *   - Use -> (arrow) to access members: p->setAge(100)
 *   - OR dereference first: (*p).setAge(100)
 *   - Always check for nullptr!
 * 
 * CALLING WITH DIFFERENT SCENARIOS:
 *   Person bob("Bob", 30);
 *   Person* ptr = &bob;
 *   
 *   func4(&bob);    // Pass address of regular object
 *   func4(ptr);     // Pass pointer directly (already have address)
 */

// ============================================================================
// METHOD 5: PASS BY CONST POINTER
// ============================================================================

void func5(const Person* p) {
    // p is a POINTER (read-only) to the original
    if (p != nullptr) {
        int age = p->getAge();  // Can read
        // p->setAge(100);       // ERROR! Can't modify through const pointer
    }
}

/*
 * HOW TO CALL:
 *   Person bob("Bob", 30);
 *   func5(&bob);  // Pass the ADDRESS of bob
 * 
 * WHEN TO USE:
 *   - When you need pointer semantics (can be nullptr)
 *   - But you only want to read, not modify
 */

// ============================================================================
// WORKING WITH POINTERS: THE KEY CONCEPTS
// ============================================================================

/*
 * SCENARIO A: You have a regular object
 * --------------------------------------
 * Person bob("Bob", 30);
 * 
 * - bob is the object itself
 * - &bob is the address of bob
 * - Use . to access members: bob.setAge(100)
 * 
 * Calling functions:
 *   func1(bob);      // Pass by value
 *   func2(bob);      // Pass by reference
 *   func3(bob);      // Pass by const reference
 *   func4(&bob);     // Pass by pointer (need &)
 *   func5(&bob);     // Pass by const pointer (need &)
 */

/*
 * SCENARIO B: You have a pointer to an object
 * --------------------------------------------
 * Person* ptr = new Person("Alice", 25);
 * 
 * - ptr is a pointer (stores an address)
 * - *ptr is the object (dereferencing the pointer)
 * - Use -> to access members: ptr->setAge(100)
 * - OR dereference first: (*ptr).setAge(100)
 * 
 * Calling functions:
 *   func1(*ptr);     // Pass by value (dereference to get object)
 *   func2(*ptr);     // Pass by reference (dereference to get object)
 *   func3(*ptr);     // Pass by const reference (dereference to get object)
 *   func4(ptr);      // Pass by pointer (already a pointer!)
 *   func5(ptr);      // Pass by const pointer (already a pointer!)
 */

// ============================================================================
// UNDERSTANDING DEREFERENCING
// ============================================================================

/*
 * DEREFERENCING = "Following the pointer to get the object"
 * 
 * Example:
 *   Person bob("Bob", 30);
 *   Person* ptr = &bob;   // ptr now stores bob's address
 * 
 * Now we have:
 *   ptr        → The pointer itself (an address)
 *   *ptr       → The object the pointer points to (bob)
 *   ptr->age   → Access member through pointer
 *   (*ptr).age → Equivalent: dereference first, then use .
 * 
 * Visual:
 *   ptr = [0x1234]  →  points to  →  bob at address 0x1234
 *                                     ┌──────────────┐
 *                                     │ name: "Bob"  │
 *                                     │ age: 30      │
 *                                     └──────────────┘
 *   *ptr = the object above (bob)
 */

// ============================================================================
// QUICK REFERENCE TABLE
// ============================================================================

/*
 * METHOD              | FUNCTION SIGNATURE      | HOW TO CALL    | MODIFIES ORIGINAL? | COPY MADE?
 * ------------------- | ----------------------- | -------------- | ------------------ | ----------
 * Pass by value       | void f(Person p)        | f(bob)         | NO                 | YES
 * Pass by reference   | void f(Person& p)       | f(bob)         | YES                | NO
 * Pass by const ref   | void f(const Person& p) | f(bob)         | NO (read-only)     | NO
 * Pass by pointer     | void f(Person* p)       | f(&bob)        | YES                | NO
 * Pass by const ptr   | void f(const Person* p) | f(&bob)        | NO (read-only)     | NO
 * 
 * BEST PRACTICES:
 * - Default: Use const reference (efficient and safe)
 * - Need to modify: Use reference
 * - Can be null: Use pointer
 * - Primitive types (int, float): Use by value (they're small)
 */

// ============================================================================
// COMMON MISTAKES AND HOW TO AVOID THEM
// ============================================================================

/*
 * MISTAKE 1: Confusing & in types vs expressions
 * ------------------------------------------------
 * Person& p        // & in type = reference
 * &bob             // & in expression = address-of
 * 
 * MISTAKE 2: Confusing * in types vs expressions
 * ------------------------------------------------
 * Person* ptr      // * in type = pointer
 * *ptr             // * in expression = dereference
 * 
 * MISTAKE 3: Using . instead of -> on pointers
 * ----------------------------------------------
 * Person* ptr = &bob;
 * ptr.setAge(100);    // ERROR! ptr is a pointer, use ->
 * ptr->setAge(100);   // CORRECT!
 * 
 * MISTAKE 4: Using -> instead of . on objects
 * --------------------------------------------
 * Person bob("Bob", 30);
 * bob->setAge(100);   // ERROR! bob is an object, use .
 * bob.setAge(100);    // CORRECT!
 * 
 * MISTAKE 5: Forgetting & when passing to pointer parameter
 * ----------------------------------------------------------
 * void func(Person* p);
 * Person bob("Bob", 30);
 * func(bob);          // ERROR! Need address
 * func(&bob);         // CORRECT!
 * 
 * MISTAKE 6: Not checking for nullptr
 * ------------------------------------
 * void func(Person* p) {
 *     p->setAge(100);  // DANGEROUS! What if p is nullptr?
 * }
 * // ALWAYS check:
 * void func(Person* p) {
 *     if (p != nullptr) {
 *         p->setAge(100);  // SAFE!
 *     }
 * }
 */

// ============================================================================
// EXAM TIP: HOW TO CHOOSE
// ============================================================================

/*
 * QUESTION: "How should I pass this parameter?"
 * 
 * DECISION TREE:
 * 
 * 1. Is it a primitive type (int, float, char)?
 *    YES → Pass by value
 *    NO → Continue
 * 
 * 2. Do I need to modify the original?
 *    YES → Use reference (Type&)
 *    NO → Continue
 * 
 * 3. Do I only need to read (not modify)?
 *    YES → Use const reference (const Type&)  ← MOST COMMON!
 *    NO → Continue
 * 
 * 4. Can the parameter be null/optional?
 *    YES → Use pointer (Type*)
 *    NO → Use const reference (const Type&)
 */

#include <iostream>

int main() {
    std::cout << "See the comments in the code for the complete guide!" << std::endl;
    std::cout << "Run passing_arguments_demo.cpp for practical examples." << std::endl;
    return 0;
}
