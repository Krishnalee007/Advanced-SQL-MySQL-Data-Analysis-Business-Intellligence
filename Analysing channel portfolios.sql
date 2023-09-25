-- Analysing channel portfolio

use mavenfuzzyfactory;
Select
	 -- year(created_at) as yr,
   -- week(created_at) as wk,
	min(date(created_at)) as week_start,
    count(case when utm_source='gsearch' then website_session_id else null end) as gsearch_sessions,
    count(case when utm_source='bsearch' then website_session_id else null end) as bsearch_sessions
from website_sessions
where created_at>'2012-08-22'
and created_at<'2012-11-29'
and utm_campaign='nonbrand'
group by 
	year(created_at),
	week(created_at)