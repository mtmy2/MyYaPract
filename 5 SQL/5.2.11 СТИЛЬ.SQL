 SELECT name FROM drivers WHERE license_expired < '2024-01-01'; 
 

  SELECT 
     drivers.name,
     cars.model,
     cars.number 
 FROM drivers 
 JOIN cars_drivers ON drivers.id = cars_drivers.driver_id
 JOIN cars ON car[s.id](http://drivers.id) = cars_drivers.car_id
 WHERE license_expired < '2024-01-01';
 



  SELECT 
     d.name,
     c.model,
     d.number 
 FROM drivers AS d 
 JOIN cars_drivers AS cd ON [d.id](http://drivers.id) = cd.driver_id
 JOIN cars c ON c[.id](http://drivers.id) = cd.car_id
 WHERE license_expired < ‘2024-01-01’;
 

  /*Получить список пользователей и 
 их заказов*/
 SELECT u.user_id, u.username, o.order_id, o.order_date
 FROM users u
 JOIN orders o ON u.user_id = o.user_id
 WHERE u.status = 'active' -- отфильтровать активных пользователей
       AND o.order_date >= '2022-01-01' -- имеющих заказы после 2022-01-01
 ORDER BY u.username ASC; -- отсортировать по полю username
 