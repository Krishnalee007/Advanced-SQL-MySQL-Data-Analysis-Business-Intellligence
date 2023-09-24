use mavenfuzzyfactory;
SELECT
	website_sessions.utm_source,
    website_sessions.utm_campaign,
    website_sessions.http_referer,
    COUNT(distinct website_sessions.website_session_id) as sessions
FROM website_sessions
where created_at<'12-04-12'
group by 1,2,3
order by 4 desc