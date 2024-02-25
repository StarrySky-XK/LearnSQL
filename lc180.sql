表：Logs
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| num         | varchar |
+-------------+---------+
在 SQL 中，id 是该表的主键。
id 是一个自增列。

找出所有至少连续出现三次的数字。

输入：
Logs 表：
+----+-----+
| id | num |
+----+-----+
| 1  | 1   |
| 2  | 1   |
| 3  | 1   |
| 4  | 2   |
| 5  | 1   |
| 6  | 2   |
| 7  | 2   |
+----+-----+
输出：
Result 表：
+-----------------+
| ConsecutiveNums |
+-----------------+
| 1               |
+-----------------+
解释：1 是唯一连续出现至少三次的数字。


https://leetcode.cn/problems/consecutive-numbers/solutions/21537/sql-server-jie-fa-by-neilsons

SELECT DISTINCT 
    Num 
FROM (
    SELECT 
        Num,
        COUNT(1) as SerialCount 
    FROM (
        SELECT Id,
        Num,
        row_number() over(order by id) - ROW_NUMBER() over(partition by Num order by Id) as SerialNumberSubGroup
        FROM ContinueNumber
    ) as Sub
    GROUP BY Num, SerialNumberSubGroup 
    HAVING COUNT(1) >= 3
) as Result