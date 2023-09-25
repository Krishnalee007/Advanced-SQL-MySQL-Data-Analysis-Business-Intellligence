-- Analyzing business patterns

use mavenfuzzyfactory;

select
	hr,
	round(avg(case when wkday = 0 then website_sessions else null end),1) as mon,
    round(avg(case when wkday = 1 then website_sessions else null end),1) as tue,
    round(avg(case when wkday = 2 then website_sessions else null end),1) as wed,
    round(avg(case when wkday = 3 then website_sessions else null end),1) as thu,
    round(avg(case when wkday = 4 then website_sessions else null end),1) as fri,
    round(avg(case when wkday = 5 then website_sessions else null end),1) as sat,
    round(avg(case when wkday = 6 then website_sessions else null end),1) as sun
from (
	select
	date(created_at) as created_at,
    weekday(created_at) as wkday,
    hour(created_at) as hr,
    count(distinct website_session_id) as website_sessions
from website_sessions
where created_at between '2012-09-15' and '2012-11-15'
group by 1,2,3
) as daily_hours_sessions
group by 1
order by 1	