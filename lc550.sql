Activity table:
+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| player_id    | int     |
| device_id    | int     |
| event_date   | date    |
| games_played | int     |
+--------------+---------+


Activity_first                                                          Activity
+-----------+-----------+------------+--------------+                   +-----------+-----------+------------+--------------+
| player_id | device_id | event_date | games_played |                   | player_id | device_id | event_date | games_played |
+-----------+-----------+------------+--------------+                   +-----------+-----------+------------+--------------+
| 1         | 2         | 2016-03-01 | 5            |                   | 1         | 2         | 2016-03-02 | 6            |
| 2         | 3         | 2017-06-25 | 1            |
| 3         | 1         | 2016-03-02 | 0            |






+-----------+-----------+------------+--------------+
| player_id | device_id | event_date | games_played |
+-----------+-----------+------------+--------------+
| 1         | 2         | 2016-03-01 | 5            |
| 1         | 2         | 2016-03-02 | 6            |
| 2         | 3         | 2017-06-25 | 1            |
| 3         | 1         | 2016-03-02 | 0            |
| 3         | 4         | 2018-07-03 | 5            |
+-----------+-----------+------------+--------------+
（player_id，event_date）是此表的主键（具有唯一值的列的组合）。
这张表显示了某些游戏的玩家的活动情况。
每一行是一个玩家的记录，他在某一天使用某个设备注销之前登录并玩了很多游戏（可能是 0）。


编写解决方案，报告在首次登录的第二天再次登录的玩家的 比率，四舍五入到小数点后两位。
换句话说，你需要计算从首次登录日期开始至少连续两天登录的玩家的数量，然后除以玩家总数。
+-----------+
| fraction  |
+-----------+
| 0.33      |
+-----------+
解释：
只有 ID 为 1 的玩家在第一天登录后才重新登录，所以答案是 1/3 = 0.33

首先筛选游戏次数不为0的记录，然后按照客户id分组，统计每个分组内日期之差的最小值，如果最小值为1则符合条件，


先过滤出每个用户的首次登陆日期，然后左关联，筛选次日存在的记录的比例
select round(avg(a.event_date is not null), 2) fraction
from (
    select 
        player_id,
        min(event_date) as login
    from activity
    group by player_id
) p 
left join activity
on p.player_id=activity.player_id and datediff(activity.event_date, p.login)=1


# 去重后客户数据表左连接原表，id相等，日期条件满足。
# 似乎不用考虑游戏次数是否为0,而且连续登录的设备id是一样的
# 右表的登录日期不为空说明该用户登录连续登录了，使用avg函数求均值即为比例
select
    # *
    round(avg(Activity.event_date is not null), 2) as fraction
    # avg(Activity.event_date is not null)
from(
    select
        player_id,
        # 求出首次登录日期
        min(event_date) as login_date 
    from Activity
    # 按照player_id分组求出每位客户首次登录日期
    group by player_id
) as Activity_first
# 分组之后的登录表就是去重后客户总数，左连接活动表求出连续登录客户。
# 左连接：保留的是去重后的全部客户
left join Activity
on (Activity_first.player_id = Activity.player_id 
    and datediff(Activity.event_date, Activity_first.login_date) = 1)



