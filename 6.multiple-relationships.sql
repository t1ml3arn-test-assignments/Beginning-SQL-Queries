select * from member join team on team = teamname;

-- give the name of a manager of each team
-- and the name of teams
select teamname, firstname, lastname from team 
  join member on manager = memberid
;

-- give all members of each team
select 
  firstname || ' ' || lastname as Member,
  team, practicenight
  from member join team on team = teamname
  order by team
;

-- give a count of members with/without team
select 
  ifnull(team,'-- without team --') Team, 
  count(*) 'Member Count' 
  from member
  group by 1
;

-- get manager and its team if that manager 
-- belongs to that team
select
  firstname || ' ' || lastname as Member,
  teamname
  from team
  join member on (team=teamname and manager=memberid)
;

-- get manager and its team if that manager 
-- IS NOT in that team
select
  firstname || ' ' || lastname as Member,
  teamname, team
  from team
  join member on (manager=memberid and 
  -- team is null meant that a member
  -- does not belong to any team
  -- and team != teamname means
  -- that member in team, but the member
  -- is not manager of current team
                    (team is null or team != teamname))
;

-- give teams, their members and their managers
select
  t.teamname,
  mg.firstname || ' ' || mg.lastname as 'Team Manager',
  m.firstname || ' ' || m.lastname as 'Team Member'
  from team t
  join member m on t.teamname = m.team
  join member mg on t.manager = mg.memberid
  order by t.teamname
;

-- find teams whose managers are not members of the team
select t.teamname from team t, member m
  where t.manager = m.memberid
	and (t.teamname != m.team or m.team is null)
;
