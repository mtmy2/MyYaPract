"""Документация модуля. Описывает работу классов и функций.
Размещается в верхней части файла (начиная с первой строки).
"""


def tricky_func(self):
    """Описывает работу функции tricky_func."""
    ...


class Test:
    """Класс Test используется для демонстрации docstring.
    После docstring в классе нужна пустая строка.
    """

    def first(self):
        """Этот docstring описывает метод first().
        И демонстрирует перенос строки документации.
        """
        ...

  def tricky_func():
      """Можно перенести
      так.
      """
      ...
  
  def muddy_func():
      """
      А можно -
      так.
      """
      ...
  

  import math

# Что хорошего есть в библиотеке math?
print(math.__doc__)
#This module provides access to the mathematical functions
#defined by the C standard.