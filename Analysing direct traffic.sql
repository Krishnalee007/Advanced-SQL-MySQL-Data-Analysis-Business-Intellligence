-- Analysing direct traffic

use mavenfuzzyfactory;

select
	year(created_at) as yr,
    month(created_at) as mon,
    count(case when utm_campaign='nonbrand' then website_session_id else null end) as nonbrand,
    count(case when utm_campaign='brand' then website_session_id else null end) as brand,
    count(case when utm_campaign='brand' then website_session_id else null end)/count(case when utm_campaign='nonbrand' then website_session_id else null end) as brand_percent_of_nonbrand,
    count(case when utm_source is NULL and http_referer is NULL then website_session_id else null end) as direct,
	count(case when utm_source is NULL and http_referer is NULL then website_session_id else null end)/count(case when utm_campaign='nonbrand' then website_session_id else null end) as direct_percent_of_nonbrand,
	count(case when utm_source is NULL and http_referer in ('https://www.gsearch.com', 'https://www.bsearch.com') then website_session_id else null end) as organic,
    count(case when utm_source is NULL and http_referer in ('https://www.gsearch.com', 'https://www.bsearch.com') then website_session_id else null end)/count(case when utm_campaign='nonbrand' then website_session_id else null end) as organic_percent_of_nonbrand
from website_sessions
where created_at<'2012-12-23'
group by 1,2    