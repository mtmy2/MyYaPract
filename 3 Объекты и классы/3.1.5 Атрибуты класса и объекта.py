class Phone:
    line_type = 'проводной'


rotary_phone = Phone()
keypad_phone = Phone()

# Печать содержимого атрибута line_type через объект rotary_phone.
print(rotary_phone.line_type)
# Печать содержимого атрибута line_type через объект keypad_phone.
print(keypad_phone.line_type)

# Выведется:
# проводной
# проводной



class ИмяКласса:
    # Тут можно указать атрибуты класса.
    ...

    # Тут объявлен метод, в скобках указываются параметры.
    def method(self, ...):
        # Тут можно описать тело метода.
        ...



class ИмяКласса:
    # Тут можно указать атрибуты класса.
    ...

    # Объявлен конструктор.
    def __init__(self, ...):
        ...



 class Phone:

    line_type = 'проводной'

    def __init__(self, dial_type_value):
        self.dial_type = dial_type_value


# Создать объект rotary_phone со значением dial_type_value,
# равным 'дисковый'.
rotary_phone = Phone(dial_type_value='дисковый')
# Создать объект keypad_phone со значением dial_type_value,
# равным 'кнопочный'.
keypad_phone = Phone(dial_type_value='кнопочный')



class Phone:

    line_type = 'проводной'

    def __init__(self):
        self.dial_type = 'дисковый'


# Создать объект rotary_phone.
rotary_phone = Phone()
# Создать объект rotary_phone_2.
rotary_phone_2 = Phone()



class Phone:

    line_type = 'проводной'

    def __init__(self, dial_type_value):
        self.dial_type = dial_type_value


rotary_phone = Phone(dial_type_value='дисковый')
keypad_phone = Phone(dial_type_value='кнопочный')

# Печать значения атрибута класса.
print(rotary_phone.line_type)
# Печать значения атрибута объекта.
print(rotary_phone.dial_type)
# Печать значения атрибута класса.
print(keypad_phone.line_type)
# Печать значения атрибута объекта.
print(keypad_phone.dial_type)

# Выведется:
# проводной
# дисковый
# проводной
# кнопочный



class Phone:
    # Атрибут класса.
    line_type = 'проводной'
    
    def __init__(self, dial_type_value):
        # Атрибут объекта.
        self.dial_type = dial_type_value

# Создать объект класса Phone с первоначальным значением 
# атрибута объекта dial_type.
rotary_phone = Phone(dial_type_value='дисковый')

print(f'Тип набора: {rotary_phone.dial_type}')

# Поменять первоначальное значение атрибута объекта dial_type.
rotary_phone.dial_type='кнопочный'

print(f'Тип набора: {rotary_phone.dial_type}')

# Выведется: 
# Тип набора: дисковый
# Тип набора: кнопочный



class Phone:
    # Атрибут класса.
    line_type = 'проводной'
    
    def __init__(self, dial_type_value):
        self.dial_type = dial_type_value

# Распечатать значение атрибута класса line_type.
print(f'Тип линии: {Phone.line_type}')
# Поменять значение атрибута класса line_type.
Phone.line_type = 'беспроводной'
# Распечатать новое значение атрибута класса.
print(f'Тип линии: {Phone.line_type}')

# Выведется: 
# Тип линии: проводной
# Тип линии: беспроводной



class Phone:
    # Атрибут класса.
    line_type = 'проводной'
    
    def __init__(self, dial_type_value):
        # Атрибут объекта.
        self.dial_type = dial_type_value


# Создать объект класса Phone.
rotary_phone = Phone(dial_type_value='дисковый')
keypad_phone = Phone(dial_type_value='кнопочный')

# Распечатать значение атрибута класса.
print(f'Тип линии: {rotary_phone.line_type}')
print(f'Тип линии: {keypad_phone.line_type}')

# Поменять значение атрибута line_type для объекта rotary_phone.
rotary_phone.line_type = 'радио'

# Снова распечатать значения.
print(f'Тип линии: {rotary_phone.line_type}')
print(f'Тип линии: {keypad_phone.line_type}')

# Поменять значение атрибута класса через класс.
Phone.line_type = 'спутниковый'

# Снова распечатать значения.
print(f'Тип линии: {rotary_phone.line_type}')
print(f'Тип линии: {keypad_phone.line_type}')

# Выведется:
# Тип линии: проводной
# Тип линии: проводной
# Тип линии: радио
# Тип линии: проводной
# Тип линии: радио
# Тип линии: спутниковый



class Employee:
    # Вместо инструкции pass напишите свой код.
    vacation_days = 28

    def __init__(self, first_name, second_name, gender):
        self.first_name = first_name
        self.second_name = second_name
        self.gender = gender


# Создайте экземпляры класса Employee с различными значениями атрибутов.
employee1 = Employee(first_name='Марат', second_name='Вильданов', gender='Мужской')
employee2 = Employee(first_name='Иванов', second_name='Иван', gender='Мужской')

# Допишите код для вывода информации о сотрудниках.
print(f'Имя: {employee1.first_name}, Фамилия: {employee1.second_name}, Пол: {employee1.gender}, Отпускных дней в году: {Employee.vacation_days}.')
print(f'Имя: {employee2.first_name}, Фамилия: {employee2.second_name}, Пол: {employee2.gender}, Отпускных дней в году: {Employee.vacation_days}.')