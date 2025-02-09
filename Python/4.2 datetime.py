from datetime import datetime

exact_deadline = datetime(2023, 11, 6, 9, 15, 00)

# Из типа datetime получен тип date.
date_from_datetime = datetime.date(exact_deadline)
print('Ваш дедлайн:', date_from_datetime)

# Из типа datetime получен тип time.
time_from_datetime = datetime.time(exact_deadline)
print('Презентация проекта состоится в', time_from_datetime)


from datetime import datetime, date

deadline = date(2023, 11, 6)
today = date(2023, 10, 12)

deadline_detail = datetime(2023, 11, 6, 9, 15, 00)
today_detail = datetime(2023, 10, 12, 22, 13, 55)

print('Разность дат:', deadline - today, type(deadline - today))
print('Разность дат и времени:', deadline_detail - today_detail, type(deadline_detail - today_detail))



# В программу импортированы типы datetime и timedelta.
from datetime import datetime, timedelta

deadline_detail = datetime(2023, 11, 6, 13, 00, 00)
today_detail = datetime(2023, 10, 12, 22, 13, 55)

print(timedelta.total_seconds(deadline_detail - today_detail))


from datetime import datetime

datetime1 = datetime(2023, 8, 13, 3, 0, 0)  # 13 августа 2023 года, 3 утра
datetime2 = datetime.replace(datetime1, year=2019)  # 13 августа 2019 года, 3 утра

print('Исходная дата:', datetime1)
print('Изменённая дата:', datetime2)



from datetime import datetime, date

# При помощи now() получаем текущую дату и время.
now = datetime.now()  
# При помощи today() получаем текущую дату.
today_1 = datetime.today()
today_2 = date.today()

print('Сегодняшняя дата и текущее время через now():', now, type(now))
print('Сегодняшняя дата через datetime и today():', today_1, type(today_1))
print('Сегодняшняя дата через date и today():', today_2, type(today_2))


from datetime import datetime

deadline = datetime(2023, 11, 6, 13, 0, 0)
# Синтаксис: datetime.strftime(<дата>, 'шаблон_для_форматирования')
deadline_as_str = datetime.strftime(deadline, '%Y/%m/%d %H:%M')
print('Ваш дедлайн:', deadline_as_str)
# Выведется:
# Ваш дедлайн: 2023/11/06 13:00



from datetime import datetime
# %Y - год, %m - месяц, %d - день, %H - часы, %M - минуты

# Сохраняем в переменную строку с датой в странном формате.
datetime_as_str = '14/08 2023 04-01'

# Составляем шаблон %d/%m %Y %H-%M 
# и преобразуем строку в значение типа datetime.
datetime_as_datetime = datetime.strptime(datetime_as_str, '%d/%m %Y %H-%M')

# Смотрим, что получилось:
print(datetime_as_datetime, type(datetime_as_datetime))



# Допишите нужные импорты.
from datetime import datetime, timedelta

def timedelta_days(datetime_str_1, datetime_str_2):
    # Напишите тело функции.
    datetime_1 = datetime.strptime(datetime_str_1, '%Y/%m/%d %H:%M:%S')
    datetime_2 = datetime.strptime(datetime_str_2, '%Y/%m/%d %H:%M:%S')
    delta = (datetime_2 - datetime_1)
    #delta = timedelta.days(delta)
    return delta.days

difference = timedelta_days('2019/05/10 00:00:00', '2019/10/04 00:00:00')

print('От начала посевной до начала сбора урожая прошло', difference, 'дней.')

