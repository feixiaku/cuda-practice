#include <iostream>

extern "C" int testCUDA();

int main()
{
     std::cout << "hello cuda!" << std::endl;

     int i = testCUDA();

     return 0;
}
