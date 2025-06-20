Индексы
Одна из главных задач любой СУБД — предоставить данные в ответ на запрос пользователя. Планировщик СУБД строит возможные варианты планов запроса и выбирает самый быстрый из доступных. Чтобы данные можно было получить быстро, их упорядочивают с помощью индексов. Вы уже сталкивались с ними в промежуточном проекте. В этом уроке разберём индексы более подробно, а в следующем вас ждёт практика. 
Что такое индексы
Индексы в СУБД — специальные объекты базы данных, предназначенные в основном для ускорения доступа к данным. Это вспомогательные структуры: любой индекс можно удалить и восстановить заново по информации в таблице.
Индексы в СУБД работают по принципу, аналогичному индексу в книге. Они позволяют быстро находить данные, не просматривая все строки таблицы. Индекс содержит ключи, каждый из которых связан с определённой строкой или набором строк.
Когда пользователь делает запрос на поиск данных, СУБД сначала проверяет индекс. Если требуемые данные есть в индексе, СУБД использует его для быстрого нахождения соответствующих строк в таблице. Это значительно ускоряет процесс поиска, особенно в больших базах данных.
Однако индексы также требуют места для хранения и могут замедлить операции вставки, обновления и удаления, так как при каждой такой операции индекс также должен быть обновлён. Поэтому важно правильно выбирать поля для индексации, учитывая частоту и тип запросов к данным.
Как создать индекс
Создать индекс можно следующим образом:

CREATE INDEX имя_индекса ON название_таблицы [USING тип_индекса](название_столбца); 
Команда [USING тип_индекса] здесь указана в квадратных скобках, потому что эта команда необязательна. Если не указать USING с конкретным типом индекса, то будет создан индекс B-tree по умолчанию. Об этом расскажем дальше в уроке.
Пример
Зададим индекс book_name_index:

CREATE INDEX book_name_index ON libraries(name); 
Чтобы проверить наличие индекса в БД, сделайте запрос в системное представление pg_indexes:

SELECT * FROM pg_catalog.pg_indexes WHERE tablename = 'libraries';

--schemaname|tablename|indexname      |tablespace|indexdef                                                           |
------------+---------+---------------+----------+-------------------------------------------------------------------+
--public    |libraries|book_name_index|          |CREATE INDEX book_name_index ON public.libraries USING btree (name)| 
Удалить индекс можно с помощью команды DROP:

DROP INDEX book_name_index; 
Типы индексов
В зависимости от данных СУБД PostgreSQL поддерживает разные типы индексов или, по-другому, методы доступа. Типы индекса определяют, каким образом будут структурированы и упорядочены индексируемые данные, чтобы доступ к ним был наиболее оптимальным. 
Существует несколько типов индексов: B-tree (B-дерево); Hash (хеш); GiST; SP-GiST; GIN; BRIN. Разберём каждый тип.
B-tree
Индекс B-tree строит сбалансированное дерево поиска по значениям: от любой точки этого дерева на одном уровне будет одинаковое расстояние до его корня.
Индекс содержит метаданные, на основе чего строится дерево. Корень дерева — набор значений 4, 32, 64. Дальше по уровням — наборы значений дерева
Если в запросе используются операторы <, <=, =, >=, >, то индекс B-tree может быть успешно построен и использован при запросе данных.
B-деревья применяются в следующих случаях:
Когда данные можно проверить на равенство, сравнить на условие больше или меньше, проверить вхождение в диапазон.
В запросах, которые используют операторы BETWEEN и IN.
В условиях IS NULL и IS NOT NULL по индексированным столбцам.
Оптимизатор может использовать эти индексы в запросах с операторами сравнения по шаблону LIKE.
B-деревья могут также применяться для получения данных, отсортированных по порядку. Это не всегда быстрее простого сканирования и сортировки, но иногда бывает полезно.
Hash
Тип индекса Hash использует хеш-функции для создания ключа. Хеш-функция принимает на вход объект любого типа и возвращает соответствующее ему числовое значение в типе INT: некоторое число, которое попадает в диапазон от -2147483648 до 2147483647, 4 байта — более четырёх миллиардов значений.
Данные со строковыми ключами, проходя через хеш-функцию, преобразовываются в числовые ключи и располагаются в таблице

