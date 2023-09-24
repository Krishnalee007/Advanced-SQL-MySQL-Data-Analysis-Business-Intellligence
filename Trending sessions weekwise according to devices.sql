use mavenfuzzyfactory;
select
	min(date(created_at)) as week_start,
    count(case when device_type='mobile' then website_session_id else null end) as mobile_sessions,
    count(case when device_type='desktop' then website_session_id else null end) as desktop_sessions
from website_sessions 
where created_at between '2012-04-15' and '2012-06-09' 
	and utm_source='gsearch' and utm_campaign='nonbrand'
group by 
	year(created_at),
    week(created_at) 