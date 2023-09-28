-- Analyzing cross selling products

-- Step 1: Identify the relevant /cart page views and their sessions

use mavenfuzzyfactory;
create temporary table sessions_carts
select 
	case 
		when created_at<'2013-09-25' then 'A.Pre_cross_sell'
        when created_at>='2013-01-06' then 'B.Post_cross_sell'
        else 'uh oh...check logic'
	end as time_period,
    website_session_id as cart_session_id,
    website_pageview_id as cart_pageview_id
from website_pageviews
where created_at between '2013-08-25' and '2013-10-25'
	and pageview_url='/cart';
    
-- step2 : now finding which sessions pageviews are seeing shipping pages from the above sessions

create temporary table cart_another_page
select 
	sessions_carts.time_period,
    sessions_carts.cart_session_id,
    min(website_pageviews.website_pageview_id) as pv_id_after_cart
from sessions_carts
left join website_pageviews
	on website_pageviews.website_session_id=sessions_carts.cart_session_id
    and website_pageviews.website_pageview_id>sessions_carts.cart_pageview_id
group by 1,2
having 
	min(website_pageviews.website_pageview_id) is not null;
    
    
   --  step3: orders and orders item related to above sessions
   
   select
	time_period,
    cart_session_id,
    order_id,
    items_purchased,
    price_usd
from sessions_carts
	inner join orders
			on sessions_carts.cart_session_id=orders.website_session_id

    