# Импортируем библиотеку:
import requests

# Отправляем GET-запрос:
response = requests.get('http://info.cern.ch/')

print(response.text)  # Печатаем код запрошенной страницы.


import requests

search_parameters = {
    'text': 'что такое backend',
    'lr': 213
}
url = 'https://yandex.ru/search/'

# Функция get() принимает на вход URL и
# параметры запроса через именованный аргумент params.
response = requests.get(url, params=search_parameters)
print(response.url)

# Вывод в терминал:
# https://yandex.ru/search/?text=%D1%87%D1%82%D0%BE+%D1%82%D0%B0%D0%BA%D0
# %BE%D0%B5+backend&lr=213


try:
    response = requests.get(url)
except requests.ConnectionError:
    return '<сетевая ошибка>'


import requests

url = 'http://wttr.in/ufa?0T'

response = requests.get(url)  # Выполните HTTP-запрос.

print(response.text)  # Напечатайте статус-код ответа.