import requests

response = requests.get('https://ya.ru/white')

# вот мы узнали, что код ответа 200, и заполучили это число в свой код:
code = response.status_code
print(f'Код ответа = {code}')

# а вот мы и заголовки читаем, и выводим их форматированной строкой
# с примечанием, каким захочется, на любом языке
headers = response.headers
print(f'Тип содержимого: {headers["content-type"]}')
#print(f'Время ответа: {headers[date]}')


import requests

request_headers = {
    'Accept-Language': 'ru'  # попросим материал на русском языке
}

# сходим почитать блоги про IT, строкой передаём URL платформы habr[.com](https://habr.com/)
response = requests.get('https://habr.com', headers=request_headers)

print(response.text)


import requests
request_headers = {
    'Accept-Language': 'en'  # попросим материал на английском языке
}
# сходим почитать блоги про IT
response = requests.get('https://habr.com', headers=request_headers)
print(response.text)