Данные со строковыми ключами, проходя через хеш-функцию, преобразовываются в числовые ключи и располагаются в таблице
Создать хеш-индекс можно следующим образом:

CREATE INDEX book_name_hash_index ON libraries USING HASH(name); 
GiST
GiST (сокр. от Generalized Search Tree) — это тоже сбалансированное дерево поиска, но отличается от B-tree тем, что не привязано к семантике больше, меньше или равно. GiST чаще всего используется для следующих данных:
точки и другие геометрические объекты, поиск ближайших соседей выбранной точки;
интервалы и ограничения исключений;
полнотекстовый поиск.
Использование GiST предполагает наличие в запросе следующих операторов: <<, &<, &>, >>, <<|, &<|, |&>, |>>, @>, <@, ~=, &&.
Создать GiST можно следующим образом:

CREATE INDEX places_gist_index ON places USING GIST(location); 
Пример 
Решим задачу поиска ближайшего соседа, который возвращает 10 ближайших соседей точки с координатой (101,456):

SELECT * FROM places ORDER BY location <-> point '(101,456)' LIMIT 10; 
SP-GiST
SP-GiST (сокр. от Space Partitioning Generalized Search Trees) использует дерево поиска, но при этом размечает определённым образом само пространство. SP-GiST подходит для структур, в которых пространство рекурсивно разбивается на непересекающиеся области.
Объясним подробнее про рекурсивность деления: берётся некоторое пространство, которое по совокупности признаков делится на две части. Каждая из этих частей также делится, затем новые части делятся и так далее. Такие структуры ещё называют деревьями квадрантов.


Пример рекурсивной разметки пространства. Источник: https://habr.com/ru/companies/postgrespro/articles/337502/
Создать индекс SP-GiST можно следующим образом:

CREATE INDEX places_spgist_index ON places USING SPGIST(location); 
GIN
GIN (сокр. от Generalized Inverted Index) — инвертированный, или обратный, индекс, в котором могут содержаться значения с несколькими ключами, например массивы. Инвертированный индекс хранит отдельный элемент для значения каждого компонента и может эффективно работать в запросах, проверяющих наличие определённых значений компонентов. Аналогия метода — алфавитный указатель в конце книги, где для каждого термина приведён список страниц с упоминаниями этого термина.
GIN чаще всего используется для ускорения полнотекстового поиска, когда по слову или части слова нужно найти все документы, в которых они встречаются. При использовании индекса GIN строится дерево с соответствиями ключей и лексем — тому самому поисковому слову или части слова. Применять этот индекс можно с операторами: <@, @>, =, &&.
Создать индекс GIN можно следующим образом:

CREATE INDEX text_gin_index ON documents USING GIN(text_document); 
Задачу полнотекстового поиска может решать и индекс GiST, но эксперты утверждают, что GIN выигрывает в точности и скорости. Если данные изменяются нечасто, а искать надо быстро, выбирайте GIN.
BRIN
BRIN (сокр. от Block Range Indexes) — индекс интервала блоков. Такой индекс хранит обобщённые сведения о значениях, находящихся в последовательно расположенных блоках таблицы. Поэтому такие индексы наиболее эффективны для столбцов, значения в которых хорошо коррелируют с физическим порядком столбцов таблицы. 
BRIN эффективен при больших объёмах данных. Идея не в том, чтобы найти быстро нужные данные, а в том, чтобы быстро отсеять ненужные. Таким образом, последовательный поиск будет происходить быстрее. При этом индекс не будет занимать много полезного пространства на диске.
BRIN можно использовать с запросами, в которых присутствуют операторы: <, <=, =, >=, >.
Создать индекс BRIN можно следующим образом:

CREATE INDEX bus_routes_brin_index ON bus_routes USING brin(scheduled_time); 
Соотнесите утверждения и типы индексов в соответствии друг с другом:






Каждый тип индекса отличается друг от друга способом упорядочивания данных. Цена быстрого чтения — более долгие операции вставки, изменения и удаления данных, а также уменьшение места на диске. Все индексы можно создавать и удалять, используя одну и ту же конструкцию. О том, как индексы работают на практике, — в следующем уроке.

