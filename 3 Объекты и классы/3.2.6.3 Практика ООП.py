class Customer:
    def __init__(self, name):
        self.name = name
        # Добавьте сюда атрибут "скидка" со значением по умолчанию 10.
        self.__discount = 10

        # Реализуйте методы get_price() и set_discount().
    def get_price(self, price):
        self.dicounted_price = round(price * (1 - self.__discount / 100), 2)
        return self.dicounted_price

    def set_discount(self, new_discount):
        self.__discount = new_discount if new_discount<=80 else 80
        
customer = Customer("Иван Иванович")
print(customer.get_price(100))
print(customer.set_discount(20))
print(customer.get_price(100))