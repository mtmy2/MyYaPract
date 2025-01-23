class BacteriaProducer:
    
    # Допишите инициализатор класса 
    def __init__(self, max_qty):
        self.current_qty = 0
        self.max_qty = max_qty
        self.message  = ''

    # Допишите метод
    def create_new(self):
        if self.current_qty == self.max_qty:
            self.message = 'Нет места под новую бактерию'
        else:
            self.current_qty += 1
            self.message = f'Добавлена одна бактерия. Количество бактерий в популяции: {self.current_qty}'
        return print(self.message)
 

    # Допишите метод
    def remove_one(self):
        if self.current_qty == 0:
            self.message = 'В популяции нет бактерий, удалять нечего'
        else:
            self.current_qty -= 1
            self.message = f'Одна бактерия удалена. Количество бактерий в популяции: {self.current_qty}'
        return print(self.message)

# Пример запуска для самопроверки
bacteria_producer = BacteriaProducer(max_qty=3)
bacteria_producer.remove_one()
bacteria_producer.create_new()
bacteria_producer.create_new()
bacteria_producer.create_new()
bacteria_producer.create_new()
bacteria_producer.remove_one()