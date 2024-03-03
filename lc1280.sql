Students table:
+------------+--------------+
| student_id | student_name |
+------------+--------------+
| 1          | Alice        |
| 2          | Bob          |
| 13         | John         |
| 6          | Alex         |
+------------+--------------+
在 SQL 中，主键为 student_id（学生ID）。
该表内的每一行都记录有学校一名学生的信息。

Subjects table:
+--------------+
| subject_name |
+--------------+
| Math         |
| Physics      |
| Programming  |
+--------------+
在 SQL 中，主键为 subject_name（科目名称）。
每一行记录学校的一门科目名称。

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
这个表可能包含重复数据（换句话说，在 SQL 中，这个表没有主键）。
学生表里的一个学生修读科目表里的每一门科目。
这张考试表的每一行记录就表示学生表里的某个学生参加了一次科目表里某门科目的测试。

查询出每个学生参加每一门科目测试的次数，结果按 student_id 和 subject_name 排序。

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



官方题解
select
    Students.student_id,
    Students.student_name,
    Subjects.subject_name,
    case when exam_num.numbers is not null then exam_num.numbers else 0 end as attended_exams
from Students
cross join Subjects
left join(
    select
        student_id,
        subject_name,
        count(1) as numbers
    from Examinations
    group by student_id, subject_name
) as exam_num
on Students.student_id = exam_num.student_id and Subjects.subject_name = exam_num.subject_name
order by Students.student_id, Subjects.subject_name;
