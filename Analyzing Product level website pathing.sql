-- Analyzing Product level website pathing

-- step 1:  find the relevant product pageviews with session id
-- step 2: find the next pageview id that occurs after the product pageview
-- step 3: find the pageview_url associated with any applicable next pageview id
-- step 4: summarize the data and analyze the pre and post periods

use mavenfuzzyfactory;
create temporary table product_pageviews
select
	website_session_id,
    website_pageview_id,
    created_at,
    case
		when created_at<'2013-01-06' then 'A. pre_product_2'
        when created_at> '2012-01-06' then 'B. post_product_2'
        else 'uhh oohh..check your logic'
	end as time_period
from website_pageviews
where created_at<'2013-04-06' -- date of request
	and created_at>'2012-10-06' -- start of 3 months before product 2 launch
    and pageview_url='/products';
    
-- select*from product_pageviews

-- step 2: find next pageview ids occurs after the product pageviews

create temporary table session_pgv
select
	product_pageviews.time_period,
    product_pageviews.website_session_id,
    MIN(website_pageviews.website_pageview_id) as min_next_pgv_id
from product_pageviews
	left join website_pageviews
		on website_pageviews.website_session_id=product_pageviews.website_session_id
        and website_pageviews.website_pageview_id>product_pageviews.website_pageview_id
group by 1,2;
    
-- step 3: find the page url for next pageview ids
 
 create temporary table session_pg_url
 select 
	session_pgv.time_period,
    session_pgv.website_session_id,
    website_pageviews.pageview_url as nxt_pageview_url
from session_pgv
	left join website_pageviews
		on session_pgv.min_next_pgv_id=website_pageviews.website_pageview_id;
    
-- step:4 summarize the data and analyze the pre and post periods

select
	time_period,
    count(distinct website_session_id) as sessions,
    count(distinct case when nxt_pageview_url is NOT NULL then website_session_id else null end) as w_nxt_pg,
	count(distinct case when nxt_pageview_url = '/the-original-mr-fuzzy' then website_session_id else null end) as to_mrfuzzy,
    count(distinct case when nxt_pageview_url = '/the-original-mr-fuzzy' then website_session_id else null end)/count(distinct website_session_id) as pct_to_mrfuzzy,
    count(distinct case when nxt_pageview_url = '/the-forever-love-bear' then website_session_id else null end) as to_love_bear, 
    count(distinct case when nxt_pageview_url = '/the-forever-love-bear' then website_session_id else null end)/count(distinct website_session_id) as pct_to_lovebear
from session_pg_url
group by 1