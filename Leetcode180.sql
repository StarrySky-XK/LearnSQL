题目要求从表logs中找出所有至少连续出现三次的数字。

输入：
Logs 表：
id 是该表的主键。
id 是一个自增列。
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





下面两个是解题思路中的辅助表格：
这个是按照id排序后给每条记录分配新的序号newid
+----+-----+--------+-----+-----+
| id | num | newid  |gid  |diff |
+----+-----+--------+-----+-----+
| 1  | 1   | 1      | 1   | 0   |
| 2  | 1   | 2      | 2   | 0   |
| 4  | 1   | 3      | 3   | 0   |
| 6  | 2   | 4      | 1   | 3   |
| 7  | 1   | 5      | 4   | 1   |
| 9  | 2   | 6      | 2   | 4   |
| 10 | 2   | 7      | 3   | 4   |
+----+-----+--------+-----+-----+

这个表格是按照num分组后，再给每条记录按照id排序后分配新的序号gid
+----+-----+--------+-----+-----+
| id | num | newid  |gid  |diff |
+----+-----+--------+-----+-----+
| 1  | 1   | 1      | 1   | 0   |
| 2  | 1   | 2      | 2   | 0   |
| 4  | 1   | 3      | 3   | 0   |
| 7  | 1   | 5      | 4   | 1   |
| 6  | 2   | 4      | 1   | 3   |
| 9  | 2   | 6      | 2   | 4   |
| 10 | 2   | 7      | 3   | 4   |
+----+-----+--------+-----+-----+


下面是解题思路：
原始表Logs中的id可能是不连续的。先对Logs表所有记录按照id升序排列，通过row_number函数给每一条记录分配一个新的序号。
新序号是newid，这个通过row_number() over(order by id)实现。

然后按照num分组，再对每个分组内的记录又按照id进行排序，并为每条记录分配新序号gid。 
这个通过row_number() over(partition by Num order by id)实现。

然后newid和gid相减，如果是连续出现的数字，那么相减之后的结果是一样的，即diff的值相同。

把newid当做真实位置(数字在第几个位置出现)，把gid当做数字第几次出现。
可以这样理解，假设数字连续出现了。那么按照num分组时，每个分组内每条记录的gid是按顺序排列的，
因此与newid的差值是固定的，也就是连续出现的数字对应的差值相同。
假设某数字num的newid是i，而且这是该数字第k次出现。那么差值是 i-k 
如果数字连续出现了，那么下一个num的newid是i+1，这是该数字第k+1次出现。
那么差值是(i+1)-(k+1) = i-k 




a - b
(a - b)


select
    num as ConsecutiveNums
from (
    select
        num
    from (
        select
            id,
            num,
            -- 按照id排序重新给每行增加一个序号，再按照num分组并在分组内按照id排序后给每行分配新序号，两者相减
            row_number() over(order by id) - row_number() over(partition by Num order by id) as sortdiff
            (      row_number() over(partition by id) - row_number() over(partition by num order by id)      ) as sortdiff
        from Logs
    ) as Logsdiff
    group by num, sortdiff
    HAVING COUNT(1) >= 3
) as Result;