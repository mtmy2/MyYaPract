#2.
#Начинающий, но в будущем успешный разработчик никак не угомонится. «А правильно ли было выбрать Python? Может, надо было заняться изучением Java или даже C#? Посмотрю статистику по вакансиям».
#В Интернете нашлось исследование: всемирный рейтинг языков программирования по числу вакансий. Вакансий много, их количество указано в тысячах:
#c_sharp = 375
#java = 546
#javascript = 915
#... 
#Напишите функцию analyze_jobs(), которая:
#подсчитает общее количество вакансий в перечне,
#подсчитает процент вакансий для Python от числа исследованных вакансий,
#с помощью встроенной функции round() округлит полученное значение до двух знаков после запятой (до сотых долей),
#напечатает фразы:
#Общее число исследованных вакансий, в тысячах: <сумма_всех_вакансий>
#Вакансии для Python-разработчиков, в %: <процент_вакансий_для_Python> 
#Не применяйте в функции оператор return: функция должна только напечатать две строки.
#Многоточия из прекода нужно удалить.

c_sharp = 375
java = 546
javascript = 915
php = 288
python = 603

def analyze_jobs():
    # Вычислите общее количество исследованных вакансий.
    total_jobs = c_sharp + java + javascript + php + python
    # Вычислите процент вакансий для Python от общего числа вакансий
    python_percent_raw = python/total_jobs * 100
    # и округлите результат до двух знаков (до сотых долей):
    python_percent = round(python_percent_raw, 2)
    # Напечатайте фразы, описанные в задании (две строки).
    print('Общее число исследованных вакансий, в тысячах:', total_jobs)
    print('Вакансии для Python-разработчиков, в %:', python_percent)

analyze_jobs()