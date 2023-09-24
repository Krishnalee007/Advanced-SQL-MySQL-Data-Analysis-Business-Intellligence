use mavenfuzzyfactory;
select
	website_sessions.device_type,
    count(distinct website_sessions.website_session_id) as sessions,
    count(distinct orders.order_id) as orders,
	count(distinct orders.order_id)/count(distinct website_sessions.website_session_id) as Con_rate
from website_sessions 
	left join orders
		on website_sessions.website_session_id=orders.website_session_id
where website_sessions.created_at < '2012-05-11'
	and website_sessions.utm_source='gsearch' and website_sessions.utm_campaign='nonbrand'
group by 1