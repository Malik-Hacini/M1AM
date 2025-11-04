#include <iostream>
#include <cstdlib>


#define T long long int

template<typename IntType>
IntType factorial(IntType n) {
    if (n <= 1) return 1;
    
    IntType result = 1;
    for (IntType i = 2; i <= n; i++) {
        result *= i;
    }
    return result;
}

int main(int argc, char* argv[]) {
    
    if (argc != 2) {
        std::cout << "Usage: " << argv[0] << " <positive_integer>" << std::endl;
        return 1;
    }
    
    int n = std::atoi(argv[1]);
    
    if (n < 0) {
        std::cout << "Error: Please provide a positive integer." << std::endl;
        return 1;
    }
    
    T result = factorial<T>(n);
    
    std::cout << "The value of factorial(" << n << ") is " << result << std::endl;
    
    return 0;
}
