class Product:
    # Опишите инициализатор класса и метод get_info()
    def __init__(self, name, qty):
        self.name = name
        self.qty = qty

    def get_info(self):
        return f'{self.name} (в наличии: {self.qty})'
        


class Kettlebell(Product):
    # Опишите инициализитор класса и метод get_weight()
    def __init__(self, name, qty, weight):
        super().__init__(name, qty)
        self.weight = weight

    def get_weight(self):
        return f'{self.get_info()}. Вес: {self.weight} кг'    


class Clothing(Product):
    # Опишите инициализатор класса и метод get_size()
    def __init__(self, name, qty, size):
        super().__init__(name, qty)
        self.size = size
    
    def get_size(self):
        return f'{self.get_info()}. Размер: {self.size}'    


# Для проверки вашего кода создадим пару объектов
# и вызовем их методы:
small_kettlebell = Kettlebell('Гиря малая', 15, 2)
shirt = Clothing('Футболка', 5, 'L')

print(small_kettlebell.get_weight())
print(shirt.get_size())