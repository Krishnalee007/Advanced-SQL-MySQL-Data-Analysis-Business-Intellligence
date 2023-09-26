-- funnel conversion analysis
use mavenfuzzyfactory;

create temporary table seen_pages
select 
	website_session_id,
    website_pageview_id,
    pageview_url as page_seen
from website_pageviews
where created_at<'2013-04-10'
and created_at>'2013-01-06'
and pageview_url in ('/the-original-mr-fuzzy','/the-forever-love-bear');

-- finding the right pageview urls to build the funnels

SELECT DISTINCT 
	website_pageviews.pageview_url
from seen_pages
left join website_pageviews
	on seen_pages.website_session_id=website_pageviews.website_session_id
    and website_pageviews.website_pageview_id>seen_pages.website_pageview_id;
