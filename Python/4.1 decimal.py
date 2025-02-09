# Из модуля decimal импортируйте тип данных Decimal и параметр getcontext.
# Из модуля math импортируйте константу "пи".
from decimal import Decimal, getcontext
from math import pi

# Приведите константу "пи" к типу Decimal.
# Помните, что Decimal() принимает строку, а константа "пи" - это число.
pi = Decimal(str(pi))
# Установите необходимую точность для вычислений.
getcontext().prec = 10

# Объявите функцию ellipse_area() с двумя параметрами.
def ellipse_area(a, b):
    area = a * b * pi
    return area    
# Объявите три переменные типа Decimal - 
# они должны хранить длины полуосей эллипса и глубину пруда.
    
# Вызовите функцию ellipse_area(), в аргументах передайте длины полуосей эллипса.
a = Decimal('2.5')
b = Decimal('1.75')
area = ellipse_area(a, b)
print('Площадь эллипса:', area, 'кв.м.')

# Вычислите объём пруда: площадь * глубина.
depth = Decimal('0.35')
volume = area * depth
print('Объём воды для наполнения пруда:', volume, 'куб.м.')



