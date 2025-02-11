example_array = [6, 5, 3, 1, 8, 7, 2, 4]


def bubble_sort(data):
    # Напишите здесь код сортировки.
    for last_index in range(len(data) - 1, 0, -1):
        for item_index in range(last_index):
            if data[item_index] > data[item_index + 1]:
                data[item_index], data[item_index + 1] = data[item_index + 1], data[item_index]
                swapped = True
        if swapped == False:
            break
    return data


print(bubble_sort(example_array))




example_array = [6, 5, 3, 1, 8, 7, 2, 4]


def bubble_sort(data):
    # Создаём внешний цикл for, указываем диапазон range.
    # Первый аргумент в range - начало диапазона: len(data) - 1.
    # Второй аргумент - конец диапазона (не включается в диапазон): 0.
    # Третий аргумент - шаг для получения следующего значения диапазона: -1.
    # На каждой итерации переменная last_index будет уменьшаться на 1.
    for last_index in range(len(data) - 1, 0, -1):
        # На этом проходе перестановок ещё не было:
        swapped = False
        # Вложенный цикл будет перебирать значения от 0 до last_index 
        # (не включая last_index).
        for item_index in range(last_index):
            # Сравниваем значения текущего и следующего элементов списка.
            if data[item_index] > data[item_index + 1]:
                # Если значения надо поменять местами - меняем.
                # Круглые скобки стоят, чтобы перенести длинную строку.
                data[item_index], data[item_index + 1] = (
                    data[item_index + 1], data[item_index]
                )
                # Выставляем флаг "выполнена перестановка".
                swapped = True
        # После окончания внутреннего цикла проверяем значение флага. 
        # Если перестановок не было...
        if not swapped:
            # ...то выходим из внешнего цикла.
            break
    # Возвращаем отсортированный список.
    return data


print(bubble_sort(example_array))




example_array = [6, 5, 3, 1, 8, 7, 2, 4]


def bubble_sort(data):
    # Устанавливаем значение last_index равным индексу последнего элемента.
    last_index = len(data) - 1
    # Чтобы цикл while мог стартовать, устанавливаем флаг в значение True.
    swapped = True
    # Цикл будет выполняться, если флаг swapped = True. Это значение
    # устанавливается при первом проходе и в случае, если на предыдущем проходе
    # были перестановки. Если перестановок не было, то цикл перестанет выполняться.
    while swapped:
        # Для текущего прохода сбрасываем значение флага на False.
        swapped = False
        # Внутренний цикл - такой же, как и в предыдущем листинге.
        # Формируем внутренний цикл от 0 до last_index (исключая last_index).
        for item_index in range(last_index):
            # Сравниваем значения элементов списка.
            if data[item_index] > data[item_index + 1]:
                # Если значения надо поменять местами - меняем.
                data[item_index], data[item_index + 1] = (
                    data[item_index + 1], data[item_index]
                )
                # Выставляем флаг "выполнена перестановка".
                swapped = True
        # Уменьшаем значение last_index на единицу.
        last_index -= 1
    # Возвращаем отсортированный список.
    return data


print(bubble_sort(example_array))