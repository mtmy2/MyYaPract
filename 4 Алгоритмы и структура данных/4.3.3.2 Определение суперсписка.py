def list_superset(list_set_1, list_set_2):
    # Не меняйте названия функции и параметров. Напишите решение здесь.
    if len(list_set_1) > len(list_set_2):
        min_list = list_set_2
        max_list = list_set_1    
    elif len(list_set_2) >= len(list_set_1):
        min_list = list_set_1
        max_list = list_set_2
    counter = 0
    for i in min_list:
        if i in max_list:
            counter += 1
    if counter == len(min_list) and len(min_list) == len(max_list):
        return f'Наборы равны.'
    if counter == len(min_list):
        return f'Набор {max_list} - супермножество.'
    if counter != len(min_list):
        return f'Супермножество не обнаружено.'

# Примеры для проверки функции.
list_set_1 = [1, 3, 5, 7]
list_set_2 = [3, 5]
list_set_3 = [5, 3, 7, 1]
list_set_4 = [5, 6]

print(list_superset(list_set_1, list_set_2))
print(list_superset(list_set_2, list_set_3))
print(list_superset(list_set_1, list_set_3))
print(list_superset(list_set_2, list_set_4))