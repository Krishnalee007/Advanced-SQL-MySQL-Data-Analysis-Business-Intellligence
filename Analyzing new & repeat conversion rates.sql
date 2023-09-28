-- Anlayzing new and repeated sessions conversion rates 

use mavenfuzzyfactory;
select 
	is_repeat_session,
	count(distinct website_sessions.website_session_id) as sessions,
    count(distinct orders.order_id)/count(distinct website_sessions.website_session_id) as conv_rate,
    sum(price_usd)/count(distinct website_sessions.website_session_id) as rev_per_session
from website_sessions
left join orders
	on website_sessions.website_session_id=orders.website_session_id
where website_sessions.created_at<'2014-11-08'
and website_sessions.created_at>='2014-01-01'
group by 1