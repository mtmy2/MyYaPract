fruit_yields = [164.8, 105.0, 124.3, 113.8]  # Урожайность, кг на дерево.

# Объявляем пустой список, в него будем складывать изменённые значения.
corrected_fruit_yields = []

# Объявляем цикл, в нём переберём список fruit_yields.
for yield_value in fruit_yields:
    yield_value += 1.2  # К каждому значению добавляем 1.2.
    # Полученное значение добавляем в список corrected_fruit_yields:
    list.append(corrected_fruit_yields, yield_value)

print(corrected_fruit_yields)



new_sequence = []  # Объявляем пустой список.

# Объявляем цикл, в нём переберём диапазон от 0 до 5 включительно.
for value in range(6):
    # Значения исходной последовательности в теле цикла не обрабатываем,
    # все элементы нового списка заполняем одинаковыми значениями:
    list.append(new_sequence, 'Купи слона!')

print(new_sequence)



new_sequence = []  # Объявляем пустой список.

for _ in range(6):  # Сразу понятно: в теле цикла переменная не будет применена.
    list.append(new_sequence, 'Купи слона!')

print(new_sequence)



# Сперва решим эту задачу в обычном цикле
new_sequence = []

for value in range(6):
    list.append(new_sequence, value * 3)

print(new_sequence)

# А теперь то же самое запишем в сокращённой форме:
new_sequence_better = [value * 3 for value in range(6)] # Всё!
print(new_sequence_better)




vegetables = ['Помидоры', 'Огурцы', 'Баклажаны', 'Перец', 'Капуста']
# Сперва выполним эту задачу в обычном цикле:
new_sequence = []

for vegetable in vegetables:
    list.append(new_sequence, len(vegetable))

print(new_sequence)

# А теперь то же самое запишем в сокращённой форме:
new_sequence_better = [len(vegetable) for vegetable in vegetables]
# Результат тот же, а код короче!
print(new_sequence_better)




vegetables = ['Помидоры', 'Огурцы', 'Баклажаны', 'Перец', 'Капуста']
# Сперва выполним эту задачу в обычном цикле
new_sequence = []

for vegetable in vegetables:
    # Если в очередном элементе хранится строка с числом элементов меньше 7,
    # в список new_sequence будет добавлен элемент со значением False,
    # иначе - True.
    list.append(new_sequence, len(vegetable) >= 7)

print(new_sequence)

# А теперь то же самое запишем в сокращённой форме:
new_sequence_better = [len(vegetable) >= 7 for vegetable in vegetables]
# Результат тот же, а код короче!
print(new_sequence_better)




fruit_yields = [164.8, 105.0, 124.3, 113.8]  # Урожайность, кг на дерево.

# Вместо всего этого кода нужно написать единственную строчку,
# которая выполнит те же действия.
# corrected_fruit_yields = []

# for yield_value in fruit_yields:
#     yield_value += 1.2
#     list.append(corrected_fruit_yields, yield_value)

corrected_fruit_yields = [fruit_yield+1.2 for fruit_yield in fruit_yields]   # Ваш код - здесь.


print(corrected_fruit_yields)




numbers = [i ** 2 for i in range(1,11)]# Место для вашего кода
print(numbers)



# В цикле for перебираем последовательность range(3),
# по очереди передаём значение каждого элемента в переменную value,
# для каждого элемента словаря создаём ключ и значение:
new_collection = {f'Ключ {value}': f'Значение {value}' for value in range(3)}

print(new_collection)


vegetables = ['Помидор', 'Огурец', 'Капуста']
category = 'Овощная культура'

vegetables_info = {vegetable: category for vegetable in vegetables}
#       Создаём     ключ    и  значение.

print(vegetables_info)