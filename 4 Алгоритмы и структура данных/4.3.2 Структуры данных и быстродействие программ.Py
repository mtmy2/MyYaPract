import time
# Импортируем функцию randint - с её помощью сгенерируем набор случайных чисел.
from random import randint

# Засекаем время начала работы.
start_time = time.time()

# Количество элементов в коллекции data:
DATA_SIZE = 10000
# Максимальное значение случайного числа при генерации коллекции data:
MAX_RAND_NUMBER = 10000000

# В цикле генерируем список случайных чисел в диапазоне от 1 до 10 млн.
# Вместо имени переменной цикла ставим символ "_",
# ведь в теле цикла эта переменная не применяется.
data = [randint(1, MAX_RAND_NUMBER) for _ in range(DATA_SIZE)]

# Печатаем, сколько времени генерировался список data:
print(f'Коллекция data сгенерирована за {time.time() - start_time} сек.')

# Счётчик совпадающих элементов.
match_counter = 0

# Генерируем в цикле "новые удары молний" - случайные значения.
# Таких значений будет 10 000:
for _ in range(10000):
    # Генерируем случайное значение:
    new_item = randint(1, MAX_RAND_NUMBER)
    # Ищем полученное значение в массиве data...
    if new_item in data:
        # ...и если нашли - увеличиваем счётчик совпадающих элементов.
        match_counter += 1

# Печатаем результаты поиска:
print(f'Найдено совпадений: {match_counter}')
# Для наглядности печатаем число элементов в коллекции data:
print(f'Объектов в data: {len(data)}')
# Печатаем, сколько времени работала программа.
print(f'Программа отработала за {time.time() - start_time} сек.')



import time
from random import randint


start_time = time.time()

# Количество элементов установим равным 500 000.
DATA_SIZE = 500000
MAX_RAND_NUMBER = 10000000

# Теперь data - это не список, а множество. Скобки-то фигурные!
data = {randint(1, MAX_RAND_NUMBER) for _ in range(DATA_SIZE)}
print(f'Коллекция data сгенерирована за {time.time() - start_time} сек.')

match_counter = 0

# Будет выполнено 10 000 итераций цикла.
for _ in range(10000):
    new_item = randint(1, MAX_RAND_NUMBER)
    if new_item in data:
        match_counter += 1

print(f'Найдено совпадений: {match_counter}')
print(f'Объектов в data: {len(data)}')
print(f'Программа отработала за {time.time() - start_time} сек.')