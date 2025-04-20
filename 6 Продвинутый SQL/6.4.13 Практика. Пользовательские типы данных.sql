1.
В таблицу с поставщиками vendors нужно добавить информацию о типе поставщика. 
Создайте для схемы сети «Хрустящий сельдерей» новый тип данных vendor_type, который может хранить только три возможных значения: производитель, дистрибьютор или импортер.
 Добавьте к таблице vendors поле vendor_type c новым типом.

CREATE TYPE crispy_selery.vendor_type AS ENUM ('производитель', 'дистрибьютор', 'импортер');
alter table crispy_selery.vendors add column vendor_type crispy_selery.vendor_type;

2.
В таблице shops нет информации про третий магазин. Его адрес: пер. Огуречный, 7.
Магазин предоставляет услуги: самовывоз и свежевыжатые соки.
Характеристики помещения:
площадь — 70.
номер этажа — 1.
кадастровый номер — 12:34:567890:12.
находится в собственности.
Добавьте данные об этом магазине в таблицу shops.

insert into crispy_selery.shops (address, properties, services)
values(
    'пер. Огуречный, 7',
    '(70,1,12:34:567890:12,True)',
    '{самовывоз, свежевыжатые соки}'
)

3.
Найдите площадь склада с id = 2.

select (properties).area
from crispy_selery.storehouses
where id=2


4.
Магазин с id = 2 раньше находился в аренде, а затем «Хрустящий сельдерей» выкупил это помещение. Исправьте признак собственности для этого магазина в таблице shops.

UPDATE crispy_selery.shops set properties.is_owned = true
where id =2

5.
У склада с id = 3 не заполнен кадастровый номер. Его кадастровый номер '00:77:567890:12'. Внесите эти данные в таблицу storehouses.

UPDATE crispy_selery.storehouses set properties.cadastral_num = '00:77:567890:12'
where id =3

