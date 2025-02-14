def find_two_indexes(data, expected_sum):
    # Ваше решение?
    for item1 in data:
        for item2 in data:
            if item1 == item2:
                continue
            if item1 + item2 == expected_sum:
                return (list.index(data, item1), (list.index(data, item2)))
    return None

if __name__ == '__main__':
    data = [1, 2, 3, 4, 5, 6, 7, 11]
    expected_sum = 10
    print(find_two_indexes(data, expected_sum))



def find_two_indexes(data, expected_sum):
    # Для первого индекса и первого слагаемого.
    for first_index, first_value in enumerate(data):
        # Для второго индекса и второго слагаемого.
        for second_index, second_value in enumerate(data):
            # Если индексы равны, то есть это один и тот же элемент...
            if first_index == second_index:
                # ...переходим к следующему элементу.
                continue
            # Если сумма значений равна ожидаемому результату...
            if first_value + second_value == expected_sum:
                # ...вернуть индексы элементов.
                return first_index, second_index


if __name__ == '__main__':
    data = [1, 2, 3, 4, 5, 6, 7, 11]
    expected_sum = 10
    print(find_two_indexes(data, expected_sum))