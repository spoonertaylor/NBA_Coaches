# NBA Coaches

Quick Script to pull NBA Coaching info from [basketball reference](https://www.basketball-reference.com/leagues/NBA_2020_coaches.html) from the 1960-2020 season. There are two CSV files to download which you can use for your pleasure. Basketball reference does not provide when coaches were fired/took over thus multiple coaches may be attributed to the same season for a team.

### Coaches Long
A long version of coaching history in which each row corresponds to team's season's coach. For teams that had more than one coach in that season there are multiple rows for that season. To try and attribute coaches to individual games, I would suggest using the `team_coach_number` and `games_coached` columns. For example, if a Coach A coached 10 games as the first coach for the team and Coach B coached the last 72 

| Column Name  | Description |
| ------------ | ----------- |
| season  | The NBA Season as determined by the year the season ended in.  |
| team_abbrv  | The BBref Team Abbreviation  |
| coach_name | Full name of the coach |
| games_coached | Number of games coached by that coach for that team in that season |
| games_W | How many games the coach won that season |
| games_L | How many games the coach lost that season |
| playoff_games | How many playoff games coached in season |
| playoff_games_W | How many playoff wins |
| playoff_games_L | How many playoff loses |
| team_coach_number | Which coach that team is on for that season, starting with 1 |
| seasons_with_team | Number of seasons the coach has been with the team |
| new_coach | Binary: 1 first season with the team, 0 returning coach |

### Coaches Wide
A wide, summarized version of the above table that allows you to look at the total era of a coach for a team. When was the first and last season they were with a team and how many total games coached.

| Column Name | Description |
| ----------- | ----------- |
| team_abbrv  | BBref team abbreviation |
| coach_name | Coach's name |
| start_season | First season coached with the team |
| end_season | Last season coached with the team |
| games_coached| Total number of games coached |
| games_W | Total number of games won |
| games_L | Total number of games lost |
| playoff_games | Total number of playoff games coached |
| playoff_games_W | Total number of playoff games won |
| playoff_games_L | Total number of playoff games lost |
| seasons_coach | Total number of seasons coached with team |
