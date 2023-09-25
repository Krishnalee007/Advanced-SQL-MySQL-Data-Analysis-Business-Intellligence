
-- Analysing product launches
use mavenfuzzyfactory; 
select
	year(website_sessions.created_at) as yr,
    month(website_sessions.created_at) as mon,
    count(distinct orders.order_id) as orders,
    count(distinct orders.order_id)/count(distinct website_sessions.website_session_id) as conv_rate,
    sum(price_usd)/count(distinct website_sessions.website_session_id) as rev_per_session,
    count(case when primary_product_id=1 then orders.order_id else null end) as product_one_orders,
    count(case when primary_product_id=2 then orders.order_id else null end) as product_two_orders
from website_sessions
left join orders
	on website_sessions.website_session_id=orders.website_session_id
where website_sessions.created_at<'2013-04-05'
and website_sessions.created_at>'2012-04-01'
group by 1,2
