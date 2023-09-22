-- ASSIGNMENT on BOUNCE RATES of landing page (''home page")

use mavenfuzzyfactory;

-- step 1 : find the first website_pageview_id for relevant sessions
-- step2 : identify the landing page fpr each sessions
-- step 3 : counting pageviews for each session, to identify "bounces"
-- step 4: summarizing total sessions and bounced sessions for LP

-- step : 01
create temporary table first_page_view
Select 
	website_session_id,
    min(website_pageview_id) as min_pvid
from website_pageviews
where created_at<'2012-06-14'
group by 1;

-- step : 02
create temporary table land_page_table
select 
	first_page_view.website_session_id,
    website_pageviews.pageview_url as landing_page
from first_page_view
left join website_pageviews
	on first_page_view.min_pvid=website_pageviews.website_pageview_id
where website_pageviews.pageview_url='/home';
  
    -- Step : 03
create temporary table bounced_s_table
select 
	land_page_table.landing_page,
    land_page_table.website_session_id,
    count(website_pageviews.website_pageview_id) as count_of_pvs
from land_page_table
left join website_pageviews
	on land_page_table.website_session_id=website_pageviews.website_session_id
group by 1,2
having count_of_pvs=1;

-- Step : 04
    
Select
	land_page_table.landing_page,
    land_page_table.website_session_id as session_ids,
    bounced_s_table.website_session_id as bounced_ids
from land_page_table
	left join bounced_s_table
		on land_page_table.website_session_id=bounced_s_table.website_session_id
order by 2;


select
	land_page_table.landing_page,
    count(land_page_table.website_session_id) as sessions,
    count(bounced_s_table.website_session_id) as bounced_sessions,
    count(bounced_s_table.website_session_id)/ count(land_page_table.website_session_id) as bounce_rate
from land_page_table
left join bounced_s_table
	 on land_page_table.website_session_id=bounced_s_table.website_session_id
group by 1

