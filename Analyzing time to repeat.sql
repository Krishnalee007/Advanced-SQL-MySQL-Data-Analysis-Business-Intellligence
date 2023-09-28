-- Analyzing time to repeat customers

use mavenfuzzyfactory;
create temporary table new_sessions_created
select 
	new_sessions.user_id,
    new_sessions.website_session_id as new_session_id,
    new_sessions.created_at as new_session_created_at,
    website_sessions.website_session_id as repeat_session_id,
    website_sessions.created_at as repeat_session_created_at
from (
select
	user_id,
    website_session_id,
	created_at
from website_sessions
where created_at<'2014-11-03'
and created_at>='2014-01-01'
and is_repeat_session=0 -- new sessions only
) as new_sessions

left join website_sessions
	on website_sessions.user_id=new_sessions.user_id
    and website_sessions.is_repeat_session=1 -- was a repeated sessions
    and website_sessions.website_session_id>new_sessions.website_session_id
    and website_sessions.created_at<'2014-11-03'
    and website_sessions.created_at>='2014-01-01'
    ;
    
-- select*
create temporary table first_to_second
select
	user_id,
    datediff(second_session_created_at,new_session_created_at) as days_first_to_sec_session
from (
select
	user_id,
    new_session_id,
    new_session_created_at,
    min(repeat_session_id) as second_session_id,
    min(repeat_session_created_at) as second_session_created_at
from new_sessions_created
where repeat_session_id IS NOT NULL
group by 1,2,3
) as first_to_sec;

-- select*from first_to_second

select
	avg(days_first_to_sec_session) as avg_days_fisrt_to_sec,
    min(days_first_to_sec_session) as min_days_fisrt_to_sec,
    max(days_first_to_sec_session) as max_days_fisrt_to_sec
from first_to_second
