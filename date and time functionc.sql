use mavenfuzzyfactory;
SELECT 
	year(created_at),
    week(created_at),
    min(date(created_at)) as week_start,
    count(website_session_id) as sessions
from website_sessions
where website_session_id between 100000 and 115000
group by 1,2