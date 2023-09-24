use mavenfuzzyfactory;

-- step 1: find the first page of each session
-- step 2: find the url the customer saw on that first page

create temporary table fpv_sessions
select
	website_session_id,
    min(website_pageview_id) as first_page_view
from website_pageviews
where created_at<'2012-06-12'
group by 1;

select
	website_pageviews.pageview_url as landing_page_url,
    count(fpv_sessions.website_session_id) as hiting_entry_pages
from fpv_sessions
left join website_pageviews
	on fpv_sessions.first_page_view=website_pageviews.website_pageview_id
    group by website_pageviews.pageview_url

