# parser_with_authorization.py
import requests
from bs4 import BeautifulSoup

LOGIN_URL = 'http://158.160.172.156/login/'

if __name__ == '__main__':
    data = {
        'username': 'test_parser_user',
        'password': 'testpassword',
    }
    
    session = requests.session()
    #print(session.cookies.get_dict())
    response = session.get(LOGIN_URL)
    
    #поиск csrfm
    print(str.find(response.text, 'csrfmiddlewaretoken'))
    splitted_request = response.text.split()
    print(splitted_request)
    item_num = -1
    for item in splitted_request:
        item_num += 1
        if str.find(item, 'csrfmiddlewaretoken') >= 0:
            value_list = (splitted_request[item_num+1]).split('"')
            value = value_list[1]
            print(value)
    soup = BeautifulSoup(response.text, 'html.parser')
    value = soup.find('input', {'name': 'csrfmiddlewaretoken'})
    token = value['value']
    print(token)
    data['csrfmiddlewaretoken'] = token
    print(data)
    #print(response.text)

    print(session.cookies.get_dict())
    response = session.post(LOGIN_URL, data=data)
    response.encoding = 'utf-8'
    #print(response.text)
    print(response.status_code)