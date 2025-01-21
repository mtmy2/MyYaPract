class Phone:

    line_type = 'проводной'

    def __init__(self, dial_type_value):
        self.dial_type = dial_type_value

    def ring(self):
        print('Дзззззыыыыыыыынь!')

    # Это новый метод, уже с двумя параметрами.
    def call(self, phone_number):
        # Сначала в вывод подставляется значение параметра phone_number,
        # а затем - атрибута класса Phone.
        print(f'Звоню по номеру {phone_number}! Тип связи - {self.line_type}.')


rotary_phone = Phone(dial_type_value='дисковый')

# Вызов метода call(). Передаётся аргумент '555-2368'
# для параметра phone_number.
rotary_phone.call('555-2368')

# Выведется:
# Звоню по номеру 555-2368! Тип связи - проводной.


class Phone:

    line_type = 'проводной'

    def __init__(self, dial_type_value):
        self.dial_type = dial_type_value

    def ring(self):
        print('Дзззззыыыыыыыынь!')

    def call(self, phone_number):
        print(f'Звоню по номеру {phone_number}! Тип связи - {self.line_type}.')

    # Ещё один метод.
    def get_missed_calls(self):
        print('Запрос количества пропущенных вызовов.')


rotary_phone = Phone(dial_type_value='дисковый')

rotary_phone.get_missed_calls()

# Выведется:
# Запрос количества пропущенных вызовов.




class Phone:

    line_type = 'проводной'

    def __init__(self, dial_type_value):
        self.dial_type = dial_type_value


# Вот тут задано первоначальное значение.
rotary_phone = Phone(dial_type_value='дисковый')

print(rotary_phone.dial_type)

# А тут - новое.
rotary_phone.dial_type = 'кнопочный'

print(rotary_phone.dial_type)

# Выведется:
# дисковый
# кнопочный



class Phone:

    line_type = 'проводной'

    def __init__(self, dial_type_value):
        self.dial_type = dial_type_value

    # Новый метод.
    def dial_type_upgrade(self, new_dial_type):
        # Задать для атрибута dial_type новое значение - new_dial_type.
        self.dial_type = new_dial_type


# Тут задано начальное значение атрибута dial_type.
rotary_phone = Phone(dial_type_value='дисковый')

print(rotary_phone.dial_type)

# Вызов метода dial_type_upgrade, который призван поменять
# начальное значение атрибута на new_dial_type.
rotary_phone.dial_type_upgrade('кнопочный')

print(rotary_phone.dial_type)

# Выведется:
# дисковый
# кнопочный




class Employee:
    vacation_days = 28

    def __init__(self, first_name, second_name, gender):
        self.first_name = first_name
        self.second_name = second_name
        self.gender = gender
        # Сюда добавьте новый атрибут remaining_vacation_days
        self.remaining_vacation_days = Employee.vacation_days

    # Сюда добавьте методы consume_vacation и get_vacation_details.
    def consume_vacation(self, days_spent):
        self.remaining_vacation_days = self.remaining_vacation_days - days_spent

    def get_vacation_details(self):
        return f'Остаток отпускных дней: {self.remaining_vacation_days}.'

# Создайте экземпляры класса Employee с различными значениями атрибутов.
employee1 = Employee(first_name='Марат', second_name='Вильданов', gender='Мужской')
employee2 = Employee(first_name='Иванов', second_name='Иван', gender='Мужской')

employee1.consume_vacation(7)
print(employee1.get_vacation_details())


# Пример использования класса:
# employee = Employee('Роберт', 'Крузо', 'м')
# employee.consume_vacation(7)
# print(employee.get_vacation_details())