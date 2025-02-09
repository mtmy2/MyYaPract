# Пропишите нужные импорты.
from datetime import datetime, timedelta 

def get_weekday_name(weekday_number):
    if weekday_number == 0:
        return 'понедельник'
    # Продолжите писать код.
    elif weekday_number == 1:
        return 'вторник'
    elif weekday_number == 2:
        return 'среда'
    elif weekday_number == 3:
        return 'четверг'
    elif weekday_number == 4:
        return 'пятница'
    elif weekday_number == 5:
        return 'суббота'
    elif weekday_number == 6:
        return 'воскресенье'

def get_day_after_tomorrow(date_string):
    # Напишите код функции.
    today_date_dt = datetime.strptime(date_string, '%Y-%m-%d')
    today_date_num = today_date_dt.weekday()
    today_weekday_name = get_weekday_name(today_date_num)
    day_after_tomorrow_num = (today_date_dt + timedelta(2)).weekday()
    day_after_tomorrow_weekday = get_weekday_name(day_after_tomorrow_num)
    print('Сегодня', str(today_date_dt.date()) + ',', today_weekday_name + ', а послезавтра будет', day_after_tomorrow_weekday)


# Проверьте работу программы, можете подставить свои значения.
get_day_after_tomorrow('2024-01-01')
get_day_after_tomorrow('2024-01-02')
get_day_after_tomorrow('2024-01-03')
get_day_after_tomorrow('2024-01-04')
get_day_after_tomorrow('2024-01-05')
get_day_after_tomorrow('2024-01-06')


# Пропишите нужные импорты.
from datetime import datetime as dt, timedelta as tdlt

# Напишите код функции, следуя плану из задания.
def get_results(lider_time_str, participant_time_str):
    if lider_time_str == participant_time_str:
        print('Вы пробежали за', lider_time_str, 'и победили!')
    else:
        #lider_time_dt = dt.time(dt.strptime(lider_time_str, '%H:%M:%S'))
        #participant_time_dt = dt.time(dt.strptime(participant_time_str, '%H:%M:%S'))
        lider_time_dt = dt.strptime(lider_time_str, '%H:%M:%S')
        participant_time_dt = dt.strptime(participant_time_str, '%H:%M:%S')
        delta_time_sec = tdlt.total_seconds(participant_time_dt - lider_time_dt)
        delta_time_dt = tdlt(seconds = delta_time_sec)
        print('Вы пробежали за', participant_time_str ,'с отставанием от лидера', delta_time_dt)
        #print(delta_time_sec, delta_time_dt)
        
# Проверьте работу программы, можете подставить свои значения.
get_results('02:02:02', '02:02:02')
get_results('02:02:02', '03:04:05')


# Пропишите нужные импорты.
from decimal import Decimal as dc, getcontext



# Напишите код функции.
def get_monthly_payment(summ, months, percent):
    # Банк делит названную сумму на названное количество месяцев 
    # и увеличивает ежемесячный платёж на оговоренный процент.
    summ_per_month = dc(summ / months)
    percent_per_month = dc(summ_per_month * percent / 100)
    # Функция должна вернуть сумму ежемесячного платежа по кредиту.
    getcontext().prec = 3
    return summ_per_month + percent_per_month


# Вызовите функцию get_monthly_payment() 
# с указанными в задании аргументами
# и распечатайте нужное сообщение.
print('Ежемесячный платёж:', get_monthly_payment(54, 24, 9), 'ВтК')
