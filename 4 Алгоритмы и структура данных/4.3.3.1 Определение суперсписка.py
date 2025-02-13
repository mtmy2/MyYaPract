def list_superset(list_set_1, list_set_2):
    # Не меняйте названия функции и параметров. Напишите решение здесь.
    existing_items = set(list_set_1) & set(list_set_2)
    if set(existing_items) == set(list_set_1) and set(existing_items) == set(list_set_2):
        return f'Наборы равны.'
    elif set(existing_items) == set(list_set_1):
        return f'Набор {list_set_2} - супермножество.'
    elif set(existing_items) == set(list_set_2):
        return f'Набор {list_set_1} - супермножество.'
    else:
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