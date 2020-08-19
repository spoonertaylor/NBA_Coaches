# * Purpose: Scrape Coaches from bbref

# * Function to scrape the bbref table with coaching data
get_coaches_season = function(season) {
  url = paste0('https://www.basketball-reference.com/leagues/NBA_',season,'_coaches.html')
  page = tryCatch({
    xml2::read_html(url)
  },
  error = function(e) {
    stop(paste0('Unable to coaches for ', season))
    NULL
  }
  )
  coach_page = page %>% rvest::html_nodes(xpath = '//*[@id="NBA_coaches"]') %>%
    rvest::html_table()  
  coach_page = coach_page[[1]]
  coach_page = coach_page[3:nrow(coach_page),c(1,2,4,7,8,9, 18, 19, 20)]
  colnames(coach_page) = c('coach_name', 'team_abbrv', 'seasons_with_team', 'games_coached', 'games_W', 'games_L', 
                           'playoff_games', 'playoff_games_W', 'playoff_games_L')
  coach_page = coach_page %>% dplyr::mutate(
    games_coached = as.integer(games_coached),
    games_W = as.integer(games_W),
    games_L = as.integer(games_L),
    seasons_with_team = as.integer(seasons_with_team),
    playoff_games = ifelse(playoff_games != '', as.integer(playoff_games), 0),
    playoff_games_W = ifelse(playoff_games_W != '', as.integer(playoff_games_W), 0),
    playoff_games_L = ifelse(playoff_games_L != '', as.integer(playoff_games_L), 0)
  )
  coach_page$season = season
  coach_page = coach_page %>% dplyr::mutate(new_coach = ifelse(seasons_with_team == 1, 1, 0))
  coach_page = coach_page %>% dplyr::group_by(team_abbrv) %>% dplyr::mutate(team_coach_number = dplyr::row_number())
  coach_page = coach_page %>% dplyr::select(season, team_abbrv, coach_name, games_coached, games_W, games_L, 
                                            playoff_games, playoff_games_W, playoff_games_L,
                                            team_coach_number, seasons_with_team, new_coach)
  return(coach_page)
}

# * Scrape all seasons from 1960-2020
`%dopar%` = foreach::`%dopar%`
`%:%` = foreach::`%:%`
# Set up parallel running
cores = parallel::detectCores()
cl = parallel::makeCluster(cores[1] - 1)
doParallel::registerDoParallel(cl)
# Run over each season
# This runs stuff in parallel.
coaches_df = foreach::foreach(season=1960:2020,
                            .combine=dplyr::bind_rows, .export = c('get_coaches_season')) %dopar% {
                              `%>%` = dplyr::`%>%`
  get_coaches_season(season)
}
# Stop parralel
parallel::stopCluster(cl)
# Save
write_csv(coaches_df, path = '~/Documents/nba_coaches/coaches_long.csv')

# Widen Coaches Table
wide_coach = coaches_df %>% group_by(team_abbrv, coach_name) %>%
  summarise(
    start_season = min(season),
    end_season = max(season),
    games_coached = sum(games_coached),
    games_W = sum(games_W),
    games_L = sum(games_L),
    playoff_games = sum(playoff_games),
    playoff_games_W = sum(playoff_games_W),
    playoff_games_L = sum(playoff_games_L),
    seasons_coach = sum(seasons_with_team)
  )
# Save
#write_csv(wide_coach, path='')