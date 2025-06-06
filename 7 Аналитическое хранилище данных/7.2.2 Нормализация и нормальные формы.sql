Нормализация и нормальные формы
Реляционные СУБД используют реляционную модель данных. Модель данных — это концептуальное представление бизнес-требований, которое включает в себя схему структур таблиц и их связей. В качестве схемы используют диаграмму «сущность-связь», или ER-диаграмму (от англ. Entity–Relationship). Как следует из названия, она показывает, как связаны друг с другом разные сущности. Такую диаграмму вы уже строили в спринте по основам SQL.
Сейчас же повторим формы хранения данных в таблицах реляционной модели, или нормальные формы.
Что такое нормальная форма
Каждая нормальная форма — это состояние данных после того или иного этапа обработки, или нормализации. На каком этапе остановиться, инженеры решают, отталкиваясь от задачи. Обработка в данном случае подразумевает удаление избыточности и аномалий, приводящих к ошибкам в результатах. 
Всего существует девять нормальных форм: 
основные — с первой (1NF) по шестую (6NF);
дополнительные — нулевая нормальная форма (UNF), нормальная форма Бойса-Кодда (BCNF) и доменно-ключевая нормальная форма (DKNF).
Реляционные модели обычно делают в форме, близкой к третьей нормальной (3NF), потому что она лучше прочих подходит для хранения данных и построчной обработки. Остальные нормальные формы встречаются в OLTP-моделях реже, но хорошо применимы в OLAP-моделях. О последних мы расскажем в следующей теме.
Существует также понятие «вложенность нормальных форм». Оно подразумевает ослабление или усиление форм по отношению друг к другу. Например, первая нормальная форма является ослабленной по отношению ко второй нормальной форме и всем последующим. Таким образом, самая «слабая» форма — 1NF, а самая «сильная» — 6NF.
На схеме шесть прямоугольников, один находится внутри другого. Внешний прямоугольник — 1NF, а тот, что в самом центре — 6NF.
Знание механики перевода модели данных во все нормальные формы помогает при моделировании данных и построении сложных DWH. Кроме того, это одна из любимых тем работодателей для вопросов на собеседованиях на позицию инженера данных.