from my_package.fibonacci import fibonacci
from my_package.random_tensor import random_tensor


def main():
    print(random_tensor[DType.float64]())

    print("fibonacci sequence:")
    for n in range(2, 11):
        print(fibonacci(n))
