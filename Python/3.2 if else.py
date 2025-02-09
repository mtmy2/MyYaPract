#<действие_если_True> if <условие> else <действие_если_False>

total_harvest_value = 120

# …четырёхстрочный код превращается в одну строку!
print('Урожай получен!') if total_harvest_value else print('Урожая нет!')

print('Проверка окончена.')



# Объявите функцию get_season(), принимающую на вход название месяца;
# функция должна вернуть название сезона, которому принадлежит месяц
# или строку "Ошибка в написании месяца!"
def get_season(mounth):
# Место для вашего кода
    if  mounth == 'январь':
        season = 'зима'
        return season
    elif mounth == 'февраль':
        season = 'зима'
        return season
    elif mounth == 'март':
        season = 'весна'
        return season
    elif mounth == 'апрель':
        season = 'весна'
        return season
    elif mounth == 'май':
        season = 'весна'
        return season
    elif mounth == 'июнь':
        season = 'лето'
        return season
    elif mounth == 'июль':
        season = 'лето'
        return season
    elif mounth == 'август':
        season = 'лето'
        return season
    elif mounth == 'сентябрь':
        season = 'осень'
        return season
    elif mounth == 'октябрь':
        season = 'осень'
        return season
    elif mounth == 'ноябрь':
        season = 'осень'
        return season
    elif mounth == 'декабрь':
        season = 'зима'
        return season
    else:
        season = 'Ошибка в написании месяца!'
        return season

# Для контроля вызовем функцию и напечатаем результат.
print(get_season('июнь'))
print(get_season('мартобрь'))


