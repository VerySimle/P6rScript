## Description

Your task is simple, given the data you must calculate on each day how many hours have been clocked up for each department.
Tables and relationship below:
Resultant table:


    day (date) [order by]
    department_name (name of department) [order by]
    total_hours (total hours for the day)


## Screenshots

![App Screenshot](http://i.imgur.com/kBkwsbi.png)


## My solutions

```SQL
SELECT date(tt.login) AS day, dd.name AS department_name, date_part('hour', SUM(tt.logout - tt.login)) AS total_hours FROM department AS dd
JOIN timesheet AS tt on tt.department_id = dd.id
GROUP BY tt.department_id, department_name, day
ORDER BY day, department_name
```