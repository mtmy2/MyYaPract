# Длины слов "ноль", "один", "два", "три", "четыре" - и так до двенадцати.
digit_lengths = [4, 4, 3, 3, 6, 4, 5, 4, 6, 6, 6, 11, 10]


def card_strength(idx):
    # Получаем количество букв для числа idx.
    return digit_lengths[idx]


# Добавляем в функцию параметр key,
# в него будет передана функция, получающая значение ключа сортировки.
def insertion_sort_by_key(arr, key):
    for i in range(1, len(arr)):
        current = arr[i]
        prev = i - 1
        # При сравнении элементов вызываем функцию, переданную в параметр key, 
        # она вернёт значение ключа.
        while prev >= 0 and key(arr[prev]) > key(current):
            arr[prev + 1] = arr[prev]
            prev -= 1
        arr[prev + 1] = current


cards = [2, 9, 11, 7, 1]
# При вызове сортировки передаём в параметры функцию,
# возвращающую значение ключа.
insertion_sort_by_key(cards, card_strength)
# Для контроля - напечатаем результат:
print(cards)





digit_lengths = [4, 4, 3, 3, 6, 4, 5, 4, 6, 6, 6, 11, 10]

# Массив с другим набором ключей: это цвета карт.
card_colors = [
    'Аметистовый',   # [0]
    'Чёрный',        # [1]
    'Белый',         # [2]
    'Жёлтый',        # [3] 
    'Синий',         # [4]
    'Фиолетовый',    # [5]
    'Коричневый',    # [6]
    'Зелёный',       # [7]
    'Розовый',       # [8]
    'Серо-голубой',  # [9]
    'Бобровый',      # [10]
    'Коралловый',    # [11]
    'Ванильный'      # [12]
]


def card_strength(idx):
    # Получаем количество букв для числа idx.
    return digit_lengths[idx]


# Добавляем функцию, передающую значения ключей из массива card_colors:
def card_background(idx):
    # Получаем название цвета для карты idx.
    return card_colors[idx]


def insertion_sort_by_key(arr, key):
    for i in range(1, len(arr)):
        current = arr[i]
        prev = i - 1
        while prev >= 0 and key(arr[prev]) > key(current):
            arr[prev + 1] = arr[prev]
            prev -= 1
        arr[prev + 1] = current


cards = [2, 9, 11, 7, 1]
# Сортируем по длине слов:
insertion_sort_by_key(cards, card_strength)
# Печатаем результат:
print('По длине слов:', cards)

# Вызываем ту же функцию, но сортируем по названиям цветов:
insertion_sort_by_key(cards, card_background)
# Печатаем результат:
print('По цветам:', cards)

# Можно обойтись без создания функций card_strength() и card_background(), 
# а передать в аргументах анонимные, или, как их ещё называют, лямбда-функции. 
# Код станет короче, а результат будет тем же:
insertion_sort_by_key(cards, lambda x: digit_lengths[x])
print('По длине слов:', cards)
insertion_sort_by_key(cards, lambda x: card_colors[x])
print('По цветам:', cards)





#В стандартную функцию сортировки sorted() тоже можно передать функцию для вычисления ключа.
digit_lengths = [4, 4, 3, 3, 6, 4, 5, 4, 6, 6, 6, 11, 10]


def card_strength(idx):
    return digit_lengths[idx]


cards = [2, 9, 11, 7, 1]
# В параметр key передаём функцию, возвращающую значения ключей.
result = sorted(cards, key=card_strength)
print(result)




# В функцию сортировки можно передать и лямбда-функцию:
digit_lengths = [4, 4, 3, 3, 6, 4, 5, 4, 6, 6, 6, 11, 10]
cards = [2, 9, 11, 7, 1]
# В параметр key передаём лямбда-функцию, возвращающую значения ключей.
result = sorted(cards, key=lambda x: digit_lengths[x])
print(result)





# В аргумент key будем передавать не функцию, а индекс того элемента кортежа,
# который будет ключом сортировки.
def insertion_sort_by_key(arr, key):
    for i in range(1, len(arr)):
        current = arr[i]
        prev = i - 1
        # Вместо вызова функции указываем нужный элемент кортежа.
        while prev >= 0 and arr[prev][key] > current[key]:
            arr[prev + 1] = arr[prev]
            prev -= 1
        arr[prev + 1] = current


cards = [
    (2, 'Белый'),
    (9, 'Серо-голубой'),
    (11, 'Коралловый'),
    (7, 'Зелёный'),
    (1, 'Чёрный')
]
# Сортируем по названию цвета (по второму элементу кортежа):
insertion_sort_by_key(cards, 1)
print('По цвету:', cards)

# Сортируем по числу на карте (по первому элементу кортежа):
insertion_sort_by_key(cards, 0)
print('По числу:', cards)



# Чтобы провернуть подобный трюк со встроенной в Python функцией sorted(), 
# можно создать дополнительную функцию, которая будет возвращать второй элемент кортежа:
def second_element(card_and_color):
    return card_and_length[1]


cards = [
    (2, 'Белый'),
    (9, 'Серо-голубой'),
    (11, 'Коралловый'),
    (7, 'Зелёный'),
    (1, 'Чёрный')
]
result = sorted(cards, key=second_element)
print(result)
# [(2, 'Белый'), (7, 'Зелёный'), (11, 'Коралловый'), (9, 'Серо-голубой'), (1, 'Чёрный')]




# А можно прямо в параметрах вызова написать анонимную лямбда-функцию: 
# она сделает всё то же самое, но отдельную функцию создавать не потребуется.
cards = [
    (2, 'Белый'),
    (9, 'Серо-голубой'),
    (11, 'Коралловый'),
    (7, 'Зелёный'),
    (1, 'Чёрный')
]
result = sorted(cards, key=lambda second_element: second_element[1])
print(result)
# [(2, 'Белый'), (7, 'Зелёный'), (11, 'Коралловый'), (9, 'Серо-голубой'), (1, 'Чёрный')]



# Задание, отсортировать по цвету
cards = [
    {
        'number': 2,
        'color': 'Белый'
    },
    {
        'number': 9,
        'color': 'Серо-голубой'
    },
    {
        'number': 11,
        'color': 'Коралловый'
    },
    {
        'number': 7,
        'color': 'Зелёный'
    },
    {
        'number': 1,
        'color': 'Чёрный'
    },
]
result = sorted(cards, key=lambda x: x['color'])
print(result)