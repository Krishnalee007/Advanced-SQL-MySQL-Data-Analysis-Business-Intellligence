-- user analyzing : Identifying repeat users

use mavenfuzzyfactory;

create temporary table repeat_sessions
select 
	new_sessions.user_id,
    new_sessions.website_session_id as new_session_id,
    website_sessions.website_session_id as  repeat_session_id
from (
select
	user_id,
    website_session_id
from website_sessions
where  created_at<'2014-11-01' 
and created_at>='2014-01-01'
and is_repeat_session=0 -- new sessions only
) as new_sessions
left join website_sessions
	on website_sessions.user_id=new_sessions.user_id
    and website_sessions.is_repeat_session=1 -- was repeat session
    and website_sessions.website_session_id>new_sessions.website_session_id
    and website_sessions.created_at<'2014-11-01'
    and website_sessions.created_at>'2014-01-01';
    
    -- select*from repeat_sessions
    
-- now count repeat sessions and user ids

select
	repeat_sessions,
    count(distinct user_id) as users
from (
	select
		user_id,
        count(distinct new_session_id) as new_sessions,
        count(distinct repeat_session_id) as repeat_sessions
	from repeat_sessions
    group by 1
    order by 3 desc
	) as user_level

group by 1;
