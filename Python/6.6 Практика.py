def print_pack_report(starting_value):
    # Дополните функцию
    for i in range(starting_value, 0, -1):
        #print(i)
        if i // 3 == i / 3 and i // 5 == i / 5:
            print(f'{i} - расфасуем по 3 или по 5')
        elif i // 3 != i / 3 and i // 5 == i / 5:
            print(f'{i} - расфасуем по 5')
        elif i // 3 == i / 3 and i // 5 != i / 5:
            print(f'{i} - расфасуем по 3')
        else:
            print(f'{i} - не заказываем!')
           

print_pack_report(31)



def count_canisters(temperatures_per_day):
    hot_days_counter = 0
    # Допишите функцию.
    for day in temperatures_per_day:
        if day >=30:
            hot_days_counter = hot_days_counter + 1
    return hot_days_counter 


forecast_temperatures = [26, 28, 30, 31, 29, 31, 28, 26]
# Вызовите функцию и напечатайте результат в нужном формате.
days = count_canisters(forecast_temperatures)
print(f'Нужно канистр: {days}')




def print_multiplication_table():
    # Напишите код, который напечатает таблицу умножения.
    for x in range(1,10):
        for y in range(1,10):
            print(f'{x} * {y} = {x*y}')
        print('----------')


print_multiplication_table()




# Напишите функцию get_competition_data().
def get_competition_data(data):
    team_list = []
    for race_number in data:
        team_list_current_race = list(dict.keys(race_number))
        for team in team_list_current_race:
            if team not in team_list:
                list.append(team_list, team)
    print(f'Команды, участвовавшие в гонке: {', '.join(sorted(team_list))}') 

races_data = [
    {'Ferrari': 20, 'Mercedes': 5, 'Aston Martin': 10, 'Williams': 15},
    {'Mercedes': 15, 'Aston Martin': 20, 'Ferrari': 10, 'Williams': 0},
    {'Ferrari': 20, 'Williams': 15, 'Aston Martin': 10, 'Mercedes': 5}
]


get_competition_data(races_data)




# Напишите функцию get_competition_data().
def get_competition_data(data):
    team_list = []
    scores = dict()
    for race_number in data:
        #team_list_current_race = list(dict.keys(race_number))
        for team, score in race_number.items():
            if team not in team_list:
                list.append(team_list, team)
                dict.update(scores, team=score)
                scores[team] = 0
            scores[team] += score
    
    winner_team = None
    winner_score = 0
    
    for team, score in scores.items():
        if score > winner_score:
            winner_score = score
            winner_team = team
            
    print(f'Команды, участвовавшие в гонке: {', '.join(sorted(team_list))}') 
    print(f'В гонке победила команда {winner_team} с результатом {winner_score} баллов') 

races_data = [
    {'Ferrari': 20, 'Mercedes': 5, 'Aston Martin': 10, 'Williams': 15},
    {'Mercedes': 15, 'Aston Martin': 20, 'Ferrari': 10, 'Williams': 0},
    {'Ferrari': 20, 'Williams': 15, 'Aston Martin': 10, 'Mercedes': 5}
]


get_competition_data(races_data)