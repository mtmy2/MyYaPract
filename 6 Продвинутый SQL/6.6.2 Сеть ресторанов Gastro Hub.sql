Описание проекта. Сеть ресторанов Gastro Hub
Вы работаете в Gastro Hub — динамично развивающейся корпорации, которая управляет заведениями общественного питания в центре Москвы. Gastro Hub известна своими ресторанами, барами, пиццериями и кофейнями — у каждого заведения уникальная атмосфера и концепция. Компания постоянно исследует новые кулинарные тренды и заботится о том, чтобы гости каждого заведения наслаждались высоким качеством сервиса и незабываемым вкусом блюд.
Pasta Palace славится традиционной итальянской кухней в сердце города. Spirits & Spices, расположенный на знаменитой улице с барами, привлекает молодежь вкусными коктейлями и живой музыкой. Dough & Cheese — любимое место многих за непревзойдённые пиццы, а в Hops Heaven можно попробовать отборный кофе, любуясь на городской пейзаж.
Грамотный менеджмент требует слаженной работы и чёткого управления информацией. Ваша задача — создать базу данных, которая поможет GastroHub ещё лучше понимать свой бизнес и оптимизировать работу компании. 
Для этого необходимо работать с большим объёмом данных: информацией о заведениях, меню, менеджерах, среднем чеке и расположении заведений. Вы получите сырые, необработанные данные, по которым построите дополнительные таблицы, представления и материализованные представления, а также напишите несколько аналитических запросов. 
Сырые данные будут лежать в дампе в двух форматах. Чтобы загрузить текстовый файл с расширением .sql, используйте функцию DBeaver Restore (Восстановить). Если у вас возникнут проблемы с разворачиванием дампа, воспользуйтесь версией в архивном формате — файлом с расширением .zip. Это архив — распакуйте его, а затем используйте файл.
Файлы для скачивания ниже:
dump-gastrohub.sql
dump-gastrohub-text.zip
Описание данных для проекта Gastro Hub

Схемы
Схема	Описание схемы
raw_data	Хранит необработанные данные. В дампе будет информация по продажам и меню ресторанов.
Таблицы
raw_data.sales — необработанные данные о продажах
Поле	Описание поля	Тип поля
report_date	Дата	date
cafe_name	Название заведения	character varying
type	Тип заведения: бар, ресторан, кофейня, пиццерия	character varying
avg_check	Средний чек за день	numeric(6, 2)
manager	Ф. И. О менеджера заведения	character varying
manager_phone	Телефон менеджера заведения	character varying
raw_data.menu — необработанные данные о меню заведений
Поле	Описание поля	Тип поля
cafe_name	Название заведения	character varying
menu	Меню	jsonb
Ваш вклад в Gastro Hub поможет компании достигнуть новых высот и удивить гостей ещё более вкусной едой и безупречным сервисом.

