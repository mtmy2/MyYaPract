from gameparts import Board

game = Board()
print(type(game))

# Выведется:
# <class 'gameparts.parts.Board'>



print(type(game) is Board)
print(type(game) == Board)
print(type(game) == str)

# Выведется: 
# True
# True
# False


from gameparts import Board

game = Board()

print(isinstance(game, Board))
print(isinstance(game, str))

# Выведется:
# True
# Falsefrom gameparts import Board


from gameparts import Board

game = Board()
print(game.__class__)

# Выведется: 
# <class 'gameparts.parts.Board'>


from gameparts import Board

game = Board()
print(dir(game))

# Выведется:
#['__class__', '__delattr__', '__dict__', '__dir__', '__doc__', '__eq__', '__format__', '__ge__', '__getattribute__', '__gt__', '__hash__', '__init__', '__init_subclass__', '__le__', '__lt__', '__module__', '__ne__', '__new__', '__reduce__', '__reduce_ex__', '__repr__', '__setattr__', '__sizeof__', '__str__', '__subclasshook__', '__weakref__', 'board', 'display', 'make_move']

from gameparts import Board

game = Board()

print('__str__' in dir(game))

# Выведется:
# True


from gameparts import Board

game = Board()

print(hasattr(game, '__str__'))

# Выведется:
# True


# gameparts/parts.py

class Board:

    # Новый атрибут.
    field_size = 3

    def __init__(self):
        self.board = [
            [' ' for _ in range(self.field_size)] for _ in range(self.field_size)
        ]

    def make_move(self, row, col, player):
        self.board[row][col] = player

    def display(self):
        for row in self.board:
            print('|'.join(row))
            print('-' * 5)

    # Переопределяем метод __str__.
    def __str__(self):
        return (
            'Объект игрового поля размером '
            f'{self.field_size}x{self.field_size}'
        )
    

    from gameparts import Board

game = Board()
print(game.__class__.__dict__)

# Выведется:
# {'__module__': 'gameparts.parts', '__init__': <function Board.__init__ at 0x104f95f70>, 'make_move': <function Board.make_move at 0x104fa3040>, 'display': <function Board.display at 0x104fa30d0>, '__dict__': <attribute '__dict__' of 'Board' objects>, '__weakref__': <attribute '__weakref__' of 'Board' objects>, '__doc__': None}

# Из модуля inspect импортировать функцию getsource.
from inspect import getsource

from gameparts import Board

game = Board()

# Функция getsource() в работе.
print(getsource(Board))

#Вывод в терминал будет таким:
class Board:

    field_size = 3

    def __init__(self):
        self.board = [[' ' for _ in range(3)] for _ in range(3)]

    def make_move(self, row, col, player):
        self.board[row][col] = player
    def display(self):
        for row in self.board:
            print('|'.join(row))
            print('-' * 5)


# Из модуля inspect импортировать функцию isfunction.
from inspect import isfunction

from gameparts import Board

game = Board()

# display() - это функция?
print(isfunction(game.display))

# Выведется:
# False

# Из модуля inspect импортировать функцию ismethod.
from inspect import ismethod

from gameparts import Board

game = Board()

# display() - это метод?
print(ismethod(game.display))

#  Вывод: True