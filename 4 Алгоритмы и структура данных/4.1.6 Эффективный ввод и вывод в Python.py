# через терминал можно автоматически передавать данные на стандартный поток ввода. 
# Команда yes генерирует бесконечную последовательность строк с буквой y, 
# пока не будет нажата комбинация Ctrl + C.

$ yes
y
y
y
y
y
y
...  # И так далее

# Вертикальная черта | в терминале, оператор «конвейера», направляет вывод одной программы в поток ввода другой. 
# С её помощью направим результат выполнения программы yes в скрипт на Python, размещённый в check.py:

$ yes | python check.py

# Чтобы измерить время выполнения, потребуется ещё одна программа, time, она измеряет время выполнения скрипта.
$ time yes | python check.py


# Импорт системной библиотеки, 
# при помощи которой будем считывать данные из стандартного потока ввода.
import sys


def main():
    # Прочитали первую строку, в которой указано количество строк,
    # преобразовали в число:
    num_lines = int(sys.stdin.readline().rstrip())  
    output_numbers = [None] * num_lines
    # Читаем следующие строки ввода:
    for i in range(num_lines):
        # Считали строку и удалили символы перевода строки.
        line = sys.stdin.readline().rstrip()
        # Разделили строку по пробельному символу,        
        # присвоили значения из строки переменным first и second соответственно.
        first, second = line.split()  
        # Преобразовали строки в целые числа.
        first = int(first)  
        second = int(second)
        # Получили сумму.
        result = first + second  
        # Записали в массив ответов текущий результат как строку.
        output_numbers[i] = str(result)
    # В конце вывели все полученные ответы за один раз.
    print('\n'.join(output_numbers)) 


if __name__ == '__main__':
    main()


    import sys


def main():
    num_lines = int(sys.stdin.readline().rstrip())  
    output_numbers = [None] * num_lines
    for i in range(num_lines):
        line = sys.stdin.readline().rstrip()
        first, second = line.split()  
        first = int(first)  
        second = int(second)
        # Записываем результат в массив без преобразования в строку.
        output_numbers[i] = first + second
    # В конце печатаем распакованный список, 
    # добавляя между значениями символы перевода строки.
    print(*output_numbers, sep='\n')
    

if __name__ == '__main__':
    main()



def two_components_sum(items, target):
    # Длина массива.
    items_len = len(items)
    # Перебираем в цикле индексы для получения первого слагаемого.
    for first_index in range(items_len):
        # Перебираем в цикле индексы для получения второго слагаемого.
        for second_index in range(items_len):
            if first_index == second_index:
                # Если индексы слагаемых одинаковы, то это одно и то же число,
                # переходим к следующей паре.
                continue
            if items[first_index] + items[second_index] == target:
                # Если сумма совпадает с искомой, возвращаем True.
                return True
    # Если искомой суммы не нашлось, возвращаем False.
    return False