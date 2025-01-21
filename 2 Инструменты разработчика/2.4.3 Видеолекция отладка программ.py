from utils import multiplier


def get_42():
    result = multiplier()
    if result != 42:
        raise ValueError


if __name__ == '__main__':
    get_42()



    def get_first_number():
    return 6


def get_second_number():
    return 6


def multiplier():
    first_number = get_first_number()
    second_number = get_second_number()
    product_of_numbers = first_number * second_number
    return product_of_numbers



def get_greetings():
    greetings = 'Hello'
    greetings = update_greetings(greetings)
    return greetings + '!'


def update_greetings(local_greetings):
    new_greetings = local_greetings + 'world'
    return new_greetings


if __name__ == '__main__':
    result = get_greetings()    
    print(result)



    from random import randint


def division(divident, divisor):
    return divident/divisor


if __name__ == '__main__':
    while True:
        a = randint(-100, 100)
        b = randint(-10, 10)
        result = division(a, b)
        print(result)