address = 'На деревню дедушке'
recipient = 'Константин Макарыч'

print(address.__class__)
print(recipient.__class__)

# <class 'str'>
# <class 'str'>



address = 'На деревню дедушке'
uppercase_address = address.upper()
print(uppercase_address)

# Выведется:
# НА ДЕРЕВНЮ ДЕДУШКЕ



address = 'На деревню дедушке'
uppercase_address = str.upper(address)
print(uppercase_address)

# Выведется:
# НА ДЕРЕВНЮ ДЕДУШКЕ