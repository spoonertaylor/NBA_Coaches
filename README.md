# NBA Coaches

Quick Script to pull NBA Coaching info from [basketball reference](https://www.basketball-reference.com/leagues/NBA_2020_coaches.html) from the 1960-2020 season. There are two CSV files to download which you can use for your pleasure. Basketball reference does not provide when coaches were fired/took over thus multiple coaches may be attributed to the same season for a team.

### Coaches Long
A long version of coaching history in which each row corresponds to team's season's coach. For teams that had more than one coach in that season there are multiple rows for that season.

| Column Name  | Description |
| ------------ | ----------- |
| season  | The NBA Season as determined by the year the season ended in.  |
| team_abbrv  | The BBref Team Abbreviation  |
| coach_name | Full name of the coach |
| games_coached | Number of games coached by that coach for that team in that season |
| games_W | How many games the coach won that season |
| games_L | How many games the coach lost that season |
| team_coach_number | Which coach that team is on for that season, starting with 1 
This column with games_coached you can try to attribute which games were coached by which coach |
| seasons_with_team | Number of seasons the coach has been with the team |
| new_coach | Binary: 1 first season with the team, 0 returning coach |
