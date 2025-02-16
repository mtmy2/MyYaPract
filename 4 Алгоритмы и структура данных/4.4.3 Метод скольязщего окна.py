# Импортируем число, заведомо большее, чем любая сумма элементов среза.
from sys import maxsize


def find_min_slice_sum(data, elements_in_slice):
    # Установим очень большое стартовое значение min_sum.
    min_sum = maxsize
    # Двигаемся от начала массива до последнего элемента, 
    # от которого мы сможем взять срез нужной длины.
    for index in range(len(data) - elements_in_slice + 1):
        # В temp_sum будем записывать сумму элементов очередного среза 
        # и сравнивать её с min_sum.
        temp_sum = 0
        # Перебираем элементы в срезе.
        for slice_index in range(elements_in_slice):
            # Подсчитываем сумму значений в очередном срезе.
            temp_sum += data[index + slice_index]
        # Выбираем минимальное значение из двух и сохраняем это значение
        # в переменную min_sum.
        min_sum = min(min_sum, temp_sum)
    return min_sum


if __name__ == '__main__':
    data = [5, -3, -2, 10, 2, 7, 1, -6, 13]
    elements_in_slice = 4
    print(find_min_slice_sum(data, elements_in_slice))




from sys import maxsize


def find_min_slice_sum(data, elements_in_slice):
    min_sum = maxsize
    for index in range(len(data) - elements_in_slice + 1):
        # Вместо внутреннего цикла считаем сумму нужного среза.
        temp_sum = sum(data[index:index+elements_in_slice])
        min_sum = min(min_sum, temp_sum)
    return min_sum


if __name__ == '__main__':
    data = [5, -3, -2, 10, 2, 7, 1, -6, 13]
    elements_in_slice = 4
    print(find_min_slice_sum(data, elements_in_slice))






# Итог:
data = [5, -3, -2, 10, 2, 7, 1, -6, 13]
elements_in_slice = 4

# Сперва посчитаю сумму элементов в первом срезе, 
# с индексами от 0 до elements_in_slice:
window_sum = sum(data[0:elements_in_slice])
# Сразу напечатаю:
print(window_sum)

# Теперь переберу массив data по индексам, 
# от второго элемента в массиве до (len(data) - elements_in_slice) включительно:
for index in range(1, len(data) - elements_in_slice + 1):
    # Считаю сумму для текущего среза:
    # к сумме предыдущего среза прибавляю 
    # значение последнего элемента текущего среза...
    window_sum += data[index + elements_in_slice-1]
    # ...и вычитаю значение первого элемента предыдущего среза:
    window_sum -= data[index - 1]
    print(window_sum)




def find_min_slice_sum(data, elements_in_slice):
    # Считаем сумму первого окна.
    window_sum = sum(data[0:elements_in_slice])
    # Запоминаем результат подсчёта в качестве минимальной суммы.
    min_sum = window_sum
    # В цикле перебираем индексы массива от elements_in_slice до последнего.
    for index in range(elements_in_slice, len(data)):
        # К сумме предыдущего окна добавляем новый элемент: data[index]
        # и вычитаем "вышедший" элемент: data[index - elements_in_slice]
        window_sum += data[index] - data[index - elements_in_slice]
        # Находим минимальную сумму.
        min_sum = min(min_sum, window_sum)
    return min_sum


if __name__ == '__main__':
    data = [5, -3, -2, 10, 2, 7, 1, -6, 13]
    elements_in_slice = 4
    print(find_min_slice_sum(data, elements_in_slice))