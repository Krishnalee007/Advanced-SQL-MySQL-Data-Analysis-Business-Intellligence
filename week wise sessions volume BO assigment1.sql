use mavenfuzzyfactory;
SELECT 
	 -- year(created_at) as yr,
   -- week(created_at) as wk,
   min(date(created_at)) as start_week,
    count(website_session_id) as sessions
from website_sessions
where created_at < '2012-05-12'
	and utm_source='gsearch' and utm_campaign='nonbrand'
group by
	year(created_at),
    week(created_at) 