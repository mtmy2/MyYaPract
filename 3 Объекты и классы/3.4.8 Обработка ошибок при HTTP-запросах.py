import requests

try:
    response = requests.get('https://some_url.com')
# Любые ошибки, которые могут возникнуть в ходе выполнения сетевого запроса
# могут быть перехвачены при помощи базового класса RequestException.
except requests.RequestException:
    pass


import requests

try:
    # Выполняя запрос, получаем объект класса Response.
    response = requests.get('https://some_url.com')
    # Вызываем ошибку HTTPError, если код ответа относится к неуспешным.
    response.raise_for_status()
# Можно обработать 400-500-ые коды в блоке `HTTPError`...
except requests.HTTPError: 
    pass
# А можно в общей ветке.
except requests.RequestException:
    pass


import requests


cities = [
    'Омск',
    'Калининград',
    'Челябинск',
    'Владивосток',
    'Красноярск',
    'Москва',
    'Екатеринбург'
]


def make_url(city):
    # в URL задаём город, в котором узнаем погоду
    return f'http://wttr.in/{city}'


def make_parameters():
    params = {
        'format': 2,  # погода одной строкой
        'M': ''  # скорость ветра в "м/с"
    }
    return params


def what_weather(city):
    # Напишите тело этой функции.
    try:
        response = requests.get(make_url(city), params=make_parameters())
        response.raise_for_status()
        #print(response.status_code)
        status = response.status_code
        if status != 200:
            return f'<ошибка на сервере погоды>'
        else:
            return response.text
    except requests.ConnectionError:
        return f'<сетевая ошибка>'
        pass
    # Не изменяйте остальной код!

print('Погода в городах:')
for city in cities:
    print(city, what_weather(city))