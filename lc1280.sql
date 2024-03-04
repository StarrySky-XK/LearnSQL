学生表: Students
在 SQL 中，主键为 student_id（学生ID）。
该表内的每一行都记录有学校一名学生的信息。
Students table:
+------------+--------------+
| student_id | student_name |
+------------+--------------+
| 1          | Alice        |
| 2          | Bob          |
| 13         | John         |
| 6          | Alex         |
+------------+--------------+

科目表: Subjects
在 SQL 中，主键为 subject_name（科目名称）。
每一行记录学校的一门科目名称。
Subjects table:
+--------------+
| subject_name |
+--------------+
| Math         |
| Physics      |
| Programming  |
+--------------+

考试表: Examinations
这个表可能包含重复数据（换句话说，在 SQL 中，这个表没有主键）。
学生表里的一个学生修读科目表里的每一门科目。
这张考试表的每一行记录就表示学生表里的某个学生参加了一次科目表里某门科目的测试。
Examinations table:
+------------+--------------+
| student_id | subject_name |
+------------+--------------+
| 1          | Math         |
| 1          | Physics      |
| 1          | Programming  |
| 2          | Programming  |
| 1          | Physics      |
| 1          | Math         |
| 13         | Math         |
| 13         | Programming  |
| 13         | Physics      |
| 2          | Math         |
| 1          | Math         |
+------------+--------------+

查询出每个学生参加每一门科目测试的次数，结果按 student_id 和 subject_name 排序。
查询结构格式如下所示。

输出：
+------------+--------------+--------------+----------------+
| student_id | student_name | subject_name | attended_exams |
+------------+--------------+--------------+----------------+
| 1          | Alice        | Math         | 3              |
| 1          | Alice        | Physics      | 2              |
| 1          | Alice        | Programming  | 1              |
| 2          | Bob          | Math         | 1              |
| 2          | Bob          | Physics      | 0              |
| 2          | Bob          | Programming  | 1              |
| 6          | Alex         | Math         | 0              |
| 6          | Alex         | Physics      | 0              |
| 6          | Alex         | Programming  | 0              |
| 13         | John         | Math         | 1              |
| 13         | John         | Physics      | 1              |
| 13         | John         | Programming  | 1              |
+------------+--------------+--------------+----------------+
解释：
结果表需包含所有学生和所有科目（即便测试次数为0）：
Alice 参加了 3 次数学测试, 2 次物理测试，以及 1 次编程测试；
Bob 参加了 1 次数学测试, 1 次编程测试，没有参加物理测试；
Alex 啥测试都没参加；
John  参加了数学、物理、编程测试各 1 次。





+------------+--------------+--------------+
| student_id | student_name | subject_name |
+------------+--------------+--------------+
| 1          | Alice        | Math         |
| 1          | Alice        | Physics      |
| 1          | Alice        | Programming  |
| 6          | Alex         | Programming  |
+------------+--------------+--------------+



公司无法使用笛卡尔积，但是应该不会出现科目表类似的表，一般都是有主键的。
科目表包含所有科目，学生表包含所有学生。
学生表与科目表关联。得到学生编号和姓名和科目名称。





# Write your MySQL query statement below
select 
    s.student_id,
    s.student_name,
    sub.subject_name,
    ifnull(grouped.attended_exams,0) as attended_exams
from students s 
cross join subjects sub
left join (
    select 
        student_id,
        subject_name,
        count(*) as attended_exams 
    from examinations 
    group by student_id, subject_name
) grouped
on s.student_id=grouped.student_id and sub.subject_name=grouped.subject_name
order by s.student_id,sub.subject_name

作者：一切顺利
链接：https://leetcode.cn/problems/students-and-examinations/solutions/2641177/nan-ti-duo-biao-lian-jie-shi-yong-liao-j-7xix/
来源：力扣（LeetCode）
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。









但是将学生表和科目表连接

select
    *
from Students
cross join Subjects


select
    student_id,
    subject_name