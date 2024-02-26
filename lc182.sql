-- 
自连接
select distinct
    p1.email
from Person as p1
    join Person as p2
    on (p1.id != p2.id
        and p1.email = p2.email);


select
    email,
    count(email) as num
from Person
group by email
having count(email) > 1;

select
    email,
    count(email) as num
from Person
group by email
having num > 1;