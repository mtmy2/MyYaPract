def main():
    elements_count = int(input())  # Считали первую строку ввода.
    first_array = input().split()  # Считали вторую строку ввода.
    second_array = input().split()  # Считали третью строку ввода.
    # Инициализируем пустой список для сохранения результата.
    result = []
    # Создаём цикл по количеству элементов в каждом массиве.
    for element in range(elements_count):
        # Добавляем в список result элементы из двух массивов.
        result.extend([first_array[element], second_array[element]])
    # Обязательно печатаем результат, иначе Яндекс Контест не увидит решение!
    print(' '.join(result))


if __name__ == '__main__':
    # Решение оформлено в функцию, эту функцию надо обязательно вызвать:
    # Яндекс Контест не сможет вызвать её сам.
    main()


        ...
    # Вместо print() открываем файл в режиме записи 
    # (второй аргумент 'w' - "write").
    with open('output.txt', 'w') as file_out:
        # Записываем в файл нужные данные
        file_out.write(' '.join(result))
    ...