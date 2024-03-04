Employee 表:
+----+-------+--------+--------------+
| id | name  | salary | departmentId |
+----+-------+--------+--------------+
| 1  | Joe   | 70000  | 1            |
| 2  | Jim   | 90000  | 1            |
| 3  | Henry | 80000  | 2            |
| 4  | Sam   | 60000  | 2            |
| 5  | Max   | 90000  | 1            |
+----+-------+--------+--------------+
在 SQL 中，id是此表的主键。
departmentId 是 Department 表中 id 的外键（在 Pandas 中称为 join key）。
此表的每一行都表示员工的 id、姓名和工资。它还包含他们所在部门的 id。


Department 表:
+----+-------+
| id | name  |
+----+-------+
| 1  | IT    |
| 2  | Sales |
+----+-------+
在 SQL 中，id 是此表的主键列。
此表的每一行都表示一个部门的 id 及其名称。



查找出每个部门中薪资最高的员工。
+------------+----------+--------+
| Department | Employee | Salary |
+------------+----------+--------+
| IT         | Jim      | 90000  |
| Sales      | Henry    | 80000  |
| IT         | Max      | 90000  |
+------------+----------+--------+
解释：Max 和 Jim 在 IT 部门的工资都是最高的，Henry 在销售部的工资最高。


窗口函数
select aa.name as Employee, aa.salary, b.name as Department 
from
(SELECT
  a.salary,a.departmentId,a.name,
  DENSE_RANK() OVER (
  partition by a.departmentId
    ORDER BY
      a.salary DESC
  ) AS 'rank'
FROM
  Employee a ) aa inner join Department b on aa.departmentId=b.id where aa.rank=1 




select
    Department.name as Department,
    salary_rank.name as Employee,
    salary_rank.salary
from (
    select
        name,
        salary,
        departmentId,
        -- 按照部门分组之后再排序，大小相同的数据序号相同。
        dense_rank() over(partition by departmentId order by salary desc) as srank
    from Employee
) as salary_rank
join Department
on salary_rank.departmentId = Department.id
where salary_rank.srank = 1;


