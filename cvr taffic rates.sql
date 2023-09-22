use mavenfuzzyfactory;
SELECT
	COUNT(DISTINCT website_sessions.website_session_id) as sessions,
    COUNT(DISTINCT orders.order_id) as orders,
    COUNT(DISTINCT orders.order_id)/COUNT(DISTINCT website_sessions.website_session_id) AS ord_to_session_conv_rate
FROM website_sessions
	left join orders
		on website_sessions.website_session_id=orders.website_session_id
where website_sessions.created_at < '2012-04-14'
	and utm_source='gsearch'
    
        