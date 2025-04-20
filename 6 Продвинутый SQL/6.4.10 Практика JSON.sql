1.
Поставщик продукта «матча» (японский зелёный чай) прислал сертификат соответствия на товар:

{
    "product_name": "чай матча",
    "date": "23.07.2023",
    "signed": [
        "Морковкин А.А.",
        "Зеленая Е.А."
    ],
    "weight": 200,
    "country": "Вьетнам"   
} 
Добавьте этот сертификат в таблицу conformity_certs.

insert into crispy_selery.conformity_certs (product_id, cert)
values
    (
    (Select id from crispy_selery.products where name='матча'),
    '{
        "product_name": "чай матча",
        "date": "23.07.2023",
        "signed": [
            "Морковкин А.А.",
            "Зеленая Е.А."
        ],
        "weight": 200,
        "country": "Вьетнам"   
    }'
    )


2.
У сертификата качества на сельдерей такая структура:

{
    "product_name": "сельдерей",
    "certifications": [
        {
            "date": "01.06.2023",
            "number": 123,
            "result": "very good"
        },
        {
            "date": "01.07.2023",
            "number": 456,
            "result": "good"
        },
        {
            "date": "01.08.2023",
            "number": 789,
            "result": "very good"
        }
    ]
} 
При этом точное количество объектов в массиве certifications неизвестно.
Найдите сертификат качества на продукт «сельдерей» и выведите результат его последней сертификации (значение по ключу result) в формате text.Чтобы найти последний элемент json-массива, примените отрицательную индексацию.

1)
WITH a AS 
(select cert::JSONB 
from crispy_selery.conformity_certs 
where product_id = (Select id from crispy_selery.products where name='сельдерей'))
SELECT cert::jsonb -> 'certifications' -> -1 -> 'result'
FROM a;

2)
SELECT cert #>> '{certifications, -1, result}'
FROM crispy_selery.conformity_certs
WHERE product_id = (Select id from crispy_selery.products where name='сельдерей') 




3.
Это образец сертификата качества на миндальное молоко:

{
    "cert_date": "01.09.2023",
    "cert_number": 12345,
    "product_name": "миндальное молоко",
    "signed": [
        "Иванов И.И.",
        "Петров П.П."
    ]
} 
Найдите фактический сертификат в таблице conformity_certs и посчитайте, сколько человек его подписали — signed.

with a as
(select
cert
from crispy_selery.conformity_certs 
where product_id = (Select id from crispy_selery.products where name='миндальное молоко')) 
select JSONB_ARRAY_LENGTH(cert::jsonb -> 'signed')
from a


4.
Кажется, в сертификат на миндальное молоко закралась ошибка. Его номер — не 12345, а 123456. Замените значение в таблице conformity_certs.

UPDATE crispy_selery.conformity_certs
SET cert = jsonb_set(cert::JSONB, '{cert_number}', '123456')
where product_id = (Select id from crispy_selery.products where name='миндальное молоко')


5.
Вот сертификат качества на сельдерей:

{
    "product_name": "сельдерей",
    "certifications": [
        {
            "date": "01.06.2023",
            "number": 123,
            "result": "very good"
        },
        {
            "date": "01.07.2023",
            "number": 456,
            "result": "good"
        },
        {
            "date": "01.08.2023",
            "number": 789,
            "result": "very good"
        }
    ]
} 
Обновите значение в таблице conformity_certs. Для этого измените номер первой сертификации в массиве certifications. Правильное значение номера — 101.

UPDATE crispy_selery.conformity_certs
SET cert = jsonb_set(cert::JSONB, '{certifications, 0, number}', '101')
where product_id = (Select id from crispy_selery.products where name='сельдерей')



6.
По сертификату на сельдерей пришло дополнение. Нужно добавить к нему следующую пару ключ-значение:

"country": "Россия" 
Обновите значение в таблице conformity_certs.

UPDATE crispy_selery.conformity_certs
SET cert = cert::JSONB || '{"country": "Россия" }'
where product_id = (Select id from crispy_selery.products where name='сельдерей')



7.
По новым стандартам фамилии подписантов больше не указываются в сертификате качества. Исправьте сертификат на миндальное молоко и уберите из него ключ signed и его значение.

UPDATE crispy_selery.conformity_certs
SET cert = cert::JSONB - 'signed'
where product_id = (Select id from crispy_selery.products where name='миндальное молоко')
