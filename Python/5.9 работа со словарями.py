vegetable_yields = {
    'Помидоры': 6.5,
    'Огурцы': 4.3,
    'Баклажаны': 2.8,
    'Перец': 2.2,
    'Капуста': 3.5
}

# Получаем значения для ключа 'Баклажаны':
print(vegetable_yields['Баклажаны'])
# Вывод в терминал: 2.8


# Отформатируем построчно и основной, и вложенные словари.
vegetable_info = {
    'Помидоры': {
        'Урожайность': 6.5, 
        'Описание': 'Морозостойкие'
    },
    'Огурцы':  {
        'Урожайность': 4.3, 
        'Описание': 'Хороши для засолки'
    },
    'Баклажаны':  {
        'Урожайность': 2.8, 
        'Описание': 'Не очень'
    },
    'Перец':  {
        'Урожайность': 2.2, 
        'Описание': 'Просто огонь'
    },
    'Капуста':  {
        'Урожайность': 3.5, 
        'Описание': 'Идеальная'
    },
}

# Одним выражением получим значение ключа 'Описание' из словаря, 
# который хранится под ключом 'Перец':
result = vegetable_info['Перец']['Описание']
print(result)



vegetable_info = {
    'Помидоры': {
        'Урожайность': 6.5, 
        'Описание': 'Морозостойкие'
    },
    'Огурцы': {
        'Урожайность': 4.3, 
        'Описание': 'Хороши для засолки'
    },
    'Баклажаны': {
        'Урожайность': 2.8, 
        'Описание': 'Не очень'
    },
    'Перец': {
        'Урожайность': 2.2, 
        'Описание': 'Просто огонь'
    },
    'Капуста': {
        'Урожайность': 3.5, 
        'Описание': 'Идеальная'
    },
}

vegetable = 'Баклажаны'
# Проверка: есть ли запрошенный ключ в словаре vegetable_info:
if vegetable in vegetable_info:
    # Если такой ключ есть в словаре, выводим сообщение:
    print('Информация об этом овоще есть в справочнике.')        
else:
    # Если запрошенного ключа нет, выводим сообщение:
    print('Информация об овоще отсутствует.')



    vegetable_info = {
    'Помидоры': {
        'Урожайность': 6.5, 
        'Описание': 'Морозостойкие'
    },
    'Огурцы': {
        'Урожайность': 4.3, 
        'Описание': 'Хороши для засолки'
    },
    'Баклажаны': {
        'Урожайность': 2.8, 
        'Описание': 'Не очень'
    },
    'Перец': {
        'Урожайность': 2.2, 
        'Описание': 'Просто огонь'
    },
    'Капуста': {
        'Урожайность': 3.5, 
        'Описание': 'Идеальная'
    },
}




# Вызываем функцию get(), пытаемся получить значение для ключа 'Капуста'.
result_available = dict.get(vegetable_info, 'Капуста')
print('Запросили существующий ключ:', result_available)

# Вызываем функцию get(), пытаемся получить значение для ключа 'Морковь'.
result_not_available = dict.get(vegetable_info, 'Морковь')
print('Запросили несуществующий ключ:', result_not_available)

# Вызываем функцию get() с тремя аргументами:
# третий аргумент - значение, которое вернётся, если ключ не найден.
result_with_message = dict.get(vegetable_info, 'Лук', 'Ключ не найден!')
print('Запросили несуществующий ключ:', result_with_message)



vegetable_yields = {
    'Помидоры': 6.5,
    'Огурцы': 4.3,
    'Баклажаны': 2.8,
}

# Ключа 'Перец' нет в словаре. 
# Создадим элемент с таким ключом и присвоим ему значение: 
vegetable_yields['Перец'] = 2.2
print('Добавили элемент "Перец": 2.2', vegetable_yields)

# Присвоим элементу 'Перец' новое значение. Синтаксис тот же самый, 
# разница в том, что элемент с ключом 'Перец' теперь уже есть в словаре.
# Новый элемент не будет создан; новое значение будет присвоено существующему элементу.
vegetable_yields['Перец'] = 5.0
print('Изменили элемент "Перец"', vegetable_yields)


vegetable_yields = {
    'Помидоры': 6.5,
    'Огурцы': 4.3,
    'Баклажаны': 2.8
}

new_yields = {
    'Перец': 2.2,
    'Тыква': 3.4
}

dict.update(vegetable_yields, new_yields)
print(vegetable_yields)

# Будет напечатано: 
# {'Помидоры': 6.5, 'Огурцы': 4.3, 'Баклажаны': 2.8, 'Перец': 2.2, 'Тыква': 3.4}



vegetable_yields = {
    'Помидоры': 6.5,
    'Огурцы': 4.3,
    'Баклажаны': 2.8,
    'Перец': 2.2,
    'Тыква': 3.4
}

