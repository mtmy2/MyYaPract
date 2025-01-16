from math import sqrt
from typing import Optional


def add_numbers(x_1: int, y_1: int) -> int:
    return x_1 + y_1


def calculate_square_root(number: int) -> float:
    return sqrt(number)


def calc(your_number: float) -> Optional[str]:
    if your_number <= 0:
        return None
    else:
        sqrt = calculate_square_root(your_number)
        return f'Мы вычислили квадратный корень из введённого вами числа. \
Это будет: {sqrt}'


x_1 = 10
y_1 = 5

print('Сумма чисел: ', add_numbers(x_1, y_1))

print(calc(25.5))
