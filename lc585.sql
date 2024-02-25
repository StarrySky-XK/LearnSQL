Insurance 表：
+-------------+-------+
| Column Name | Type  |
+-------------+-------+
| pid         | int   |
| tiv_2015    | float |
| tiv_2016    | float |
| lat         | float |
| lon         | float |
+-------------+-------+
pid 是这张表的主键(具有唯一值的列)。表中的每一行都包含一条保险信息，其中：
pid 是投保人的投保编号。
tiv_2015 是该投保人在 2015 年的总投保金额，tiv_2016 是该投保人在 2016 年的总投保金额。
lat 是投保人所在城市的纬度。题目数据确保 lat 不为空。
lon 是投保人所在城市的经度。题目数据确保 lon 不为空。



编写解决方案报告 2016 年 (tiv_2016) 所有满足下述条件的投保人的投保金额之和：
他在 2015 年的投保额 (tiv_2015) 至少跟一个其他投保人在 2015 年的投保额相同。
他所在的城市必须与其他投保人都不同（也就是说 (lat, lon) 不能跟其他任何一个投保人完全相同）。
tiv_2016 四舍五入的 两位小数 。
查询结果格式如下例所示。
Insurance 表：
+-----+----------+----------+-----+-----+
| pid | tiv_2015 | tiv_2016 | lat | lon |
+-----+----------+----------+-----+-----+
| 1   | 10       | 5        | 10  | 10  |
| 2   | 20       | 20       | 20  | 20  |
| 3   | 10       | 30       | 20  | 20  |
| 4   | 10       | 40       | 40  | 40  |
+-----+----------+----------+-----+-----+

输出：
+----------+
| tiv_2016 |
+----------+
| 45.00    |
+----------+
解释：
表中的第一条记录和最后一条记录都满足两个条件。
tiv_2015 值为 10 与第三条和第四条记录相同，且其位置是唯一的。

第二条记录不符合任何一个条件。其 tiv_2015 与其他投保人不同，并且位置与第三条记录相同，这也导致了第三条记录不符合题目要求。
因此，结果是第一条记录和最后一条记录的 tiv_2016 之和，即 45 。


作者：uccs
链接：https://leetcode.cn/problems/investments-in-2016/solutions/1249506/liang-chong-fang-fa-xiang-xi-shuo-ming-j-9xzp/
来源：力扣（LeetCode）
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。

-- 窗口函数方式
select round(sum(tiv_2016), 2) as tiv_2016 
from (
    select
        tiv_2016,
        # 使用窗口函数统计数量
        count(*) over(partition by tiv_2015) as count_tiv_2015,
        count(*) over(partition by lat, lon) as count_lat_lon
    from insurance
) as temp 
where temp.count_lat_lon = 1 and temp.count_tiv_2015 > 1;

没有显式地拼接字段lat和lon
select
    round(sum(tiv_2016), 2) as tiv_2016
from Insurance
where
    tiv_2015 in(
        select
            tiv_2015
        from Insurance
        group by tiv_2015
        having count(*) > 1
    )
    and (lat, lon) in(
        select
            lat,
            lon
        from Insurance
        group by lat, lon
        having count(*) = 1
    );



# 官方题解，这样似乎不是很好
select
    round(sum(tiv_2016), 2) as tiv_2016
from Insurance
where
    tiv_2015 in(
        select
            tiv_2015
        from Insurance
        group by tiv_2015 # 按照tiv_2015分组，筛选分组后数量大于1的记录
        having count(*) > 1
    )
    and concat(lat,' ', lon) in(
        select
            # 将lat与lon拼接，中间添加额外符号。
            # 位置A：‘11’，‘10’。与位置‘1’，‘110’实际是不一样的。
            # 直接拼接会得到‘1110’，这样两个位置会当成一样的，有错误。
            concat(lat,'-', lon)
        from Insurance
        group by lat, lon # 按照位置分组，选择分组之后数量等于1的记录
        having count(*) = 1
    );







https://leetcode.cn/problems/investments-in-2016/solutions/20903/2016nian-de-tou-zi-by-leetcode/comments/2214466

select
    round(sum(res.tiv_2016),2) as tiv_2016
from (
    select
        a.pid,
        a.tiv_2016
    from Insurance a
    join Insurance b
    # 自连接，tiv_2015相同但是pid不相同，这里筛选出了相同投保额的不同人，但是位置还没确定
    on a.tiv_2015=b.tiv_2015 and a.pid!=b.pid
    # 
    where (a.lat,a.lon) not in(
        select
            lat,
            lon
        from Insurance
        # 这里理解为筛选出除自己之外其余人的位置，如果自己的位置出现在这些记录中，那么说明位置重复了，不满足要求。
        # 所以用not in来选出不重复的位置。
        where a.pid!=Insurance.pid
    )
    group by a.pid
    having count(*)>=1
) as res;
