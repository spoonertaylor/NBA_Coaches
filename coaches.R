# * Purpose: Scrape Coaches from bbref

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
  coach_page = coach_page[3:nrow(coach_page),c(1,2,4,7,8,9)]
  colnames(coach_page) = c('coach_name', 'team_abbrv', 'seasons_with_team', 'games_coached', 'games_won', 'games_losed')
  coach_page$season = season
  coach_page = coach_page %>% dplyr::mutate(new_coach = ifelse(seasons_with_team == 1, 1, 0))
  coach_page = coach_page %>% dplyr::group_by(team_abbrv) %>% dplyr::mutate(team_coach_number = dplyr::row_number())
  coach_page = coach_page %>% dplyr::select(season, team_abbrv, coach_name, games_coached, games_won, games_losed, team_coach_number, seasons_with_team, new_coach)
  return(coach_page)
}

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

coaches_df = coaches_df %>%
  mutate(games_coached = as.integer(games_coached),
         games_W = as.integer(games_won),
         games_L = as.integer(games_losed),
         seasons_with_team = as.integer(seasons_with_team)
  ) %>%
  select(-games_won, -games_losed)

write_csv(coaches_df, path = '~/Documents/nba_projects/quarter_splits/coaches_long.csv')

# Widen Coaches
wide_coach = coaches_df %>% group_by(team_abbrv, coach_name) %>%
  summarise(
    start_season = min(season),
    end_season = max(season),
    games_coached = sum(games_coached),
    games_W = sum(games_W),
    games_L = sum(games_L),
    seasons_coach = sum(seasons_with_team)
  )