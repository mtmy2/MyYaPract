# gameparts/exceptions.py

class FieldIndexError(IndexError):

    def __str__(self):
        return 'Введено значение за границами игрового поля'

# Вот оно - новое исключение, унаследованное от базового класса Exception.
class CellOccupiedError(Exception):

    def __str__(self):
        return 'Попытка изменить занятую ячейку'
    

while running:
    print(f'Ход делают {current_player}')
    while True:
        try:
            row = int(input('Введите номер строки: '))
            if row < 0 or row >= game.field_size:
                raise FieldIndexError
            column = int(input('Введите номер столбца: '))
            if column < 0 or column >= game.field_size:
                raise FieldIndexError
            if game.board[row][column] != ' ':
                raise CellOccupiedError
        except FieldIndexError:
            print(
                'Значение должно быть неотрицательным и меньше '
            f'{game.field_size}.'
            )
            print('Введите значения для строки и столбца заново.')
            continue
        except CellOccupiedError:
                print('Ячейка занята.')
                print('Пожалуйста, введите другие координаты.')
                continue
        except ValueError:
                print('Буквы вводить нельзя. Только числа.')
                print('Введите значения для строки и столбца заново.')
                continue
        except Exception as e:
                print(f'Возникла ошибка: {e}')
            else:
                break