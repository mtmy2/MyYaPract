class MushroomsCollector:
    # Проверьте, нет ли здесь ошибки:
    
    def __init__(self):
        mushrooms = []

    # Исправьте ошибку в этом методе.
    def is_poisonous(self, mushroom_name):
        if mushroom_name == 'Мухомор' or 'Поганка':
            return True
        else:
            return False

    # Допишите метод.
    def add_mushroom(self, mushroom_name):
        if self.is_poisonous(mushroom_name) == False:
            list.append(self.mushrooms, mushroom_name)
        else:
            print('Нельзя добавить ядовитый гриб')
            
    def __str__(self):
        return [str(item) for item in self.mushrooms] #f'{self.mushrooms}'



    
    # Напишите магический метод __str__,
    # возвращающий перечень грибов из списка mushrooms 
    # через запятую.


# Пример запуска для самопроверки
collector_1 = MushroomsCollector()
collector_1.add_mushroom('Мухомор')
collector_1.add_mushroom('Подосиновик')
collector_1.add_mushroom('Белый')
print(collector_1)

collector_2 = MushroomsCollector()
collector_2.add_mushroom('Лисичка')
print(collector_1)
print(collector_2)