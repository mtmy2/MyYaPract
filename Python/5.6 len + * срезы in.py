any_string = 'Сколько же элементов в этой строке?'
print('Символов в строке any_string:', len(any_string))

any_range = range(10, 57, 2)
print('Элементов в диапазоне any_range:', len(any_range))

any_list = [2, 12, 85, '06', 'это мой номер']
print('Элементов в списке any_list', len(any_list))


# Посчитаем количество элементов списка и сравним с индексами.

# Считаем количество элементов: 1      2      3       4         5
sequence_for_fingers_count = ['Раз', 'Два', 'Три', 'Четыре', 'Пять']
# Индексы элементов:           [0]    [1]    [2]     [3]       [4]

# Количество элементов - пять, а индекс последнего элемента - 4.



any_string = 'В середине всего находится Солнце. (Коперник)'
center_index = (len(any_string) - 1) // 2

print('Длина последовательности any_string:', len(any_string))
print('Индекс элемента в середине any_string:', center_index)
print('Значение элемента в середине any_string:', any_string[center_index])


first_vegetable_list = ['помидор', 'огурец', 'баклажан', 'перец']

second_vegetable_list= ['картофель', 'морковь', 'лук', 'чеснок']

full_vegetable_list = first_vegetable_list + second_vegetable_list
print(full_vegetable_list)

# Строки - это последовательности. Объединяем!
hybrid = second_vegetable_list[3] + first_vegetable_list[1]
print(hybrid)



dig_more = 'копаю грядку! ' * 4
print(dig_more)

small_vegetable_list = ['Редиска', 'Картошка', 'Морковка']
double_vegetable_list = small_vegetable_list * 2
print(double_vegetable_list)




# Синтаксис: <нужное значение> in <последовательность>
# Возвращает: True/False
vegetable_prices = [45.5, 32.0, 28.7, 15.5]
print('Есть ли в списке vegetable_prices значение 45.5?', 45.5 in vegetable_prices)

vegetable = 'Баклажаны'
print('Есть ли в строке vegetable значение "ж"?', 'ж' in vegetable)



full_vegetable_list = ['Помидоры', 'Огурцы', 'Баклажаны', 'Перец', 'Картофель', 'Морковь']

# Если редьки нет...
if 'Редька' not in full_vegetable_list:
    # ...устраиваем скандал:
    print('Товарищи! Где редька?')



    vegetable_name = 'Ананас'
print(vegetable_name[1:5])



vegetable_name = 'Картофелина'
# Взять срез с восьмого (по счёту) элемента и до конца последовательности:
print(vegetable_name[7:])
# Напечатаются элементы с индексами от [7] до последнего, [10], включительно.

# Взять срез от начала последовательности до седьмого элемента (не включая седьмой):
print(vegetable_name[:7])
# Напечатаются элементы с индексами от [0] до [6] включительно.


vegetables = ['Помидоры', 'Огурцы', 'Баклажаны', 'Перец', 'Капуста']
print(vegetables[0:5:2])



vegetables = ['Помидоры', 'Огурцы', 'Баклажаны', 'Перец', 'Капуста', 'Кабачки']
# Шаг должен иметь отрицательное значение.
print('Инвертированный срез, от индекса [4] до [1]:', vegetables[4:1:-1])

# Можно не указывать границы, а задать только отрицательное значение шага.
# При такой записи в срез попадёт вся последовательность в инвертированном виде.
print('Срез с полной инвертированной последовательностью', vegetables[::-1])


a = 'Роботы стали важны'
b = 'в период'
c = 'эмиграции с Терры'

print(a[4:7]+b[2:-1:2]+c[3:6]+c[1]*2+c[8:13:2].lower())



# При сравнении последовательностей попарно сравниваются элементы
# с одинаковыми индексами:
list_one = [10, 12, 17, 9, 1, 4]
#            |   |   |  |    
list_two = [10, 12, 17, 3, 1, 4]

# Оператор сравнения работает так же, как и при сравнении чисел.
# Выражение с оператором сравнения, как и в случае с числами,
# возвращает True или False.
print(list_one > list_two)



list_one = [10, 12, 17, 9, 1, 4]
#            |   |   |  |  |  |  Все элементы, которые можно сравнить, равны...
list_two = [10, 12, 17, 9, 1, 4, 0]  # ...но список list_two длиннее - значит, он больше.

print(list_one < list_two)


print(ord('Ф'))
# Вывод в терминал: 1060



print('Слон' < 'слон')
print('Потому что значение "С" =', ord('С'), ' а значение "с" =', ord('с'))
# Элемент с индексом 0 первой строки - это буквенный символ в верхнем регистре,
# его числовой код меньше, чем у той же буквы в нижнем регистре.

print('7я' > 'о5')
print('Потому что значение "7" =', ord('7'), ' а значение "о" =', ord('о'))
# Элемент с индексом 0 первой строки - цифра. 
# Числовой код цифр меньше, чем код букв.


print('praktikum' < 'PRAKTIKUM')
# Вывод в терминал: False
# Капслок - меньше!


str_of_numbers = '12345'
print('Максимальное значение в строке str_of_numbers:', max(str_of_numbers))

list_of_str = ['abc', 'Abc']
print('Минимальное значение в списке list_of_str:', min(list_of_str))

tuple_of_numbers = (5, 10, 4, 25, 0)
print('Максимальное значение в кортеже tuple_of_numbers:', max(tuple_of_numbers))

just_range = range(30)
print('Минимальное значение в диапазоне just_range:', min(just_range))



sequence_1 = [69, 59, 57, 60, 63, 44, 46, 69]
sequence_2 = [33, 73, 50, 25, 36, 68, 52, 76]

def compare_sequences(sequence_1, sequence_2):
    if sequence_1 > sequence_2:
        sequence = f'Список {sequence_1} больше.'
        return sequence
    elif sequence_1 < sequence_2:
        sequence = f'Список {sequence_2} больше.'
        return sequence
    else:
        sequence = 'Списки равны.'
        return sequence
# Вызовите функцию compare_sequences(),
# передайте в неё списки sequence_1 и sequence_2.
# Напечатайте результат, который вернёт функция.
sequence = compare_sequences(sequence_1, sequence_2)
print(sequence)