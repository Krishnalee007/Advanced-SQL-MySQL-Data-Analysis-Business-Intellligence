use mavenfuzzyfactory;

Select
	primary_product_id,
    count(distinct case when items_purchased=1 then order_id else null end) as order_with_1_item,
    count(distinct case when items_purchased=2 then order_id else null end) as order_with_2_item,
    count(order_id) as total_orders
from orders
where order_id between 31000 and 32000
group by 1