del vegetable_yields['Баклажаны']
del vegetable_yields['Перец']
del vegetable_yields['Тыква']

print(vegetable_yields)
# Будет напечатано: {'Помидоры': 6.5, 'Огурцы': 4.3}


vegetable_yields = {
    'Помидоры': 6.5,
    'Огурцы': 4.3,
    'Баклажаны': 2.8,
    'Перец': 2.2,
    'Тыква': 3.4
}

# При попытке получить значение элемента словаря с ключом 'Кабачки'
# функция dict.pop() вернёт значение по умолчанию - 'Название не найдено.'
result = dict.pop(vegetable_yields, 'Кабачки', 'Название не найдено.')
print(result)
# Вывод в терминал: Название не найдено.

# Ключ 'Тыква' есть в словаре, 
# поэтому значение 'Название не найдено.' не будет использовано:
result = dict.pop(vegetable_yields, 'Тыква', 'Название не найдено.')
print(result)
# Вывод в терминал: 3.4

result = dict.pop(vegetable_yields, 'Баклажаны')
print('В переменную result сохранено значение', result)
# Вывод в терминал: В переменную result сохранено значение 2.8

print(vegetable_yields)



vegetable_yields = {
    'Помидоры': 6.5,
    'Огурцы': 4.3,
    'Баклажаны': 2.8,
    'Перец': 2.2,
    'Тыква': 3.4
}

# Получаем ключи всех элементов:
veggie_keys = dict.keys(vegetable_yields)
print(veggie_keys)
print('Тип последовательности с ключами словаря:', type(veggie_keys))

# Получаем значения всех элементов:
veggie_values = dict.values(vegetable_yields)
print(veggie_values)
print('Тип последовательности со значениями словаря:', type(veggie_values))

# Приводим последовательности veggie_keys и veggie_values к спискам:
print('Список ключей:', list(veggie_keys))
print('Список значений:', list(veggie_values))




vegetable_yields = {
    'Помидоры': 6.5,
    'Огурцы': 4.3,
    'Баклажаны': 2.8,
    'Перец': 2.2,
    'Тыква': 3.4
}

vegetable_yields_items = dict.items(vegetable_yields)
print(vegetable_yields_items)


vegetable_yields = {
    'Помидоры': 6.5,
    'Огурцы': 4.3,
    'Баклажаны': 2.8,
    'Перец': 2.2,
    'Тыква': 3.4
}

dict.clear(vegetable_yields)
print(vegetable_yields)
# Вывод в терминал: {}


vegetable_yields = {
    'Помидоры': 6.5,
    'Огурцы': 4.3,
    'Баклажаны': 2.8,
    'Перец': 2.2,
    'Тыква': 3.4
}
print('ID, на который ссылается vegetable_yields:', id(vegetable_yields))

yield_copy = vegetable_yields.copy()
print('ID, на который ссылается yield_copy:', id(yield_copy))


# А если присвоить значение vegetable_yields новой переменной,
# копия словаря не будет создана:
yield_just_link = vegetable_yields
print('ID, на который ссылается yield_just_link:', id(yield_just_link))

print('ID vegetable_yields равен ID yield_just_link?', id(yield_just_link) == id(vegetable_yields))



def inspect_args(*args):
    print('Значение args:', args)
    print('Значение args[0]:', args[0])
    print('Длина args:', len(args))
    print()  # Пустая строка для читаемости вывода.

def inspect_kind_and_args(kind, *args):
    print('Значение kind:', kind)
    print('Значение args:', args)
    print('Значение args[0]:', args[0])
    print('Длина args:', len(args))

print('Вызвали функцию inspect_args():')
inspect_args('Овощи', 'Помидоры', 'Огурцы', 'Баклажаны', 'Перец')

print('Вызвали функцию inspect_kind_and_args():')
inspect_kind_and_args('Овощи', 'Помидоры', 'Огурцы', 'Баклажаны', 'Перец')



def print_first_key_and_value(**kwargs):
    print('Тип переменной kwargs:', type(kwargs))
    print('Содержимое переменной kwargs:', kwargs)

    # kwargs - это словарь. Получим список ключей этого словаря...
    kwargs_keys = list(dict.keys(kwargs))
    # ...и список его значений:
    kwargs_values = list(dict.values(kwargs))

    # Напечатаем первый ключ и первое значение:
    print(kwargs_keys[0], '-', kwargs_values[0])

    # Попробуем напечатать значение переменной, 
    # которая даже не была объявлена в этой функции, но передана в аргументы:
    print(kwargs['species'])

# Вызываем функцию, передав ей три именованных аргумента.
# Сама функция о таких именах ничего не знает, но готова их принять.
print_first_key_and_value(name='Помидор', species='Solanum lycopersicum', origin='Южная Америка')

# В параметр **kwargs можно передать любое количество именованных аргументов.
print_first_key_and_value(species='Solanum melongena', name='Баклажан')
