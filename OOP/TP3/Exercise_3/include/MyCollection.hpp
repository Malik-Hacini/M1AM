#ifndef MY_COLLECTION_HPP
#define MY_COLLECTION_HPP

#include <iostream>

template<class T> class MyCollection;

template<class T>
std::ostream &operator << (std::ostream &o, const MyCollection<T> &arr) {
    o << "[ ";
    for (size_t i = 0; i < arr.size; i++) {
        o << arr.set[i] << " ";
    }
    for (size_t i = arr.size; i < arr.capacity; i++) {
        o << "_ ";
    }
    o << "]";
    return o;
}

template<class T>
class MyCollection {
    private:
        T* set;
        const size_t capacity;
        size_t size;

    public:
        // Friends
        friend std::ostream &operator << <>(std::ostream &o, const MyCollection<T> &arr);

        // Constructors
        MyCollection(int capacity);
        MyCollection(const MyCollection& other);

        // Destructor
        ~MyCollection();

        // Getters
        size_t get_capacity() const { return capacity; }
        size_t get_size() const { return size; }

        // Methods
        void insert_elem(T &element);
        const T get_elem(size_t index) const;
};


template<class T>
MyCollection<T>::MyCollection(int capacity) : capacity(capacity), size(0) {
    set = new T[capacity];
}

template<class T>
MyCollection<T>::MyCollection(const MyCollection& other) : capacity(other.capacity), size(other.size) {
    set = new T[capacity];
    for (size_t i = 0; i < size; i++) {
        set[i] = other.set[i];
    }
}

template<class T>
MyCollection<T>::~MyCollection() {
    delete[] set;
}

template<class T>
void MyCollection<T>::insert_elem(T &element) {
    if (size < capacity) {
        set[size] = element;
        size++;
        return;
    }
    std::cout << "Error: Collection is full." << std::endl;
}

template<class T>
const T MyCollection<T>::get_elem(size_t index) const {
    if (index < size) {
        return set[index];
    }
    std::cout << "Error: Index out of bounds." << std::endl;
    return T(); // Valeur par défaut si index invalide
}

#endif // MY_COLLECTION_HPP