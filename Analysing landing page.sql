-- Analysing Landing pages
-- step 0: find out when new page of lander launched

use mavenfuzzyfactory;

-- step 0 :
Select
	min(created_at) as first_created_at,
	min(website_pageview_id) as first_pageview_id
from website_pageviews
where pageview_url='/lander-1';

-- now we have first created at 2012-07-28 & first pageview id = 23504
-- we use the above data further for grabing relevant session id

-- step: 1 finding first view session ids
create temporary table first_page_test
select
	website_pageviews.website_session_id,
    min(website_pageviews.website_pageview_id) as fist_page_views
from website_pageviews
Inner join website_sessions
	on website_pageviews.website_session_id=website_sessions.website_session_id
where website_sessions.created_at<'2012-07-28'
and website_pageviews.website_pageview_id>23504
and utm_source='gsearch'
and utm_campaign='nonbrand'
group by website_pageviews.website_session_id;

-- step 02: grabing landing pages for this sessions

create temporary table nonbrand_landing_page
select
	first_page_test.website_session_id,
    website_pageviews.pageview_url as landing_page
from first_page_test
left join website_pageviews
on first_page_test.website_session_id=website_pageviews.website_session_id
where website_pageviews.pageview_url in ('/home' , '/lander-1');

-- step 03 : now finding boucing sessions from this nonbrand landing page table

create temporary table bounce_table
select
	nonbrand_landing_page.landing_page,
    nonbrand_landing_page.website_session_id,
    count(website_pageviews.website_pageview_id) as count_of_pvs
from nonbrand_landing_page
left join website_pageviews 
	on nonbrand_landing_page.website_session_id=website_pageviews.website_session_id
group by 1,2
having count_of_pvs=1;

-- step 04: finding landing pages for this bounce-ids

select
	nonbrand_landing_page.landing_page,
    nonbrand_landing_page.website_session_id as sessions_ids,
    bounce_table.website_session_id as bounce_ids
from nonbrand_landing_page
left join bounce_table
	on nonbrand_landing_page.website_session_id=bounce_table.website_session_id
order by 2;

-- step 05: now drag counts of session ids and bounce sessions and from that find bounce rate for both /home and /lander-1

select
	nonbrand_landing_page.landing_page,
    count(distinct nonbrand_landing_page.website_session_id) as sessions,
    count(distinct bounce_table.website_session_id) as bounced_sessions,
    count(distinct bounce_table.website_session_id)/count(distinct nonbrand_landing_page.website_session_id) as bounce_rate
from nonbrand_landing_page
left join bounce_table
	on nonbrand_landing_page.website_session_id=bounce_table.website_session_id
group by 1