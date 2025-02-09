vegetables = ['Помидоры', 'Огурцы', 'Перец']

# Внешний цикл, он перебирает коллекцию vegetables:
for vegetable in vegetables:
    print(vegetable)  # Печатаем каждый элемент.
    # Элементы списка vegetables - это строки, а строка - коллекция.
    # Переберём эту коллекцию во вложенном цикле и напечатаем построчно элементы
    # этой коллекции:
    for letter in vegetable:
        print(letter)
    # Отметим конец итерации внешнего цикла сообщением.
    # Эта строчка кода написана с отступом, она вложена в тело внешнего цикла,
    # но выполнится после того, как отработает вложенный цикл.
    print('Конец итерации внешнего цикла\n')
    # Символы \n переносят строку при печати в терминале.


retailers = ['Pixi', 'Двоечка', 'Жёлтое и зелёное', 'Экология вкуса', 'Вкусняшка']
vegetables = ['Помидоры', 'Огурцы', 'Брюква', 'Баклажаны', 'Патиссоны']

for retailer in retailers:
    print(retailer)
    for vegetable in vegetables:
        # Во вложенном цикле можно обрабатывать и переменные из внешнего цикла!
        # В конце строки ещё раз напечатаем название торговой сети.
        print(f'- {vegetable} для сети «{retailer}»')

# После выполнения цикла будет напечатано сообщение:
print('Погрузка завершена.')



retailers = ['Pixi', 'Двоечка', 'Жёлтое и зелёное', 'Экология вкуса', 'Вкусняшка']
vegetables = ['Помидоры', 'Огурцы', 'Брюква', 'Баклажаны', 'Патиссоны']

for retailer in retailers:
    print(retailer)
    for vegetable in vegetables:
        # Если одновременно выполняются оба условия... 
        if retailer == 'Жёлтое и зелёное' and vegetable == 'Брюква':
            # ...не выполняем текущую итерацию, а сразу переходим к следующей.
            continue
        print(f'- {vegetable} для сети «{retailer}»')

print('Погрузка завершена.')




retailers = ['Pixi', 'Двоечка', 'Жёлтое и зелёное', 'Экология вкуса', 'Вкусняшка']
vegetables = ['Помидоры', 'Огурцы', 'Брюква', 'Баклажаны', 'Патиссоны']

for retailer in retailers:
    if retailer == 'Экология вкуса':  # Если это условие выполняется...
        break                     # ...прерываем выполнение цикла.
    print(retailer)
    for vegetable in vegetables:
        if retailer == 'Жёлтое и зелёное' and vegetable == 'Брюква':
            continue
        print(f'- {vegetable} для сети «{retailer}»')

print('Погрузка завершена.')



retailers = ['Pixi', 'Двоечка', 'Жёлтое и зелёное', 'Экология вкуса', 'Вкусняшка']
vegetables = ['Помидоры', 'Огурцы', 'Брюква', 'Баклажаны', 'Патиссоны']

for retailer in retailers:
    if retailer == 'Экология вкуса':
        break
    print(retailer)
    for vegetable in vegetables:
        if retailer == 'Жёлтое и зелёное' and vegetable == 'Брюква':
            continue
        # Если одновременно выполнились эти условия...
        if retailer == 'Двоечка' and vegetable == 'Огурцы':
            # ...прерываем этот (вложенный) цикл:
            break
        print(f'- {vegetable} для сети «{retailer}»')

print('Погрузка завершена.')




# Начнём цикл с 0:
number = 0

# При объявлении цикла условие для выхода не установлено:
# вечное True в условии - вечный цикл.
while True:
    number += 1  # При каждой итерации увеличиваем number на 1.
    
    if number % 2 != 0:  # Если число нечётное,
        continue         # не выполняем оставшуюся часть кода
                         # и сразу переходим к следующей итерации.
    
    print(f'Четное число: {number}')  # Печатаем чётное число.
    
    if number >= 10:  # Если число достигло 10 -
        break         # прерываем цикл.

print('Цикл завершён')



months = (
    'январь', 'февраль', 'март', 'апрель', 'май', 'июнь', 
    'июль', 'август', 'сентябрь', 'октябрь', 'ноябрь', 'декабрь'
)

for month in months:
    if month[-1]=='ь':
        continue
    print(month)



counter = 0

while True:
    counter += 1
    if counter / 3 == counter // 3 and counter / 5 == counter // 5 and counter / 7 == counter // 7:   
        print(counter)
        break
    

    