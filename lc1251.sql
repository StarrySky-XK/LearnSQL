Prices table:
| product_id | start_date | end_date   | price |
| ---------- | ---------- | ---------- | ----- |
| 1          | 2019-02-17 | 2019-02-28 | 5     |
| 1          | 2019-03-01 | 2019-03-22 | 20    |
| 2          | 2019-02-01 | 2019-02-20 | 15    |
| 2          | 2019-02-21 | 2019-03-31 | 30    |
| 3          | 2019-02-21 | 2019-03-31 | 30    |
(product_id，start_date，end_date) 是 prices 表的主键（具有唯一值的列的组合）。
prices 表的每一行表示的是某个产品在一段时期内的价格。
每个产品的对应时间段是不会重叠的，这也意味着同一个产品的价格时段不会出现交叉。

UnitsSold table:
| product_id | purchase_date | units |
| ---------- | ------------- | ----- |
| 1          | 2019-02-25    | 100   |
| 1          | 2019-03-01    | 15    |
| 2          | 2019-02-10    | 200   |
| 2          | 2019-03-22    | 30    |

该表可能包含重复数据。
该表的每一行表示的是每种产品的出售日期，单位和产品 id。


编写解决方案以查找每种产品的平均售价。average_price 应该 四舍五入到小数点后两位。
| product_id | average_price |
| ---------- | ------------- |
| 1          | 6.96          |
| 2          | 16.96         |
| 3          | 0             |
平均售价 = 产品总价 / 销售的产品数量。
产品 1 的平均售价 = ((100 * 5)+(15 * 20) )/ 115 = 6.96
产品 2 的平均售价 = ((200 * 15)+(30 * 30) )/ 230 = 16.96


Prices表与UnitsSold表关联，条件id相等,日期范围正确。
判断出售日期处于哪个范围内，然后与该范围对应的价格相乘。


select
    sale.product_id,
    if(cast(sum(sum_price) / sum(units) as DECIMAL(4, 2)) is not null, cast(sum(sum_price) / sum(units) as DECIMAL(4, 2)), 0) as average_price
from (
    select
        Prices.product_id,
        UnitsSold.units,
        cast(prices.price as FLOAT) * UnitsSold.units as sum_price
    from Prices
    left join UnitsSold
    on Prices.product_id = UnitsSold.product_id
        and UnitsSold.purchase_date between prices.start_date and prices.end_date
) as sale
group by sale.product_id
