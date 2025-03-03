# Исходный список.
data = ['Белка', 'Стрелка']

# Распечатываем содержимое элементов с индексами 0 и 1.
print(data[0], data[1])
# Белка Стрелка

# Сохраняем значение элемента с индексом 0 во временную переменную temp.
temp = data[0]
print(temp)
# Белка

# Присваиваем элементу с индексом 0 значение элемента с индексом 1.
data[0] = data[1]
print(data[0], data[1])
# Стрелка Стрелка
# Оба элемента имеют одинаковое значение - Стрелка.

# Присваиваем элементу с индексом 1 значение временной переменной temp.
data[1] = temp
print(data[0], data[1])
# Стрелка Белка
# Значения элементов «поменялись» местами.


data = ['Белка', 'Стрелка']
# Обмениваем значения элементов с помощью одной строки:
data[0], data[1] = data[1], data[0]

# Проверим, что значения элементов поменялись местами.
print(data)
# ['Стрелка', 'Белка']


dog_1 = 'Белка'
dog_2 = 'Стрелка'
# Создаём кортеж из двух элементов. Для объявления кортежа скобки не обязательны,
# обойдёмся без них:
without_parentheses = dog_1, dog_2 
# Создаём кортеж из двух элементов со скобками.
with_parentheses = (dog_1, dog_2)

# Проверяем, что кортежи равны между собой.
print(without_parentheses == with_parentheses)
# True

# Проверяем, что это действительно кортежи.
print(type(without_parentheses), type(with_parentheses))
# <class 'tuple'> <class 'tuple'>


data = ('Белка', 'Стрелка')
# Распаковываем содержимое кортежа - присваиваем переменным значения элементов кортежа.
dog_1, dog_2 = data

# Печатаем значения переменных.
print(dog_1, dog_2)
# Белка Стрелка


# Выражение, в котором переменные обмениваются значениями:
dog_1, dog_2 = dog_2, dog_1 
# ...полностью эквивалентно выражению, записанному с использованием скобок:
(dog_1, dog_2) = (dog_2, dog_1)


dog_1 = 'Белка'
dog_2 = 'Стрелка'
dog_1, dog_2 = dog_2, dog_1
print(dog_1, dog_2)
# Стрелка Белка
# Переменные поменялись значениями за одну операцию.



data = ['Белка', 'Стрелка']

# Элементы списка обмениваются значениями.
data[0], data[1] = data[1], data[0]
print(data[0], data[1])
# Стрелка Белка
# Значения элементов поменялись местами.