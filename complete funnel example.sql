-- funnel conversion analysis
use mavenfuzzyfactory;

-- create temporary table funnel_analysis
select 
	website_sessions.website_session_id,
    website_pageviews.pageview_url,
    website_pageviews.created_at as pageview_created_at,
    case when pageview_url='/products' then 1 else 0 end as product_page,
	case when pageview_url='/the-original-mr-fuzzy' then 1 else 0 end as mrfuzzy_page,
    case when pageview_url='/cart' then 1 else 0 end as cart_page,
    case when pageview_url='/shipping' then 1 else 0 end as shipping_page,
    case when pageview_url='/billing' then 1 else 0 end as billing_page,
    case when pageview_url='/thank-you-for-your-order' then 1 else 0 end as thanks_page
from website_sessions
left join website_pageviews
	on website_sessions.website_session_id=website_pageviews.website_session_id
where website_sessions.created_at between '2012-08-05' and '2012-09-05'
	and website_sessions.utm_source='gsearch'
    and website_sessions.utm_campaign='nonbrand'
 order by 1;

-- select*from funnel_analysis;

-- now find number of sessions when into prdouct page and then to cart

SELECT 	
	count(distinct website_session_id) as sessions,
    count(distinct case when product_page=1 then website_session_id else null end) as to_products,
    count(distinct case when mrfuzzy_page=1 then website_session_id else null end) as to_mrfuzzy_page,
    count(distinct case when cart_page=1 then website_session_id else null end) as to_cart_page,
    count(distinct case when shipping_page=1 then website_session_id else null end) as to_shipping,
    count(distinct case when billing_page=1 then website_session_id else null end) as to_billing,
    count(distinct case when thanks_page=1 then website_session_id else null end) as to_thanks
from funnel_analysis;

   
-- now find the ratio of funneling to cart page

SELECT 	
	count(distinct website_session_id) as sessions,
    count(distinct case when product_page=1 then website_session_id else null end)/count(distinct website_session_id)  as clicked_o_products,
    count(distinct case when mrfuzzy_page=1 then website_session_id else null end)/count(distinct case when product_page=1 then website_session_id else null end) as clicked_to_mrfuzzy_page,
    count(distinct case when cart_page=1 then website_session_id else null end)/count(distinct case when mrfuzzy_page=1 then website_session_id else null end) as clicked_to_cart_page,
    count(distinct case when shipping_page=1 then website_session_id else null end)/count(distinct case when cart_page=1 then website_session_id else null end) as clicked_to_shipping,
    count(distinct case when billing_page=1 then website_session_id else null end)/count(distinct case when shipping_page=1 then website_session_id else null end) as clicked_to_billing,
    count(distinct case when thanks_page=1 then website_session_id else null end)/count(distinct case when billing_page=1 then website_session_id else null end) as clicked_to_thanks
from funnel_analysis;
    