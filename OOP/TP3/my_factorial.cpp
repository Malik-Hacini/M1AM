#include <iostream>
#include <string>

namespace {
unsigned long long factorial(unsigned long long n) {
    unsigned long long result = 1;
    for (unsigned long long i = 2; i <= n; ++i) {
        result *= i;
    }
    return result;
}

bool is_non_negative_integer(const std::string &text) {
    if (text.empty()) {
        return false;
    }
    for (char ch : text) {
        if (ch < '0' || ch > '9') {
            return false;
        }
    }
    return true;
}
}

int main(int argc, char *argv[]) {
    if (argc != 2) {
        std::cerr << "Usage: " << argv[0] << " <non-negative_integer>" << std::endl;
        return 1;
    }

    const std::string argument = argv[1];
    if (!is_non_negative_integer(argument)) {
        std::cerr << "Error: Input must be a non-negative integer." << std::endl;
        return 1;
    }

    unsigned long long x = 0;
    try {
        x = std::stoull(argument);
    } catch (const std::exception &) {
        std::cerr << "Error: Could not parse input as an unsigned long long." << std::endl;
        return 1;
    }

    const unsigned long long result = factorial(x);
    std::cout << "The value of factorial(" << x << ") is " << result << std::endl;

    return 0;
}
