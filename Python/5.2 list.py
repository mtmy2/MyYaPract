digits = [1, 2, 3, 4, 5]
fruits = ['яблоко', 'банан', 'вишня']

# Можно объявить пустой список, а элементы в него
# добавлять по мере необходимости.
empty = []  # Квадратные скобки - это объявление списка.


letters = list('яблоко')  # Строка - это коллекция текстовых символов.
# Строка будет преобразована в список символов:
# ['я', 'б', 'л', 'о', 'к', 'о']

# С помощью функции list() можно объявить и пустой список:
another_empty = list()


vegetables = ['помидоры', 'огурцы', 'баклажаны']
#                  |           |           |
# Индексы:        0           1           2

print(vegetables[0])

# Напечатает: "помидоры" (индекс первого элемента - 0).
# Всего в списке vegetables три элемента, их индексы - 0, 1 и 2.


mixed_things = ['солёные помидоры', 15, ['огурцы', 'помидоры'], 3.14]
#                       |            |             |              |
# Типы элементов:      str          int          list           float  


# Последовательность типа list (список); 
# значения элементов списка - числа типа float.
vegetable_weights = [1.7, 2.5, 0.8, 1.2]

# Чтобы получить значение определённого элемента, 
# его индекс следует указать в квадратных скобках после имени последовательности.
print('Элемент с индексом [2]:', vegetable_weights[2])

# Присвоим значение элемента с индексом 3 переменной:
element = vegetable_weights[3]

# Выведем сумму элементов с индексами 0 и 3;
# значение элемента с индексом 3 сохранено в переменной element,
# применим эту переменную:
print('Сумма значений элементов с индексами 0 и 3:', vegetable_weights[0] + element)

# При попытке обратиться к несуществующему элементу 
# интерпретатор вернёт ошибку.
print(vegetable_weights[10])  # IndexError: list index out of range


movie_name = 'Джонни Мнемоник'
# Уберите многоточие и присвойте переменной movie_name_sequence значение -
# список, созданный из значения переменной movie_name.
movie_name_sequence = list(movie_name)

# Напечатайте значение переменной movie_name_sequence.
print(movie_name_sequence)



movie_name_sequence = [
    'Д', 'ж', 'о', 'н', 'н', 'и', ' ', 'М', 'н', 'е', 'м', 'о', 'н', 'и', 'к'
]
# Место для вашего кода
print(movie_name_sequence[0])
print(movie_name_sequence[2])
print(movie_name_sequence[10])
print(movie_name_sequence[5])
print(movie_name_sequence[14])


any_sequence = [1, 2, 3]
# Список можно распаковать в набор переменных.
# Имена переменных задаёт разработчик.
first, second, third = any_sequence

# Проверим, что получилось:
print(first)
print(second)
print(third)
# А что со списком?
print(any_sequence)


apple_info = ['Антоновка', 120, True]

apple_sort, apple_yield, apple_frost_resistance = apple_info

print('Сорт:', apple_sort)
print('Морозоустойчивость:', apple_frost_resistance)


apples_by_day = [61, 58, 56, 34, 67, 50, 74, 64, 78, 69]
# Распакуйте список в набор переменных
day_1, day_2, day_3, day_4, day_5, day_6, day_7, day_8, day_9, day_10 = apples_by_day

# Напечатайте значения первой и последней переменных.
print(day_1, day_10)


vegetables = ['Помидоры', 'Огурцы', 'Кабачки']
list.append(vegetables, 'Баклажаны')
print(vegetables)
# Вывод в терминал: ['Помидоры', 'Огурцы', 'Кабачки', 'Баклажаны']


vegetables = ['Помидоры', 'Огурцы', 'Кабачки']

# Бессмысленно присваивать результат работы функции переменной:
new_vegetables = list.append(vegetables, 'Баклажаны')

print(new_vegetables)
# Вывод в терминал: None

# Функция и не должна была ничего возвращать, она молодец:
# она выполнила свою работу - изменила исходный список.
print(vegetables)
# Вывод в терминал: ['Помидоры', 'Огурцы', 'Кабачки', 'Баклажаны']


vegetables = ['Помидоры', 'Огурцы', 'Кабачки', 'Баклажаны']
vegetables_yields = [10, 15, 5, 12]  # Урожайность овощей.

list.extend(vegetables, vegetables_yields)
print(vegetables)         # Список изменился.
print(vegetables_yields)  # Список не изменился.


vegetables = ['Помидоры', 'Огурцы', 'Кабачки']
# Индексы:          0        1         2

# Добавляем новый элемент на позицию с индексом 1:
list.insert(vegetables, 1, 'Баклажаны')
print(vegetables)
# Вывод в терминал: ['Помидоры', 'Баклажаны', 'Огурцы', 'Кабачки']
# Индексы:               0            1          2           3




vegetables = ['Помидоры', 'Баклажаны', 'Огурцы', 'Кабачки']
list.remove(vegetables, 'Огурцы')
print(vegetables)
# Вывод в терминал: ['Помидоры', 'Баклажаны', 'Кабачки']

# Попытка удалить несуществующий объект вызовет ошибку.
list.remove(vegetables, 'Патиссоны')
# Вывод в терминал: ValueError: list.remove(x): x not in list



vegetables = ['Помидоры', 'Баклажаны', 'Огурцы', 'Кабачки']
vegetable = list.pop(vegetables, 2)
print(vegetable)
# Вывод в терминал: Огурцы

print(vegetables)
# Вывод в терминал: ['Помидоры', 'Баклажаны', 'Кабачки']
# Элемент 'Огурцы' удалён из списка.


vegetables_yields = [10, 15, 5, 12, 5, 7]
result = list.index(vegetables_yields, 5)
print(result)
# Вывод в терминал: 2 - это индекс первого найденного элемента со значением 5.
# Возвращается только индекс первого найденного элемента: на вторую пятёрку
# функция не обратила внимания.


yields = [10, 12, 15, 10, 8, 10]
quantity = list.count(yields, 10)
print(quantity)
# Вывод в терминал: 3



yields = [10, 12, 15, 10, 8, 10]
list.sort(yields)
print(yields)
# Вывод в терминал: [8, 10, 10, 10, 12, 15]



yields = [4, 12, 15, 11, 8, 10]

# Функцией list.reverse() переворачиваем список задом наперёд:
list.reverse(yields)

print(yields)
# Вывод в терминал: [10, 8, 11, 15, 12, 4]


yields = [10, 12, 15, 10, 8, 10]
yields_copy = list.copy(yields)

# Применим сортировку к исходному списку
list.sort(yields)
print(yields)
# Вывод в терминал: [8, 10, 10, 10, 12, 15]

# Проверим, изменилась ли копия:
print(yields_copy)
# Вывод в терминал: [10, 12, 15, 10, 8, 10]
# Список-копия остался неотсортированным.


yields = [10, 12, 15, 10, 8, 10]
yields_copy = yields
# Применим сортировку к списку yields
list.sort(yields)

# Напечатаем значение переменной yields_copy:
print(yields_copy)
# Вывод в терминал: [8, 10, 10, 10, 12, 15]
# yields_copy - тот же список, что и yields.
# Две переменные ссылаются на одно и то же значение!


yields = [10, 12, 15, 10, 8, 10]
list.clear(yields)
print(yields)
# Вывод в терминал: []