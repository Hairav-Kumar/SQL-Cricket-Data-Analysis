
select * from matches;
select * from players;

-- Q1 Find the total number of matches played by each team?
with cte as (select team_1 as team , count(*) as matches_played from matches group by team_1 union all
select team_2 as team , count(*) as matches_played from matches group by team_2)
select team,sum(matches_played) as total_no_matches from cte group by team;

-- Q2 Calculate the average runs scored by players from each team and rank based on their average runs scored?
with cte as (select team,round(avg(total_runs),0) as avg_score from players group by team)
select *,dense_rank() over(order by avg_score desc) as rank_of_team from cte;

-- Q3 List the top 3 players with the highest runs?
select player_name,sum(total_runs) as highest_run from players group by player_name order by highest_run desc limit 3;

-- Q4 Find the total wickets taken by all bowlers from Australia?
select sum(total_wickets) as total_wicket from players where team = "Australia";

-- Q5 Find the top 3 team who take more wicket?
select team,sum(total_wickets) as total_wicket from players group by team order by total_wicket desc limit 3;

-- Q6 Show the matches where the venue was in "Mumbai" or "Delhi"?
select * from matches where venue in ("mumbai","delhi");

-- Q7 Find the player with the highest number of wickets in each team?
select team, player_name, total_wickets from players p1 where total_wickets = (select max(total_wickets) from players p2 where p2.team =p1.team) order by team;

select team, player_name, total_wickets from (select *,dense_rank() over(partition by team order by total_wickets desc) as rnk  from players) sal 
where rnk =1 order by team;

-- Q8 List the matches won by 'India' where they played as team_1?
select * from matches where team_1 = "india" and result = "india won";

-- Q9 Calculate the strike rate of players (runs per match) and order by strike rate?
select player_name, round(total_runs/matches_played,0) as strike_rate from players order by strike_rate desc;

-- Q10 Find players who have taken more than 200 wickets?
select player_name,total_wickets from players where total_wickets >200;

-- Q11 Identify teams that won more than 2 matches?
select result as team_name,count(*) as won_matches from matches where result like "%won%" group by result having won_matches >2;

-- Q12 Find players with a batting average (runs per match) above 40?
select player_name , round((total_runs/matches_played),0) as batting_average from players having batting_average > 40;

-- Q13 Show the list of players who have played more than 200 matches but have less than 10 wickets?
select player_name,matches_played,total_wickets from players where matches_played >200 and total_wickets <10;

-- Q14 Find the most common venue for matches?
select venue ,count(*) as match_count from matches group by venue order by match_count desc limit 1;

-- Q15 Based On Year Find The Number Of Matches Won By Each Team?
select result as team,year(date) as year ,count(*) as matches_won  from matches where result like "%won%" group by result,year;

-- Q16 Find the player from each team who played the fewest matches but scored the most runs?
with cte as (select *,dense_rank() over( partition by team order by matches_played asc) as matches_rnk , dense_rank() over( partition by team order by total_runs desc) 
as runs_rnk from players)
select player_name,team,matches_played,total_runs from cte where matches_rnk = 1 and runs_rnk = 1;

select player_name,team,matches_played,total_runs from players p1 where (matches_played,total_runs) in (select min(matches_played),max(total_runs) 
from players p2 where p1.team = p2.team);

-- Q17 Find the player from each team who scored the most runs?
with cte as (select *,dense_rank() over(partition by team order by total_runs desc) as rnk from players)
select player_name,team,total_runs from cte where rnk =1;








