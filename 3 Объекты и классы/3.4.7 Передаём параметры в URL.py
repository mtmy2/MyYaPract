import requests

search_parameters = {
    'text': 'кто такой инженер данных',
    'lr': 213
}
url = 'https://yandex.ru/search/'
# Функция get() приняла на вход URL и параметры поиска,
# а дальше она знает, что делать.
response = requests.get(url, params=search_parameters)

print(response.status_code)
print(response.url)


import requests


url = 'https://wttr.in'  # не изменяйте значение URL

weather_parameters = {
    '0': '',
    'T': ''
    # добавьте параметр запроса `T`, чтобы вернулся чёрно-белый текст
}

response = requests.get(url, params=weather_parameters)  # передайте параметры в http-запрос

print(response.text)



import requests


url = 'https://wttr.in'

weather_parameters = {
    '0': '',
    'T': '',
    'M': '',
    'lang': 'ru'
}
response = requests.get(url, params=weather_parameters)
print(response.text)

