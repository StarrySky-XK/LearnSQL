Product table:
+------------+--------------+------------+
| product_id | product_name | unit_price |
+------------+--------------+------------+
| 1          | S8           | 1000       |
| 2          | G4           | 800        |
| 3          | iPhone       | 1400       |
+------------+--------------+------------+
product_id 是该表的主键（具有唯一值的列）。
该表的每一行显示每个产品的名称和价格。


Sales table:
+-----------+------------+----------+------------+----------+-------+
| seller_id | product_id | buyer_id | sale_date  | quantity | price |
+-----------+------------+----------+------------+----------+-------+
| 1         | 1          | 1        | 2019-01-21 | 2        | 2000  |
| 1         | 2          | 2        | 2019-02-17 | 1        | 800   |
| 2         | 2          | 3        | 2019-06-02 | 1        | 800   |
| 3         | 3          | 4        | 2019-05-13 | 2        | 2800  |
+-----------+------------+----------+------------+----------+-------+
这个表可能有重复的行。
product_id 是 Product 表的外键（reference 列）。
该表的每一行包含关于一个销售的一些信息。


编写解决方案，报告2019年春季才售出的产品。即仅在2019-01-01至2019-03-31（含）之间出售的商品。
+-------------+--------------+
| product_id  | product_name |
+-------------+--------------+
| 1           | S8           |
+-------------+--------------+
解释:
id 为 1 的产品仅在 2019 年春季销售。
id 为 2 的产品在 2019 年春季销售，但也在 2019 年春季之后销售。
id 为 3 的产品在 2019 年春季之后销售。
我们只返回 id 为 1 的产品，因为它是 2019 年春季才销售的产品。

原本写法
select
    Product.product_id,
    Product.product_name
from Product
join (
    select
        product_id,
        min(sale_date) as mindate,
        max(sale_date) as maxdate
    from Sales
    group by product_id
    having mindate >= '2019-01-01'
        and maxdate <= '2019-03-31'
) as Salesdate
on Product.product_id = Salesdate.product_id;


两表连接后再筛选，似乎数据量大些
select
    Product.product_id,
    Product.product_name
from Product
join Sales
on Product.product_id = Sales.product_id
group by Sales.product_id
having min(sale_date) >= '2019-01-01'
    and max(sale_date) <= '2019-03-31';
