-- Analyzing seasonality

use mavenfuzzyfactory;

-- Year and month wise
select
	year(website_sessions.created_at) as yr,
    month(website_sessions.created_at)as mon,
    count(website_sessions.website_session_id) as sessions,
    count(orders.order_id) as orders
from website_sessions
left join orders
	on website_sessions.website_session_id=orders.website_session_id
where website_sessions.created_at<'2013-01-01'
group by 1,2;

-- week wise

select
	-- year(website_sessions.created_at) as yr,
    -- week(website_sessions.created_at)as wk,
    min(date(website_sessions.created_at)) as start_week,
    count(website_sessions.website_session_id) as sessions,
    count(orders.order_id) as orders
from website_sessions
left join orders
	on website_sessions.website_session_id=orders.website_session_id
where website_sessions.created_at<'2013-01-01'
group by 
		year(website_sessions.created_at),
		week(website_sessions.created_at)