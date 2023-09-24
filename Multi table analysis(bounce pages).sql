-- CONCEPT ON MUTLI TABLE ANALYSIS AND BOUNCE PAGES

use mavenfuzzyfactory;

-- step 1 : find the first website_pageview_id for relevant sessions
-- step2 : identify the landing page fpr each sessions
-- step 3 : counting pageviews for each session, to identify "bounces"
-- step 4: summarizing total sessions and bounced sessions for LP

CREATE TEMPORARY TABLE first_pageview_demo
SELECT 
	website_pageviews.website_session_id,
    min(website_pageviews.website_pageview_id) as min_pvid
from website_pageviews
	inner join website_sessions
		on website_pageviews.website_session_id=website_sessions.website_session_id
        and website_sessions.created_at BETWEEN '2014-01-01' and '2014-02-01'
group by 1;

-- now we bring the landing page to each session
create temporary table landing_page_demo
Select 
	first_pageview_demo.website_session_id,
    website_pageviews.pageview_url as landing_page
from first_pageview_demo
	left join website_pageviews
		on first_pageview_demo.min_pvid=website_pageviews.website_pageview_id;
	
-- next we need to make table to count the pageviews per sessions

create temporary table bounced_sessions 
select
	landing_page_demo.website_session_id,
    landing_page_demo.landing_page,
    count(website_pageviews.website_pageview_id) as count_of_pv
from landing_page_demo
left join website_pageviews
	on landing_page_demo.website_session_id=website_pageviews.website_session_id
group by 1,2
having count_of_pv=1; -- as which only single page viewd sessin taking out and categorizing as bounced table

-- now here we find the bounce session ids
select
landing_page_demo.landing_page,
landing_page_demo.website_session_id,
bounced_sessions.website_session_id as bounced_id
from landing_page_demo
	left join bounced_sessions
		on bounced_sessions.website_session_id=landing_page_demo.website_session_id
order by 2;

-- now we find number of sessions and bounced sessions for landing pages/entry pages

select
landing_page_demo.landing_page,
count(distinct landing_page_demo.website_session_id) as sessions,
count(distinct bounced_sessions.website_session_id) as bounced_sessions,
count(distinct bounced_sessions.website_session_id)/count(distinct landing_page_demo.website_session_id) as bounce_rate
from landing_page_demo
	left join bounced_sessions
		on bounced_sessions.website_session_id=landing_page_demo.website_session_id
group by 1