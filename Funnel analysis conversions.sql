-- funnel conversion analysis
use mavenfuzzyfactory;

create temporary table funnel
select 
	website_sessions.website_session_id,
    website_pageviews.pageview_url,
    website_pageviews.created_at as pageview_created_at,
    case when pageview_url='/products' then 1 else 0 end as product_page,
	case when pageview_url='/the-original-mr-fuzzy' then 1 else 0 end as mrfuzzy_page,
    case when pageview_url='/cart' then 1 else 0 end as cart_page
from website_sessions
left join website_pageviews
	on website_sessions.website_session_id=website_pageviews.website_session_id
where website_sessions.created_at between '2014-01-01' and '2014-02-01' -- randomly taken
 and website_pageviews.pageview_url in ('/lander-2', '/products', '/the-original-mr-fuzzy', '/cart')
order by 1,3;

-- select*from funnel;

-- now find number of sessions when into prdouct page and then to cart

SELECT 	
	count(distinct website_session_id) as sessions,
    count(distinct case when product_page=1 then website_session_id else null end) as to_products,
    count(distinct case when mrfuzzy_page=1 then website_session_id else null end) as to_mrfuzzy_page,
    count(distinct case when cart_page=1 then website_session_id else null end) as to_cart_page
from funnel;
   
-- now find the ratio of funneling to cart page

SELECT 	
	count(distinct website_session_id) as sessions,
    count(distinct case when product_page=1 then website_session_id else null end)/count(distinct website_session_id) as clicked_to_products,
    count(distinct case when mrfuzzy_page=1 then website_session_id else null end)/count(distinct case when product_page=1 then website_session_id else null end) as clicked_to_mrfuzzy_page,
    count(distinct case when cart_page=1 then website_session_id else null end)/count(distinct case when mrfuzzy_page=1 then website_session_id else null end) as clicked_to_cart_page
from funnel

    