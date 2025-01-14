vegetables = ['Помидоры', 'Огурцы', 'Баклажаны', 'Перец', 'Капуста']

# Объявление цикла можно прочитать так:
# "Для (for) каждого элемента в (in) коллекции vegetables..."
for vegetable in vegetables:
    # "...выполнить код в теле цикла."
    # Напечатаем содержимое переменной vegetable:
    print(vegetable)

# Код, расположенный после цикла:
print('Цикл завершился, и теперь выполняется код, следующий за циклом.')


vegetables = ['Помидоры', 'Огурцы', 'Баклажаны', 'Перец', 'Капуста']
vegetable_yields = [6.5, 4.3, 2.8, 2.2, 3.5]

for vegetable in vegetable_yields:
    print(f'Урожайность - {vegetable * 10000:.0f} кг на гектар.')



    vegetables = ['Помидоры', 'Огурцы', 'Баклажаны', 'Перец', 'Капуста']
vegetable_yields = [6.5, 4.3, 2.8, 2.2, 3.5]

# Переменную назовём осмысленно и понятно: 
# index, ведь теперь она будет содержать
# не значение элемента, а его индекс.
for index in range(len(vegetable_yields)):
    print(index)                    # Что в переменной index?
    print(vegetable_yields[index])  # Элемент из vegetable_yields.
    print(vegetables[index])        # Элемент из vegetables.




    vegetables = ['Помидоры', 'Огурцы', 'Баклажаны', 'Перец', 'Капуста']
vegetable_yields = [6.5, 4.3, 2.8, 2.2, 3.5]

for index in range(len(vegetable_yields)):
    print(f'{vegetables[index]}: урожайность -{vegetable_yields[index] * 10000: .0f} кг на гектар.')


    vegetables = ['Помидоры', 'Огурцы', 'Баклажаны', 'Перец'] # Этот список короче.
vegetable_yields = [6.5, 4.3, 2.8, 2.2, 3.5]

for i in range(len(vegetable_yields)):
    print(f'{vegetables[i]}: урожайность - {vegetable_yields[i] * 10000:.0f} кг на гектар.')



    vegetables = ['Помидоры', 'Огурцы', 'Баклажаны', 'Перец']

# Лучше всего делать так, когда возможно. 
for vegetable in vegetables:  # Перебираем коллекцию.
    print(vegetable)

# А так лучше не надо.
for i in range(len(vegetables)):  # Перебираем индексы.
    print(vegetables[i])



    # Каждый элемент списка - кортеж из трёх элементов.
vegetable_info = [
    ('Помидоры', 'Красный куб', 6.5),
    ('Огурцы', 'Аллигатор', 4.3),
    ('Баклажаны', 'Василёк', 2.8)
]

print('Эксперимент № 1')
# Переберём список в цикле,
# передавая каждый элемент списка в единственную переменную цикла, как обычно.
for item in vegetable_info:
    print(item)

print('Эксперимент № 2')
# Объявим три переменные цикла, по числу элементов во вложенных кортежах:
# kind (тип овоща), variety (сорт), productivity (урожайность).
for kind, variety, productivity in vegetable_info:
    # Теперь каждым элементом кортежа можно оперировать независимо:
    print(kind)
    print(variety)
    print(productivity)
    print('-- Конец элемента')



vegetables = ['Помидоры', 'Огурцы', 'Баклажаны', 'Перец', 'Капуста']
vegetable_yields = [6.5, 4.3, 2.8, 2.2, 3.5]

# Получаем коллекцию кортежей, где в каждом кортеже по два элемента:
# (vegetables[0], vegetable_yields[0]), (vegetables[1], vegetable_yields[1])...
vegetable_titles_and_yields = zip(vegetables, vegetable_yields)

# Перебираем коллекцию кортежей, распаковывая каждый кортеж
# в переменные vegetable и yield_per_meter:
for vegetable, yield_per_meter in vegetable_titles_and_yields:
    # Теперь соответствующие друг другу значения из двух списков
    # можно обработать как угодно.
    print(f'{vegetable}: Урожайность - {yield_per_meter * 10000:.0f} кг на гектар.')

# Список:
titles = ['Пётр Первый', 'Два капитана', 'Три мушкетёра', 'Знак четырёх']
# Кортеж:
parts = (2, 12, 85, 0.6)
# Строка:
letters = 'Слово'
# Множество:
songs = {'Octopus’s Garden', 'Yesterday', 'Something', 'Hey Jude'}
# Словарь:
foods = {
    'Маргарита': 'Пицца',
    'Антоновка': 'Яблоко',
    'Арабика': 'Кофе'
}
print('-- Список:')
for title in titles:
    print(title)

print('-- Кортеж')
for part in parts:
    print(part)

print('-- Строка:')
for letter in letters:
    print(letter)

print('-- Множество:')
for song in songs:
    print(song)

print('-- Словарь:')
for food in foods:
    print(food)



parts = (2, 12, 85, 0.6)

# Попробуйте объявить total вне цикла, здесь:
total = 0
for part in parts:
    # Попробуйте объявить total внутри цикла, здесь:
    #total = 0
    total += part
    print('total из тела цикла:', total)  # Печатаем total из тела цикла.

print('total после выполнения цикла:', total)  # Печатаем total после выполнения цикла.



parts = (2, 1, 2, 8, 5, 0, 6)

# Объявляем переменную-счётчик:
iter_counter = 0
for part in parts:
    iter_counter += 1
    print(f'Это итерация номер {iter_counter}, обрабатываем значение {part}')

print(f'Выполнено итераций: {iter_counter}')




# Словарь:
foods = {
    'Пицца': 'Маргарита',
    'Яблоко': 'Антоновка',
    'Кофе': 'Арабика',
}

# Переберём словарь в цикле: будут напечатаны только ключи.
print('Перебираем словарь, получаем только ключи:')
for food in foods:
    print(food)

# Напечатаем значения словаря: для этого сначала создадим коллекцию из значений,
# и затем переберём её в цикле.
print('Перебираем значения словаря:')
foods_values = dict.values(foods)  # Создали коллекцию из значений словаря.
for food in foods_values:  # Перебираем коллекцию значений в цикле.
    print(food)

# Можно обойтись без промежуточной переменной foods_values 
# и сразу объявить цикл:
# for food in dict.values(foods):
#    print(food)



foods = {
    'Пицца': 'Маргарита',
    'Яблоко': 'Антоновка',
    'Кофе': 'Арабика',
}

foods_items = dict.items(foods)  # Преобразовали словарь в коллекцию кортежей.
# Взглянем, как выглядит эта коллекция:
print('Коллекция кортежей:', foods_items)

# Переберём коллекцию кортежей в цикле.
# В процессе работы цикла в переменные kind и food
# будут передаваться элементы кортежей, вложенных в foods_items.
for food, kind in foods_items:
    print(f'{food} - это {kind}!')