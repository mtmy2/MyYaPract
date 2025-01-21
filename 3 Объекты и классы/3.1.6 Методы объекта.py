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


