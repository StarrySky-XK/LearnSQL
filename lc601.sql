Stadium
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| visit_date    | date    |
| people        | int     |
+---------------+---------+

visit_date 是该表中具有唯一值的列。
每日人流量信息被记录在这三列信息中：序号 (id)、日期 (visit_date)、 人流量 (people)
每天只有一行记录，日期随着 id 的增加而增加


编写解决方案找出每行的人数大于或等于 100 且 id 连续的三行或更多行记录。
返回按 visit_date 升序排列 的结果表。
查询结果格式如下所示。

输入：
Stadium 表:
+------+------------+-----------+
| id   | visit_date | people    |
+------+------------+-----------+
| 1    | 2017-01-01 | 10        |
| 2    | 2017-01-02 | 109       |
| 3    | 2017-01-03 | 150       |
| 4    | 2017-01-04 | 99        |
| 5    | 2017-01-05 | 145       |
| 6    | 2017-01-06 | 1455      |
| 7    | 2017-01-07 | 199       |
| 8    | 2017-01-09 | 188       |
+------+------------+-----------+
输出：
+------+------------+-----------+
| id   | visit_date | people    |
+------+------------+-----------+
| 5    | 2017-01-05 | 145       |
| 6    | 2017-01-06 | 1455      |
| 7    | 2017-01-07 | 199       |
| 8    | 2017-01-09 | 188       |
+------+------------+-----------+

解释：
id 为 5、6、7、8 的四行 id 连续，并且每行都有 >= 100 的人数记录。
请注意，即使第 7 行和第 8 行的 visit_date 不是连续的，输出也应当包含第 8 行，因为我们只需要考虑 id 连续的记录。
不输出 id 为 2 和 3 的行，因为至少需要三条 id 连续的记录。





with newsort as(
    select
        *,
        (id - row_number() over(order by id asc)) as groupid
    from Stadium
    where people >= 100
)

select
    id,
    visit_date,
    people
from newsort
where groupid in(
    select
        groupid
    from newsort
    group by groupid
    having count(groupid) >= 3
);















# 很好的解决思路
https://leetcode.cn/problems/human-traffic-of-stadium/solutions/701681/tu-jie-lian-xu-ri-qi-ji-nan-dian-fen-xi-xnj58



with创建一个公共表表达式，得到中间结果。

with t1 as(
    select 
        *,
        -- todo row_number函数的用途
        -- 按照id升序排列，然后给每行分配一个序号。原id与这个序号相减。
        -- 如果大于100的人数记录是连续的，那么相减之后的结果是相同的。
        id - row_number() over(order by id) as rk
    from stadium
    where people >= 100
)

select 
    id,
    visit_date,
    people
from t1
where rk in(
    select 
        rk
    from t1
    group by rk
    having count(rk) >= 3
);









with ss as (
    select 
        *,
        id - row_number() over( order by id ) as aa
    from Stadium
    where people >= 100
)

select 
    id,
    visit_date,
    people
from ss
where aa in (
    select 
        aa
    from(
        select 
            aa,
            count(aa) cs
        from ss
        group by aa
    ) t
    where cs >= 3
)
order by id;








with ss as (
    select 
        *,
        id - row_number() over( order by id ) as aa
    from Stadium
    where people >= 100
)

select 
    id,
    visit_date,
    people
from (
    select 
        *,
        count(aa) over(partition by aa) cs
    from ss
) a
where cs >= 3
order by id;









select 
    id,
    visit_date,
    people
from (
    select 
        *,
        count(aa) over(partition by aa) cs
    from(
        select 
            *,
            id - row_number() over( order by id ) as aa
        from Stadium
        where people >= 100
    ) t
) t
where cs >= 3
order by id;
你十分精通sql，请你向我解释这段代码，谢谢。
