销售表 Sales：
+-------------+-------+
| Column Name | Type  |
+-------------+-------+
| sale_id     | int   |
| product_id  | int   |
| year        | int   |
| quantity    | int   |
| price       | int   |
+-------------+-------+
(sale_id, year) 是这张表的主键（具有唯一值的列的组合）。
product_id 是产品表的外键（reference 列）。
这张表的每一行都表示：编号 product_id 的产品在某一年的销售额。
请注意，价格是按每单位计的。


产品表 Product：
+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| product_id   | int     |
| product_name | varchar |
+--------------+---------+
product_id 是这张表的主键（具有唯一值的列）。
这张表的每一行都标识：每个产品的 id 和 产品名称。

编写解决方案，选出每个售出过的产品 第一年 销售的 产品 id、年份、数量 和 价格。
结果表中的条目可以按 任意顺序 排列。
结果格式如下例所示：

输入：
Sales 表：
+---------+------------+------+----------+-------+
| sale_id | product_id | year | quantity | price |
+---------+------------+------+----------+-------+ 
| 1       | 100        | 2008 | 10       | 5000  |
| 2       | 100        | 2009 | 12       | 5000  |
| 7       | 200        | 2011 | 15       | 9000  |
+---------+------------+------+----------+-------+
Product 表：
+------------+--------------+
| product_id | product_name |
+------------+--------------+
| 100        | Nokia        |
| 200        | Apple        |
| 300        | Samsung      |
+------------+--------------+
输出：
+------------+------------+----------+-------+
| product_id | first_year | quantity | price |
+------------+------------+----------+-------+ 
| 100        | 2008       | 10       | 5000  |
| 200        | 2011       | 15       | 9000  |
+------------+------------+----------+-------+


# 按照product_id分组，筛选出年份最小的记录
select
    product_id,
    year as first_year,
    quantity,
    price
from Sales
where (product_id, year) in(
    select
        product_id,
        min(year)
    from Sales
    group by product_id
);
