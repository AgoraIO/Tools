#include <gtest/gtest.h>

// Initializes GoogleTest and runs all registered C++ unit tests.
int main(int argc, char* argv[])
{
    testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}
