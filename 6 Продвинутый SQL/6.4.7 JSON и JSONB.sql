Тип данных JSON и JSONB
Начнём урок с примера. Агрегатор Taxi Online решил хранить анкеты водителей, которые они заполняют при приёме на работу. Но есть проблема — у таксопарков разные варианты анкет. Например, анкета таксопарка «Довезём с ветерком» выглядит так:
ФИО	Колесов Игорь Витальевич	
Дата рождения	12.06.1985	
Дети	сын	Колесов Артем
дочь	Колесова Инна
А у таксопарка «Гудок» такая анкета:
ФИО	Рулевой Александр Иванович	
Дата рождения	25.05.1982	
Образование	год поступления	1992
год окончания	1997
название	Нижнекамышовый машиностроительный техникум
Возникает вопрос — как их правильно хранить. Теоретически можно написать парсер, который будет динамически создавать таблицы исходя из структуры поступающих анкет. Однако в этом нет особого смысла. Основная информация о водителях уже хранится в таблице drivers, остальные же анкетные данные могут вовсе никогда не понадобиться. 
Для таких ситуаций пригодится тип данных json. Этот формат пришёл из языка JavaScript, где изначально создавался для обмена данными. В PostgreSQL он выделен в отдельный тип данных, а также у него есть специальные операторы и функции, которые облегчают работу. 
json широко используют для хранения неструктурированной информации, которая поступает из различных источников: каталогов продукции, анкет, отчётов и так далее.
Для начала посмотрим, как выглядит этот формат.
json — текстовый формат. Он может содержать две сущности в разных комбинациях:
Объект json.
Массив.
Объект json — это набор пар ключ-значение. Эти пары заключают в фигурные скобки и перечисляют через запятую. Например, вот так выглядит один json-объект с данными о сотруднике:

{
    "имя": "Иван",
    "возраст": 25,
    "фамилия": "Иванов"
} 
Это классический вариант формата json, в котором в качестве ключей могут выступать только строки. Именно такой формат применяется в PostgreSQL. В других языках программирования вы могли встречать другие стандарты, например json5, в котором ключом может быть число. В этом случае ключ в кавычки не заключается.
Значениями в объекте json могут быть:
строки,
числа,
булевы значения,
массивы,
другие объекты json.
Объекты json можно вкладывать друг в друга, например:

{
    "имя": "Иван",
    "возраст": 25,
    "фамилия": "Иванов",
    "образование": {
        "год": 1995,
        "название": "экономика и право"
    }
} 
В некоторых других языках программирования можно ставить лишние запятые после последнего элемента массива или после последней пары ключ-значение в json-объекте. В SQL это вызовет ошибку.
Массив json — практически то же самое, что и обычный массив. Элементами json-массива могут быть те же типы данных, которые встречаются в значениях json-объекта. Массив заключают в квадратные скобки:

["Иванов", "Петров", "Сидоров"] 
Так выглядит массив со списком сотрудников:

[
    {
        "имя": "Иван",
        "возраст": 25,
        "фамилия": "Иванов"
    },
    {
        "имя": "Пётр",
        "возраст": 40,
        "фамилия": "Петров"
    },
    {
        "имя": "Сидор",
        "возраст": 33,
        "фамилия": "Сидоров"
    }
] 
Также json-массив может быть вложен в объект:

{
    "имя": "Иван",
    "дети": [
        {
            "имя": "Алёна"
        },
        {
            "имя": "Макар"
        }
    ],
    "возраст": 25,
    "фамилия": "Иванов"
} 
Такая гибкость позволяет хранить в json-формате самые разнообразные по структуре данные.
Выбираем: json или jsonb
В PostgreSQL помимо json есть свой уникальный тип данных jsonb, или бинарный json. Он выглядит точно так же, как обычный json, но отличается тем, что хранит данные в двоичном формате. Отсюда его особенности:
json	jsonb
Сохраняет точную копию введённого текста.	Введённый текст сохраняется в разобранном двоичном виде.
Сохраняет незначимые пробелы между элементами.	Удаляет незначимые пробелы между элементами.
Сохраняет повторяющиеся ключи — при обработке будет выдаваться только последний.	Если есть повторяющиеся ключи, сохраняет только последний.
Сохраняет порядок ключей.	Не сохраняет порядок ключей.
Данные вводятся быстрее.	Данные вводятся медленнее из-за необходимости двоичного разбора.
Данные обрабатываются медленнее.	Данные обрабатываются быстрее, потому что не нужен многократный разбор текста.
Не поддерживает индексацию.	Поддерживает индексацию.
Не поддерживает операторы конкатенации, вхождения, присутствия и удаления.	Поддерживает операторы конкатенации, вхождения, присутствия и удаления.
Не поддерживает встроенные функции для замены значения ключа.	Можно заменить значение ключа с помощью встроенной функции.
С точки зрения производительности у jsonb больше преимуществ. Поэтому в большинстве случаев jsonb — более удачный формат для хранения данных, чем обычный json. 
В большинстве, но не во всех. Бывают ситуации, в которых, наоборот, предпочтительнее будет json. Например:
Если важно сохранить последовательность ключей. Например, если это данные какого-то документа, который потом заверяется электронной цифровой подписью (ЭЦП).
Если критически важно минимизировать время ввода и при этом время обработки не столь критично. Например, для хранения каких-то логов, к которым потом редко обращаются.
Объявляем поля таблицы в формате json и jsonb
Вы можете объявить поле таблицы как json или jsonb при создании новой или изменении существующей таблицы. 
Добавьте к таблице drivers два поля с анкетными данными водителей:
worksheet_jsonb — в формате jsonb,
worksheet_json — в формате json.
Это позволит по ходу изучения этих типов данных сравнивать, как поведут себя одни и те же данные, будучи записанными в разных форматах:

