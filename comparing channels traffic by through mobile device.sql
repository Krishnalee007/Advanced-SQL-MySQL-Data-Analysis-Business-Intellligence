-- Comparing chnnel characteristics through mobile device type

use mavenfuzzyfactory;
select
	utm_source,
    count(website_session_id) as total_sessions,
    count(case when device_type='mobile' then website_session_id else null end) as mobile_sessions,
    count(case when device_type='mobile' then website_session_id else null end)/count(website_session_id) as mobile_percent_traffi
from website_sessions
where created_at>'2012-08-22'
and created_at<'2012-11-30'
and utm_campaign='nonbrand'
and utm_source in ('bsearch', 'gsearch')
group by utm_source
