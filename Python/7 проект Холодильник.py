import datetime
from datetime import datetime as dt, timedelta
from decimal import Decimal


goods = {}
goods = {
    'Пельмени Универсальные': [
        {'amount': Decimal('0.5'), 'expiration_date': datetime.date(2025, 1, 5)},
        {'amount': Decimal('2'), 'expiration_date': datetime.date(2025, 1, 4)}
    ],
    'Вода': [{'amount': Decimal('1.5'), 'expiration_date': None}]
}
DATE_FORMAT = '%Y-%m-%d'

def add(items, title, amount, expiration_date=None):
    expiration_date = dt.strptime(expiration_date, DATE_FORMAT).date() if expiration_date else None
    print('expiration_date, amount:', expiration_date, amount)
    if title in items:
        add_item = {'amount': amount, 'expiration_date': expiration_date}
        print('add_item:', add_item)
        list.append(items[title], add_item)
        print('items:', items)
    else:
        items[title] = []
        list.append(items[title], {'amount': amount, 'expiration_date': expiration_date})
        print('items:', items)
    
print()
print('ADD:')
add(goods, 'Пельмени Универсальные', Decimal('2'), '2023-10-28')
#add(goods, 'Яйца', Decimal('10'), '2023-9-30')
#add(goods, 'Яйца', Decimal('3'), '2023-10-15')
#add(goods, 'Вода', Decimal('2.5'))

def add_by_note(items, note):
    splited_note = str.split(note)
    print('splited_note:',  splited_note)
    if note[-3] == '-':
        expiration_date = list.pop(splited_note, -1) 
        expiration_date = dt.strptime(expiration_date, DATE_FORMAT).date() 
    else:
        expiration_date = None
    print('expiration_date:', expiration_date)
    print('splited_note:', splited_note)
     
    amount = Decimal(list.pop(splited_note, -1))
    title = str.join(' ', splited_note)
    print('amount:', amount)
    print('title:', title)
        
    if title in items:
        add_item = {'amount': amount, 'expiration_date': expiration_date}
        print('add_item:', add_item)
        list.append(items[title], add_item)
        print('items:', items)
    else:
        items[title] = []
        list.append(items[title], {'amount': amount, 'expiration_date': expiration_date})
        print('items:', items)

#    pass
print()
print('ADD BY NOTE:')
add_by_note(goods, 'Яйца гусиные 4 2023-07-15')
#add_by_note(goods, 'курица 5')

def find(items, needle):
    find_list = []
    for title in items:
        if str.find(str.lower(title), str.lower(needle)) >= 0:
            list.append(find_list, title)
    print('find_list:', find_list)
    return find_list
            
    
print()
print('FIND:')
print(find(goods, 'йц'))
print(find(goods, 'Яйца гусиные'))


def amount(items, needle):
    find_amount = Decimal(0)
    for title in items:
        if str.find(str.lower(title), str.lower(needle)) >= 0:
            print('количество партий:', len(items[title]))
            List_len = len(items[title])
            for batch in range(List_len):
                print(Decimal(items[title][batch]['amount'])) #[batch][amount]
                find_amount += Decimal(items[title][batch]['amount'])
    return find_amount
print()
print('AMOUNT:')
#print(amount(goods, 'йц'))
print('всего доступно продукта', amount(goods, 'Пельмени'))

def expire(items, in_advance_days=0):
    today = datetime.date.today()
    print('сегодня:', today)
    expire_list = []
    for title in items:
        item_list_len = len(items[title])
        expired_amount = 0
        for batch in range(item_list_len):
            expiration_date = items[title][batch]['expiration_date']
            print(title, expiration_date)
            
            if expiration_date == None:
                continue
            else:
                print('-delta:', title, expiration_date - timedelta(in_advance_days))
                if expiration_date - timedelta(in_advance_days) <= today:
                    expired_amount += items[title][batch]['amount']
        print('expired_amount', expired_amount)
        if expired_amount>0:
            list.append(expire_list, (title,  expired_amount)) 

    return expire_list

print()
print('EXPIRE:')
print(expire(goods))