ALTER TABLE taxi.drivers ADD COLUMN worksheet_jsonb jsonb;
ALTER TABLE taxi.drivers ADD COLUMN worksheet_json json; 
Создаём json и jsonb
Теперь добавьте значения в таблицу drivers. Если нужно добавить строку в поле формата json или jsonb, можно вставить её в таблицу, а PostgreSQL самостоятельно конвертирует её в тот тип, который указан для поля. 
Однако, если вы работаете со значениями json/jsonb с помощью специальных встроенных операторов или функций, использовать просто строку недостаточно — необходимо явное приведение типов.
Например, нужно добавить сотрудника с такой анкетой:

{
    "name": "Колесов Игорь Витальевич",
    "birth_date": "12.06.1985",
    "children": [
        {
            "relationship": "сын",
            "name": "Колесов Артем"
        },
        {
            "relationship": "дочь",
            "name": "Колесова Инна"
        }
    ]
} 
Так выглядит код для добавления этой анкеты:

INSERT INTO taxi.drivers
    (driver_name, driver_license, depot_id, worksheet_jsonb, worksheet_json)
VALUES (
    'Колесов Игорь Витальевич', 7777123123, 1, 
    '{
       "name": "Колесов Игорь Витальевич",
       "birth_date": "12.06.1985",
       "children": [
           {
               "relationship": "сын",
               "name": "Колесов Артем"
           },
           {
               "relationship": "дочь",
               "name": "Колесова Инна"
           }
       ]
    }', -- вставьте значение в столбец с типом jsonb
    '{
       "name": "Колесов Игорь Витальевич",
       "birth_date": "12.06.1985",
       "children": [
           {
               "relationship": "сын",
               "name": "Колесов Артем"
           },
           {
               "relationship": "дочь",
               "name": "Колесова Инна"
           }
       ]
    }' -- вставьте значение в столбец с типом json
);  
А вот результат — содержимое поля worksheet_json:
Имя — Колесов Игорь Витальевич, дата рождения: 12.06.1985. Родственные связи: сын — Колесов Артем, дочь — Колесова Инна
Текст выглядит именно так, как его ввели. 
А вот содержимое поля worksheet_jsonb:
Имя — Колесов Игорь Витальевич. Затем родственные связи: сын — Колесов Артем, дочь — Колесова Инна. В конце — дата рождения: 12.06.1985
При записи в формате jsonb в результате перевода в двоичный вид элементы birth_date и children поменялись местами. Так получилось потому, что в формате jsonb порядок ключей не сохраняется.
Также есть специальные функции для создания данных типа json и jsonb. 
Например, функции JSON_BUILD_OBJECT и JSONB_BUILD_OBJECT. В качестве аргументов в эти функции передаются по очереди ключи и значения. 
Для создания массивов json/jsonb есть функции JSON_BUILD_ARRAY и JSONB_BUILD_ARRAY, которые принимают аргументы через запятую. В качестве аргументов можно передавать все те элементы, которые могут входить в массив: строки, числа, булевы значения, другие массивы или объекты json. С помощью этих функций можно создавать различные вложенные конструкции.
Разберём пример. Нужно создать json-объект, одним из значений которого будет json-массив children, состоящий из двух json-объектов: для сына и для дочери. Вот как это будет выглядеть:

SELECT json_build_object(
    'name', 'Колесов Игорь Витальевич', 
    'birth_date', '12.06.1985', 
    'children', json_build_array(
        json_build_object('relationship', 'сын', 'name', 'Колесов Артем'), 
        json_build_object('relationship', 'дочь', 'name', 'Колесова Инна'))
) 
Таким же образом можно получить jsonb:

SELECT jsonb_build_object(
    'name', 'Колесов Игорь Витальевич', 
    'birth_date', '12.06.1985', 
    'children', jsonb_build_array(
        jsonb_build_object('relationship', 'сын', 'name', 'Колесов Артем'), 
        jsonb_build_object('relationship', 'дочь', 'name', 'Колесова Инна'))
) 
Есть и другие способы создания json. Например, из строки с помощью функции ROW_TO_JSON или из массива с помощью ARRAY_TO_JSON. С этими способами вы можете познакомиться в соответствующем разделе документации.
Выберите корректную строку в формате json. Отметьте единственный верный вариант ответа.



