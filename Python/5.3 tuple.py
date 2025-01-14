yields = [10, 12, 15, 10, 8, 10]
list.clear(yields)
print(yields)
# Вывод в терминал: []

# Передаём строку в функцию tuple():
letters = tuple('яблоко')  
print(type(letters), letters)

# Передаём список в функцию tuple():
apples = tuple(['Голден', 'Карамелька', 'Антоновка'])
print(type(apples), apples)

# Можно создать и пустой кортеж: нужно вызвать tuple() без аргументов.
empty_tuple = tuple()
# Но особого смысла в таком кортеже нет:
# добавить элементы в созданный кортеж невозможно.


fruits = 'яблоко', 'банан', 'вишня'
print(type(fruits))
print(fruits)

#  <class 'tuple'>
#. ('яблоко', 'банан', 'вишня')


fruit = 'яблоко'
# После значения нет запятой - 
# значит, переменной fruit присвоено значение типа str.
print(type(fruit))
print(fruit)

apple = 'яблоко',
# После значения стоит запятая - 
# значит, переменной apple присвоен кортеж с одним элементом.
print(type(apple))
print(apple)


# Так можно, но не нужно:
apple = 'яблоко',
# Вот так - хорошо, правильно и похвально:
apple = ('яблоко',)


vegetables = ('Огурцы', 'Помидоры', 'Баклажаны', 'Кабачки', 'Тыквы')  # Удалите многоточие и объявите кортеж.

# Удалите многоточие. Получите по индексу значение "Кабачки" и напечатайте его.
print(vegetables[3])


fruits = 'яблоко', 'банан', 'вишня'

tree_1, tree_2, tree_3 = fruits

print(tree_1)
# Вывод в терминал: яблоко
print(tree_3)
# Вывод в терминал: вишня


# Объявили кортеж...
vegetables = ('Огурцы', 'Помидоры', 'Баклажаны', 'Кабачки')
# ...и напечатали его:
print(vegetables)

# Переменной vegetables_sorted присвоили результат выполнения функции sorted():
vegetables_sorted = sorted(vegetables)
# Напечатали результат сортировки:
print('Результат работы функции sorted():', vegetables_sorted)

# А что с исходным кортежем?
print('Исходный кортеж:', vegetables)


# Объявили кортеж...
vegetables = ('Огурцы', 'Помидоры', 'Баклажаны', 'Кабачки')
# ...и напечатали его:
print(vegetables)

# Переменной vegetables_sorted присвоили результат выполнения функции sorted():
vegetables_sorted = sorted(vegetables)
# Напечатали результат сортировки:
print('Результат работы функции sorted():', vegetables_sorted)

# А что с исходным кортежем?
print('Исходный кортеж:', vegetables)





apple_tree_yields = 150, 210, 90, 120, 140, 190, 130, 150, 110, 210, 150

# Объявите функцию reversed_sort(), 
# которая вернёт отсортированный по убыванию кортеж.
def reversed_sort(apple_tree_yields):
    apple_tree_yields_sorted = tuple(sorted(apple_tree_yields, reverse = True))
    return apple_tree_yields_sorted 
# Присвойте этой переменной значение, 
# которое вернёт функция reversed_sort()
result = reversed_sort(apple_tree_yields)  
# Напечатайте:
print(result[0])  # наибольшее значение из кортежа result,
print(result[1])  # второй элемент из кортежа result,
print(result[2])  # третий элемент из кортежа result.






garden_vegetables = ('Огурцы', 'Помидоры', 'Баклажаны', 'Кабачки')

del garden_vegetables

print(garden_vegetables)

# При обращении к переменной garden_vegetables возникнет ошибка:
# Traceback (most recent call last):
#   File "D:/Dev/course/examples/main.py", line 5, in <module>
#     print(garden_vegetables)
# NameError: name 'garden_vegetables' is not defined


# Параметр *args означает, что функция готова принять несколько аргументов -
# неопределённое их число.
def boasting(*args):
    # В теле функции обрабатываем параметр args (здесь уже без звёздочки!).
    # Выясним, какого типа данные переданы в тело функции:
    print(type(args))
    # Как и прежде, напечатаем строку, ради которой и создана эта функция:
    print('Теперь у меня на грядке растёт', args)
    

# Вызовем функцию с одним аргументом:
boasting('арбуз')

# А теперь сделаем вызов с несколькими аргументами,
# перечисленными через запятую:
boasting('тыква', 'ананас', 'картошка', 'турнепс')

# Вызовем функцию без аргументов:
boasting()



# В первом параметре ожидаем название фермы, 
# а в последующих - названия сельскохозяйственных культур.
def boasting(farm_name, *args):
    print(type(args))
    # Изменим строку и добавим название фермы:
    print('На ферме', farm_name, 'на грядках растёт', args)
    
# Сделаем вызов с несколькими аргументами. Первым - название фермы:
boasting('Овощной Клондайк', 'тыква', 'ананас', 'картошка', 'турнепс')



def bizarre_function(first, second, third):
    total = first + second + third
    multiplication = first * second * third
    string = str(first) + str(second) + str(third)
    # Перечисление значений через запятую - это способ объявить кортеж!
    return total, multiplication, string

result = bizarre_function(2, 4, 6)
print(result)

# Будет напечатано: (12, 48, '246')



def bizarre_function(first, second, third):
    total = first + second + third
    multiplication = first * second * third
    string = str(first) + str(second) + str(third)
    # Перечисление значений через запятую - это способ объявить кортеж!
    return total, multiplication, string

result = bizarre_function(2, 4, 6)  # Вызываем функцию, результат присваиваем
                                    # переменной result. Результат - это кортеж.

a, b, c = result  # Распаковываем кортеж в переменные a, b и c.

print('Сумма значений 2, 4 и 6:', a)
print('Произведение значений 2, 4 и 6:', b)
print('Строка, составленная из значений 2, 4 и 6:', c)

print('\_(ツ)_/¯')

# Распаковать можно и без применения промежуточной переменной result:
d, e, f = bizarre_function(3, 5, 7)  # Вызов и распаковка - одной строкой.

print('Сумма значений 3, 5 и 7:', d)
print('Произведение значений 3, 5 и 7:', e)
print('Строка, составленная из значений 3, 5 и 7:', f)


def assess_yield(number_of_plants, average_weight):
    # Ваш код здесь
    total_weight = float(number_of_plants * average_weight / 1000)
    if total_weight > 100:
        rating = 'Ожидается отличный урожай.'
    elif 50 <= total_weight <= 100:
        rating = 'Ожидается хороший урожай.'
    elif 0 < total_weight <= 50:
        rating = 'Урожай будет так себе.'
    else:
        rating = 'Урожая не будет.'
    return total_weight, rating


# Пример вызова функции
total_weight, rating = assess_yield(50, 200)
print(total_weight, 'кг.', rating)