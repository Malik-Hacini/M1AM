#include <iostream>

class DynamicArray{
    private:
        int* data;
        int size;

    public:
        DynamicArray(int s) {
            size = s;
            data = new int[size];
        };
        void set(int index, int value) {
            data[index] = value;
        }
        int get(int index){
            return data[index];
        }

        void display(){
            for(int i = 0; i < size; i++){
                std::cout << data[i] << " ";
            }
            std::cout << std::endl;
        }
        ~DynamicArray() {
            delete[] data;
        };

};


int main(){
    DynamicArray arr(5);
    for(int i = 0; i < 5; i++){
        arr.set(i, i * 10);
    }
    arr.display();
    return 0;
}