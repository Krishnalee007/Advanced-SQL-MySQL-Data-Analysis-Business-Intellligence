-- Analysing channel portfolio trends
-- According device type and utm source, how the sessions trends are vwaring for given dates

use mavenfuzzyfactory;
Select
	 -- year(created_at) as yr,
   -- week(created_at) as wk,
	min(date(created_at)) as week_start,
    count(case when utm_source='gsearch' and device_type='mobile' then website_session_id else null end) as g_mob_sessions,
    count(case when utm_source='bsearch' and device_type='mobile' then website_session_id else null end) as b_mob_sessions,
    count(case when utm_source='bsearch' and device_type='mobile' then website_session_id else null end)/count(case when utm_source='gsearch' and device_type='mobile' then website_session_id else null end) as bmob_percent_of_gmob,
    count(case when utm_source='gsearch' and device_type='desktop' then website_session_id else null end) as g_desk_sessions,
    count(case when utm_source='bsearch' and device_type='desktop' then website_session_id else null end) as b_desk_sessions,
	count(case when utm_source='bsearch' and device_type='desktop' then website_session_id else null end)/count(case when utm_source='gsearch' and device_type='desktop' then website_session_id else null end) as bdesk_percent_of_gdesk
from website_sessions
where created_at>'2012-11-04'
and created_at<'2012-12-22'
and utm_campaign='nonbrand'
group by 
	year(created_at),
	week(created_at)