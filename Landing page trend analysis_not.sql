-- Landing pages trend analysis
use mavenfuzzyfactory;

-- step 01: finding fist website_pageview_id for relevant pages

create temporary table first_page_views_and_count
select
	website_sessions.website_session_id,
    min(website_pageviews.website_pageview_id) as fpv_id,
    count(website_pageviews.website_pageview_id) as count_pages
from website_sessions
left join website_pageviews
	on website_sessions.website_session_id=website_pageviews.website_session_id
where website_sessions.created_at> '2012-06-01'
and website_sessions.created_at<'2012-08-31'
and utm_source='gsearch'
and utm_campaign='nonbrand'
group by 1;

-- select*from first_page_views_and_count;

-- step 02: identifying landing pages for each section

create temporary table landing_page
select
	first_page_views_and_count.website_session_id,
    first_page_views_and_count.fpv_id,
    first_page_views_and_count.count_pages,
    website_pageviews.pageview_url as landing_page,
	website_pageviews.created_at as session_created_at
from first_page_views_and_count
left join website_pageviews
	on first_page_views_and_count.fpv_id=website_pageviews.website_pageview_id
    


