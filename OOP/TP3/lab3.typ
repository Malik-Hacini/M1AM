#import "@preview/diatypst:0.7.1": *
#show: slides.with(
  title: "Object Oriented Programming", // Required
  subtitle: "Lab Session 3",
  date: "04/11/2025",
  authors: ("Malik Hacini"),
)

= Limitations of Integer encoding


== Key implementation
We use ```CPP #define T long long int``` to specify the integer type. The factorial function is templated:

```CPP
template<typename IntType>
IntType factorial(IntType n) {
    if (n <= 1) return 1;
    IntType result = 1;
    for (IntType i = 2; i <= n; i++) {
        result *= i;
    }
    return result;
}
```

== Testing different types
By changing ```CPP #define T```, we can test:
- ```CPP char``` (1 byte): factorial overflows at n=6
- ```CPP int``` (4 bytes): factorial overflows at n=13
- ```CPP long long int``` (8 bytes): factorial overflows at n=21

Unsigned variants store slightly larger values (1 more factorial) because they don't use a sign bit.

= Trip planning

== Reference implementation
We build upon the Date and Trip classes from previous labs. The Date class includes:
- Constructors with day, month, year
- Methods: ```CPP display()```, ```CPP happy_birthday()```
- Independent functions: ```CPP before()```, ```CPP difference()```, ```CPP duration()```

== Operator overloading
We add operator overloading as member functions:

```CPP
class Date {
    // ...
    bool operator<(const Date &other) const {
        return before(*this, other);
    }
    
    int operator-(const Date &other) const {
        return difference(other, *this);
    }
};
```

The ```CPP operator<``` calls the existing ```CPP before()``` function, and ```CPP operator-``` calls ```CPP difference()```. This allows intuitive syntax: ```CPP if (d1 < d2)``` instead of ```CPP if (before(d1, d2))```.

= Generics

== Class definition
We define a generic class to represent a set of elements of type T. We use ```CPP template``` to realize generic types. This class has 3 methods :
- ```CPP void insert_elem(T &element)``` to insert a new element at the end of the array.
- ```CPP const T get_elem(size_t index) const``` that gets the element stored at a specific index i.

- ```CPP std::cout```  
Finally, becasue elements are stored in a dynamically allocated array, we need a copy constructor and a destructor.

== Independent functions
We also implement two independent functions:
- ```CPP void init(MyCollection<int> &c, int &k)``` which initializes the collection  $c$ with $k$ integers. It has an error handling mechanism.
- ```CPP void apply_fact(const MyCollection<int> &c, MyCollection<int> &res)```:  fills the collection res with the factorials of the elements of collection c.

For testing, we create appropriate examples to test all edges cases.
For the second implementation, we use the standard vector implementation from STL instead of our custom one, but the functions are similar.


= Template class

==
We first define classes ```CPP Dollar```, ``` Euro```, and ``` Pound```.

```CPP
class Euro{
    private:
        float value;

    public:
        friend std::ostream &operator << (std::ostream &o, const Euro &e);

        Euro() : value(0.0f) {}
        Euro(float val) : value(val) {}

        float get_value() const { return value; }
        void set_value(float val);
};
```
==
We define a template class ```CPP Bank_account``` with generic type ```CPP Type_currency```. This class has two attributes:

- character string ``` owner_name```
- a ``` Type_currency``` balance

This class requires a copy constructor and a destructor. It has one method ``` credit_balance()``` that returns a boolean. This method returns True if the balance is strictly positive and the money type supported by the ``` <<``` operator we overloaded.


