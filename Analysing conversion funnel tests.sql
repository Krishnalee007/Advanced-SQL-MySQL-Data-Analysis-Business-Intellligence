-- tested on updated billing pages : conversion funnel tests

use mavenfuzzyfactory;

-- step 0 : find fist created at and first page view o=id of billing2
Select
	min(created_at) as first_created_at,
	min(website_pageview_id) as first_pageview_id
from website_pageviews
where pageview_url='/billing-2';

-- first pageview id is 53550 and created at 2012-09-10

-- step 02: find billing and billing2 page sessions comparision
create temporary table billingv
select 
	website_pageviews.website_session_id,
    website_pageviews.pageview_url as billing_version_seen,
    orders.order_id
from website_pageviews
left join orders 
	 on website_pageviews.website_session_id=orders.website_session_id
where website_pageviews.website_pageview_id >=53550
and website_pageviews.created_at<'2012-11-10'
and website_pageviews.pageview_url in ('/billing','/billing-2');

-- final billings to orders ratio for both versions need to find
-- can be done in both ways a) temp table 02) sub query 
-- method 01 : subquery
/*
select 
	billing_version_seen,
    count(distinct website_session_id) as sessions,
    count(distinct order_id) as orders,
    count(distinct order_id)/count(distinct website_session_id) as billing_to_ord_ratio
from (
 select 
	website_pageviews.website_session_id,
    website_pageviews.pageview_url as billing_version_seen,
    orders.order_id
from website_pageviews
left join orders 
	 on website_pageviews.website_session_id=orders.website_session_id
where website_pageviews.website_pageview_id >=53550
and website_pageviews.created_at<'2012-11-10'
and website_pageviews.pageview_url in ('/billing','/billing-2')
) as billing_sessions_w_orders

group by billing_version_seen;  
    */
-- select*from billingv

-- method 02: temporray table

select 
	billing_version_seen,
    count(distinct website_session_id) as sessions,
    count(distinct order_id) as orders,
    count(distinct order_id)/count(distinct website_session_id) as billing_to_ord_ratio
from billingv
group by billing_version_seen