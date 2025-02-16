"""
номер посылки 133508511
ссылка на задачи: https://docs.google.com/document/d/1jS9krtw0in6M4_yWoU-glYbkGIZH1HIZBiqXAa4Tp8c/edit?tab=t.0
"""

def pl_qty(robots_list: list[int], limit: int) -> int:
    '''
    Функция создана для подсчет минимального и достаточного количества
    платформ для перевозки роботов в количестве равному количеству элементов
    массива robots_list, каждый элемент содержит вес робота.
    Общий вес одного или двух роботов на платформе не должен превышать limit
    '''
    robots_list = sorted(robots_list, reverse=True)
    i = 0
    platforms = 0
    start_length = len(robots_list)
    while i < start_length-1 and len(robots_list)>1:
        a = 1
        while a < len(robots_list):
            weight_sum = robots_list[0] + robots_list[a]    
            if weight_sum <= limit:
                platforms += 1
                list.remove(robots_list, robots_list[0])
                list.remove(robots_list, robots_list[a-1])
            elif weight_sum > limit and a == len(robots_list)-1:
                platforms += 1
                list.remove(robots_list, robots_list[0])
            a += 1
        i += 1
    if len(robots_list) == 1:
        platforms += 1
    return platforms

if __name__ == '__main__':
#    for weight in input().split()
#        robots_list = int(weight)
    robots_list = [50]
    limit = 100 # int(input())

    print(pl_qty(robots_list, limit))