# Объявите функцию check_winners с параметрами scores и student_score.
# Функция должна напечатать результат в заданном формате.
def check_winners(scores, student_score):
    list.sort(scores, reverse=True)
    if scores[0] == student_score or  scores[1] == student_score or scores[2] == student_score:
        print('Вы в тройке победителей!')
    else:
        print('Вы не попали в тройку победителей.')
    

# Вызовы для проверки работы функции check_winners().
# Три набора данных - для проверки разных ситуаций.
first_olympiad_scores = [20, 48, 52, 38, 36, 13, 7, 41, 34, 24, 5, 51, 9, 14, 28, 42, 40, 39, 1, 45, 37, 10, 31, 27, 17, 46, 2, 22, 35, 55]
check_winners(first_olympiad_scores, 52)

second_olympiad_scores = [22, 4, 42, 5, 54, 28, 19, 33, 8, 16, 23, 40, 39, 58, 9, 13, 48, 2, 51, 41, 21, 36, 55, 25, 31, 45, 44, 30, 1, 10]
check_winners(second_olympiad_scores, 4)

third_olympiad_scores = [36, 1, 49, 27, 8, 23, 13, 56, 46, 33, 45, 30, 16, 11, 41, 19, 43, 54, 39, 38, 40, 48, 34, 26, 5, 28, 21, 3, 51, 44]
check_winners(third_olympiad_scores, 21)



# Объявите функцию get_stickers_comparison() с параметрами collection_1 и collection_2.
# Эта функция должна возвращать кортеж из трёх коллекций:
# - уникальные_стикеры из collection_1,
# - уникальные_стикеры из collection_2,
# - стикеры, которые есть в collection_1 и в collection_2.
def get_stickers_comparison(collection_1, collection_2):
    collection_1 = set(sorted(collection_1))
    collection_2 = set(sorted(collection_2))
    unique_1 = list(sorted(collection_1 - collection_2))
    unique_2 = list(sorted(collection_2 - collection_1))
    all_coolections = list(sorted(collection_2 & collection_1))
    return unique_1, unique_2, all_coolections
    
# Списки стикеров:
stas_collection = ['Тим Бернерс-Ли', 'Линус Торвальдс', 'Ада Лавлейс', 'Линус Торвальдс', 'Маргарет Гамильтон', 'Бьярн Страуструп']
anton_collection = ['Тим Бернерс-Ли', 'Гвидо ван Россум', 'Линус Торвальдс', 'Бьярн Страуструп', 'Бьярн Страуструп', 'Кен Томпсон', 'Деннис Ричи']

# Вызываем функцию и распаковываем полученный кортеж в три переменные:
stas_stickers, anton_stickers, common_stickers = get_stickers_comparison(stas_collection, anton_collection)
# Печатаем результаты:
print('Стикеры, которые есть только у Стаса:', stas_stickers)
print('Стикеры, которые есть только у Антона:', anton_stickers)
print('Стикеры, которые есть и у Стаса, и у Антона:', common_stickers)



def is_palindrome(text):
    # Ваш код здесь
    text = str.lower(str.replace(text, ' ', ''))
    text_lenght = len(text)
    print(text_lenght)
    if text_lenght // 2 ==  text_lenght / 2:
        midlle = int(text_lenght/2)
        print(midlle)
        left_part = text[:midlle+1]
        right_part = text[midlle-1:]
        right_part = right_part[::-1]   
        print(right_part, left_part)
    else:
        midlle = int(text_lenght//2)
        print(midlle)
        left_part = text[:midlle]
        right_part = text[midlle+1:]
        right_part = right_part[::-1]
        print(right_part, left_part)
    if right_part == left_part:
        return True
    else:
        return False

# Должно быть напечатано True:
print(is_palindrome('А роза упала на лапу Азора'))
# Должно быть напечатано False:
print(is_palindrome('Не палиндром'))





def pay_bills(month, bills):
    # Ваш код здесь
    if month // 3 == month / 3:
        payment_list = bills[1:-1]
        print(payment_list)
        return payment_list
    else:
        payment_list = bills[:1] + bills[-1:]
        print(payment_list)
        return payment_list
        


# Вызов функции:
print(pay_bills(5, ['Интернет', 'Коммуналка', 'Телефон', 'Страховка']))


