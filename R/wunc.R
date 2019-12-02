.clean <- function(input) {
    if (all(c("user_id", "created_at", "text") %in% names(input))) {
        output <- dplyr::select(input, user_id, created_at, text)
    } else {
        ## POSITIONAL ASSUMPTION
        output <- input[,1:3]
        names(output) <- c("user_id", "created_at", "text")
    }
    if (!"POSIXct" %in% class(output$created_at)) {
        output$created_at <- lubridate::ymd_hms(output$created_at)
    }
    return(output)
}

#' Calculate the numbers time series according to Freelon et al.
#'
#' This function calculates the 'numbers' time series from tweets according to Freelon et al. (2019)
#' @param input a data frame, either from rtweet::search_tweets or any one with the three columns meaning user id, timestamp and content.
#' @return A tibble with date and the 'numbers' metric.
#' @importFrom magrittr %>%
#' @references Freelon, D., McIlwain, C., & Clark, M. (2018). Quantifying the power and consequences of social media protest. New Media & Society, 20(3), 990-1011.
#' @export
calculate_numbers <- function(input) {
    input <- .clean(input)
    input %>% dplyr::mutate(created_at = lubridate::floor_date(created_at, unit = "day")) %>% dplyr::group_by(created_at, user_id) %>% dplyr::count() %>% dplyr::ungroup() %>% dplyr::count(created_at) %>% dplyr::arrange(created_at) %>% dplyr::rename(numbers = "n")
}

#' Calculate the unity time series according to Freelon et al.
#'
#' This function calculates the 'unity' time series from tweets according to Freelon et al. (2019)
#' @param input a data frame, either from rtweet::search_tweets or any one with the three columns meaning user id, timestamp and content.
#' @return A tibble with date and the 'unity' metric.
#' @references Freelon, D., McIlwain, C., & Clark, M. (2018). Quantifying the power and consequences of social media protest. New Media & Society, 20(3), 990-1011.
#' @export
calculate_unity <- function(input) {
    input <- .clean(input)
    input %>% dplyr::mutate(created_at = lubridate::floor_date(created_at, unit = "day")) %>% dplyr::mutate(hashtags = stringr::str_extract_all(tolower(text), "#[A-Za-z0-9]*")) %>% dplyr::group_by(created_at) %>% dplyr::select(created_at, hashtags) %>% dplyr::group_by(created_at) %>% dplyr::summarise(al = list(unlist = hashtags)) %>% dplyr::mutate(al = purrr::map(al, unlist)) %>% dplyr::mutate(gini = purrr::map_dbl(al, ~reldist::gini(table(.)))) %>% dplyr::arrange(created_at) %>% dplyr::select(created_at, gini) %>% dplyr::rename(unity = "gini")
}

.windowing_count <- function(i, user_hash, after_days = 3) {
    current_date <- user_hash[i, 1] %>% dplyr::pull()
    current_user <- dplyr::pull(user_hash[i, 2])[[1]]
    dplyr::filter(user_hash, created_at > current_date & created_at <= current_date + lubridate::days(after_days)) %>% dplyr::pull(data) %>% dplyr::bind_rows() -> all_users_next_3
    if(ncol(all_users_next_3) == 0) {
        return(NA)
    }
    consistent_users <- intersect(current_user$user_id, all_users_next_3$user_id)
    ratio <- length(consistent_users) / nrow(current_user)
    return(ratio)
}

#' Calculate the commitment time series according to Freelon et al.
#'
#' This function calculates the 'commitment' time series from tweets according to Freelon et al. (2019)
#' @param input a data frame, either from rtweet::search_tweets or any one with the three columns meaning user id, timestamp and content.
#' @param after_days a number to determine what consistents a repeat participation. Default to 3 days (Freelon et al.)
#' @return A tibble with date and the 'unity' metric.
#' @references Freelon, D., McIlwain, C., & Clark, M. (2018). Quantifying the power and consequences of social media protest. New Media & Society, 20(3), 990-1011.
#' @export
calculate_commitment <- function(input, after_days = 3) {
    input <- .clean(input)    
    input %>% dplyr::mutate(created_at = lubridate::floor_date(created_at, unit = "day")) %>% dplyr::group_by(created_at, user_id) %>% dplyr::count() %>% dplyr::select(-n) %>% dplyr::ungroup() %>% dplyr::group_by(created_at) %>% tidyr::nest(data = user_id) -> user_hash
    user_hash$commitment <- purrr::map_dbl(1:nrow(user_hash), .windowing_count, user_hash = user_hash, after_days = after_days)
    user_hash %>% dplyr::ungroup(create_at) %>% dplyr::select(created_at, commitment) %>% dplyr::arrange(created_at)
}
