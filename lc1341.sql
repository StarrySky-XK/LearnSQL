请你编写一个解决方案：
    查找评论电影数量最多的用户名。如果出现平局，返回字典序较小的用户名。
    查找在 February 2020 平均评分最高 的电影名称。如果出现平局，返回字典序较小的电影名称。
字典序 ，即按字母在字典中出现顺序对字符串排序，字典序较小则意味着排序靠前。


Movies        
int            varchar
+-------------+--------------+
| movie_id    |  title       |
+-------------+--------------+
| 1           | Avengers     |
| 2           | Frozen 2     |
| 3           | Joker        |
+-------------+--------------+
movie_id 是这个表的主键(具有唯一值的列)。
title 是电影的名字。



Users
int           varchar
+-------------+--------------+
| user_id     |  name        |
+-------------+--------------+
| 1           | Daniel       |
| 2           | Monica       |
| 3           | Maria        |
| 4           | James        |
+-------------+--------------+
user_id 是表的主键(具有唯一值的列)。



MovieRating
int           int            int             date
+-------------+--------------+--------------+-------------+
| movie_id    | user_id      | rating       | created_at  |
+-------------+--------------+--------------+-------------+
| 1           | 1            | 3            | 2020-01-12  |
| 1           | 2            | 4            | 2020-02-11  |
| 1           | 3            | 2            | 2020-02-12  |
| 1           | 4            | 1            | 2020-01-01  |
| 2           | 1            | 5            | 2020-02-17  | 
| 2           | 2            | 2            | 2020-02-01  | 
| 2           | 3            | 2            | 2020-03-01  |
| 3           | 1            | 3            | 2020-02-22  | 
| 3           | 2            | 4            | 2020-02-25  | 
+-------------+--------------+--------------+-------------+
(movie_id, user_id) 是这个表的主键(具有唯一值的列的组合)。
这个表包含用户在其评论中对电影的评分 rating 。
created_at 是用户的点评日期。 



输出
Result 表：
+--------------+
| results      |
+--------------+
| Daniel       |
| Frozen 2     |
+--------------+
找出评论电影数量最多的用户名，将用户表与电影表内连接，条件为用户id相同。
统计每个用户id的出现次数，找出次数最多的用户id，再根据这个选择用户姓名。



(
    select
        Users.name as results  # 选中用户名字
    from Users
    join MovieRating
    on Users.user_id = MovieRating.user_id
    group by Users.user_id
    # 按照每个id出现次数降序排序，按照姓名升序排列。
    order by count(MovieRating.user_id) desc, Users.name asc
    # 取第一个值就是想要的名字
    limit 1
)
union all
(
    select
        Movies.title as results # 选中电影名字
    from Movies
    join (
        select
            *
        from MovieRating
        where created_at >= '2020-02-01'
            and created_at <= '2020-02-29'
        # 这里对电影评价日期进行筛选
    ) as Moviesscores
    on Movies.movie_id = Moviesscores.movie_id
    group by Moviesscores.movie_id
    order by avg(Moviesscores.rating) desc, Movies.title asc
    limit 1
)






















