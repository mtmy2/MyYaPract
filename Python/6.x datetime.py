# Пропишите нужные импорты.
from datetime import datetime as dt, timedelta as tdlt

# Напишите код функции, следуя плану из задания.
def get_results(lider_time_str, participant_time_str):
    if lider_time_str == participant_time_str:
            print('Вы пробежали за', lider_time_str, 'и победили!')
    else:
    #lider_time_dt = dt.time(dt.strptime(lider_time_str, '%H:%M:%S'))
    # #participant_time_dt = dt.time(dt.strptime(participant_time_str, '%H:%M:%S'))
        lider_time_dt = dt.strptime(lider_time_str, '%H:%M:%S')
        participant_time_dt = dt.strptime(participant_time_str, '%H:%M:%S')
        delta_time_sec = tdlt.total_seconds(participant_time_dt - lider_time_dt)
        delta_time_dt = tdlt(seconds = delta_time_sec)
        print('Вы пробежали за', participant_time_str ,'с отставанием от лидера', delta_time_dt)
        #print(delta_time_sec, delta_time_dt)
                                                                                        
    # Проверьте работу программы, можете подставить свои значения.
get_results('02:02:02', '02:02:02')
get_results('02:02:02', '03:04:05')