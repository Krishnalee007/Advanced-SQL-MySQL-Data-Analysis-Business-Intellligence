-- cross channel BID optimization,
-- finding conversions rates grouping by device_type and utm source

use mavenfuzzyfactory;
select
	website_sessions.device_type,
    website_sessions.utm_source,
    count(website_sessions.website_session_id) as sessions,
    count(orders.order_id) as orders,
    count(orders.order_id)/count(website_sessions.website_session_id) as conv_rate
from website_sessions
left join orders
	on website_sessions.website_session_id=orders.website_session_id
where website_sessions.created_at>'2012-08-22'
and website_sessions.created_at<'2012-09-19'
and website_sessions.utm_campaign='nonbrand'
group by 1,2