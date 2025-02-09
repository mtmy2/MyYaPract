fruit_yields = [164.8, 105.0, 124.3, 113.8]  # Урожайность, кг на дерево.

corrected_fruit_yields = []

for yield_value in fruit_yields:
    # Если yield_value меньше 120, добавляем 1.2,
    # в ином случае значение не меняем.
    if yield_value < 120:
        yield_value += 1.2
    # Значение yield_value добавляем в список corrected_fruit_yields:
    list.append(corrected_fruit_yields, yield_value)

print(corrected_fruit_yields)


def check_mark(mark):
    print('Молодец!') if mark == 5 else print('Можно лучше!')
    
    
fruit_yields = [164.8, 105.0, 124.3, 113.8] 
corrected_fruit_yields = [yield_value + 1.2 if yield_value < 120 else yield_value for yield_value in fruit_yields]
#                         |- - - -           Тернарный оператор          - - - -|
print(corrected_fruit_yields)




fruit_yields = [164.8, 105.0, 124.3, 113.8] 
# Присвоить новому элементу значение yield_value, ЕСЛИ yield_value > 120. 
new_yields = [yield_value for yield_value in fruit_yields if yield_value > 120]

print(new_yields)



# Определение списков:
list_1 = [False, False, False]
list_2 = [True, False, False]
list_3 = [True, True, True]
list_4 = [3 > 5, 'a' == 'a', True == False]
list_5 = ['', '', 'просто буквы']

# Использование функции any():
print('Результат функции any():')
print('any(list_1):', any(list_1))  # Выведет False.
print('any(list_2):', any(list_2))  # Выведет True.
print('any(list_3):', any(list_3))  # Выведет True.
print('any(list_4):', any(list_4))  # Выведет True.
print('any(list_5):', any(list_5))  # Выведет True.

# Использование функции all():
print('\nРезультат функции all():')
print('all(list_1):', all(list_1))  # Выведет False.
print('all(list_2):', all(list_2))  # Выведет False.
print('all(list_3):', all(list_3))  # Выведет True.
print('all(list_4):', all(list_4))  # Выведет False.
print('all(list_5):', all(list_5))  # Выведет False.



vegetable_yields = [6.5, 4.3, 2.8, -3.8, 2.2, 3.5]

are_positive = []  # Объявляем пустой список.
for vegetable_yield in vegetable_yields:
    list.append(are_positive, vegetable_yield > 0)

# Проверим, что получилось:
print('are_positive:', are_positive)

# Передадим are_positive в функцию all(): все ли элементы вернули True?
print('all():', all(are_positive))
# Передадим are_positive в функцию any(): есть ли хоть один элемент,
# вернувший True?
print('any():', any(are_positive))




vegetable_yields = [6.5, 4.3, 2.8, -3.8, 2.2, 3.5]

# Все ли проверки вернули True?
are_all_positive = all([vegetable_yield > 0 for vegetable_yield in vegetable_yields])

# Есть ли хоть один элемент, вернувший True?
are_any_positive = any([vegetable_yield > 0 for vegetable_yield in vegetable_yields])

print('Все ли элементы вернули True?', are_all_positive)
print('Есть ли хоть один элемент, вернувший True?', are_any_positive)




garden = [['Помидоры', 'Огурцы', 'Баклажаны'], ['Тыква', 'Перец', 'Капуста'], ['Кабачок', 'Морковь', 'Брюква'], ['Картошка', 'Свёкла', 'Репа']]

# Но лучше разбить по строкам:

garden = [
    ['Помидоры', 'Огурцы', 'Баклажаны'], 
    ['Тыква', 'Перец', 'Капуста'], 
    ['Кабачок', 'Морковь', 'Брюква'], 
    ['Картошка', 'Свёкла', 'Репа']
]




# element = имя_списка[индекс_вмещающего_списка][индекс_вложенного_списка]

garden = [
    ['Помидоры', 'Огурцы', 'Баклажаны'], 
    ['Тыква', 'Перец', 'Капуста'], 
    ['Кабачок', 'Морковь', 'Брюква'], 
    ['Картошка', 'Свёкла', 'Репа']
]

# Доступ к третьему элементу второй строки
result = garden[1][2]

print(result)



rows = 3
cols = 4
matrix = [[0 for _ in range(cols)] for _ in range(rows)]
print(matrix)

# В результате будет напечатан такой список (но в одну строку)
# [
#    [0, 0, 0, 0], 
#    [0, 0, 0, 0], 
#    [0, 0, 0, 0]
# ]



# Объявляется список:
#matrix = [...]

# Объявляется цикл for _ in range(rows), он создаст " внешний" список
# из трёх элементов (ведь rows = 3):
#matrix = [ for _ in range(rows)]

# Левее for - ещё пара квадратных скобок: 
# каждый создаваемый элемент будет списком.
# matrix = [[...] for _ in range(rows)]

# Каждый вложенный список 
# будет сгенерирован списковым включением 0 for _ in range(cols):
# цикл выполнится cols раз (4), 
# на каждой итерации будет создан элемент со значением 0.
matrix = [[0 for _ in range(cols)] for _ in range(rows)]



garden = [
    ['Помидоры', 'Огурцы', 'Баклажаны'], 
    ['Тыква', 'Перец', 'Капуста'], 
    ['Кабачок', 'Морковь', 'Брюква'], 
    ['Картошка', 'Свёкла', 'Репа']
]

for row in garden:
    for element in row:
        print(element)
    print('===')  # Разделитель после каждого вложенного списка.


sequence = [1, 2, 3, 4]
total = sum(sequence)

# Значение total равно 1 + 2 + 3 + 4




# Пригодится для наполнения списков!
from random import randint as rnd
from statistics import mean

# 1. Создание списка списков:

harvest = [[rnd(5,20) for _ in range(3)] for _ in range(3)]  # Примените list comprehension.
print(harvest)
# 2. Функция для подсчёта общего урожая:
def total_harvest(harvest):
    return sum(sum(harvest_row) for harvest_row in harvest)    

print(total_harvest(harvest))

# 3. Функция для подсчёта среднего урожая с каждого участка:
def average_harvest_per_plot(harvest):
    return [mean(harvest_row) for harvest_row in harvest]
print(average_harvest_per_plot(harvest))

# Вывод результатов
print('Урожай с каждой грядки на каждом участке:', harvest)
print('Общий урожай со всех участков:', total_harvest(harvest))
print('Средний урожай с каждого участка:', average_harvest_per_plot(harvest))