{
    title: Война и мир,
    author: Толстой Л.Н.,
    published: 1985,
    characters: [
        {
            name: Наташа Ростова,
            dignity: графиня
        },
        {
            name: Пьер Безухов,
            dignity: граф
        },
        {
            name: Андрей Болконский,
            dignity: князь
        }
    ]
} 
Ключи и их текстовые значения заключают в кавычки.


[
    "title": "Война и мир",
    "author": "Толстой Л.Н.",
    "published": 1985,
    "characters": [
        {
            "name": "Наташа Ростова",
            "dignity": "графиня"
        },
        {
            "name": "Пьер Безухов",
            "dignity": "граф"
        },
        {
            "name": "Андрей Болконский",
            "dignity": "князь"
        }
    ]
] 
Не совсем — json -объект заключают в фигурные, а не квадратные скобки.

Тоже правильный ответ

{
    "title": "Война и мир",
    "author": "Толстой Л.Н.",
    "published": 1985,
    "characters": [
        {
            "name": "Наташа Ростова",
            "dignity": "графиня"
        },
        {
            "name": "Пьер Безухов",
            "dignity": "граф"
        },
        {
            "name": "Андрей Болконский",
            "dignity": "князь"
        }
    ]
} 
Это json-объект с вложенным json-массивом.

Неправильный ответ

{
    "title": "Война и мир",
    "author": "Толстой Л.Н.",
    "published": 1985,
    "characters": {
        {
            "name": "Наташа Ростова",
            "dignity": "графиня"
        },
        {
            "name": "Пьер Безухов",
            "dignity": "граф"
        },
        {
            "name": "Андрей Болконский",
            "dignity": "князь"
        }
    }
} 
Ключу characters соответствует массив объектов, который заключают в квадратные скобки.
Выберите все верные утверждения.


Значения jsonb вводятся быстрее.
При вводе значения jsonb оно преобразуется в двоичный формат, что занимает чуть больше времени.

Правильный ответ
Формат json сохраняет порядок ключей, а jsonb нет.
Действительно. Имейте это в виду, если предполагаете, что порядок ключей может иметь для вас значение.

Если в строке jsonb встречаются повторяющиеся ключи, сохраняется только первый.
Сохраняется только последний ключ.

Правильный ответ
Если в строке json встречаются повторяющиеся ключи, то при дальнейшей работе с этой строкой будет учитываться только последний.
Сохранятся оба ключа, но выдаваться при обработке будет только последний.

Правильный ответ
jsonb удаляет незначимые пробелы между элементами.
Это одно из отличий типа jsonb от json.
Выберите скрипт, который выполнится без ошибок. Отметьте единственный верный вариант ответа.



SELECT json_build_object("author", "Толстой Л.Н.", "title", "Война и мир") 
В функцию JSON_BUILD_OBJECT передают текстовые значения, то есть заключённые в одинарные кавычки.

Правильный ответ

SELECT json_build_object('author', 'Толстой Л.Н.', 'title', 'Война и мир') 
В функцию JSON_BUILD_OBJECT передают ключи и значения поочерёдно в текстовом формате.


SELECT json_build_object('{"author": "Толстой Л.Н.", "title": "Война и мир"}') 
В функцию JSON_BUILD_OBJECT передают набор текстовых значений, приводить их к формату ключ:значение не нужно.


SELECT json_build_object('{author, Толстой Л.Н., title, Война и мир}') 
В функцию JSON_BUILD_OBJECT значения передают набор текстовых значений поочередно и через запятую.
В базе данных есть таблица users_settings, в которой хранятся настройки пользователей. В ней два поля:
user_id — id пользователя в формате bigint,
settings — настройки в формате jsonb.
Нужно добавить в таблицу настройки для пользователя с id = 1947:

{
    "id": 1947,
    "org_name": "Берёзка",
    "post": "специалист",
    "device_type": 2
} 
Выберите все возможные варианты добавления настроек.


Тоже правильный ответ

INSERT INTO users_settings(user_id, settings)
VALUES (
    1947, 
    '{
         "id": 1947,
         "org_name": "Берёзка",
         "post": "специалист",
         "device_type": 2
     }'
) 
Вставить значение для столбца типа jsonb можно как обычную строку.

Неправильный ответ

INSERT INTO users_settings(user_id, settings)
VALUES (
    1947, 
    {
        "id": 1947,
        "org_name": "Берёзка",
        "post": "специалист",
        "device_type": 2
    }
) 
Значение для столбца типа jsonb нужно заключить в одинарные кавычки.

Неправильный ответ

INSERT INTO users_settings(user_id, settings)
VALUES (
    1947, 
    {
        "id": 1947,
        "org_name": "Берёзка",
        "post": "специалист",
        "device_type": 2
    }::jsonb
) 
Можно использовать явное приведение типов к формату jsonb, однако для этого само значение нужно заключить в одинарные кавычки.

Правильный ответ

INSERT INTO users_settings(user_id, settings)
VALUES (
    1947, 
    jsonb_build_object(
        'id', 1947, 'org_name', 'Берёзка','post', 'специалист',
        'device_type', 2
    )
) 
Чтобы сформировать значения типа jsonb, можно использовать функцию jsonb_build_object.