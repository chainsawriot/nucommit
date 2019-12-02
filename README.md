
<!-- README.md is generated from README.Rmd. Please edit that file -->
nucommit
========

<!-- badges: start -->
<!-- badges: end -->
The goal of nucommit is to calculate the *N*umbers, *U*nity and *Commit*ment metrics from tweet data (usually collected by rtweet::search\_tweet or scrapers such as [twitterscraper](https://github.com/taspinar/twitterscraper)) using the method by Freelon, McIlwain & Clark (2019).

References: 1. Freelon, D., McIlwain, C., & Clark, M. (2018). Quantifying the power and consequences of social media protest. New Media & Society, 20(3), 990-1011.

Installation
------------

``` r
devtools::install_github("chainsawriot/nucommit")
```

Example
-------

Some tweets collected by search\_tweets("\#rstats")

``` r
library(nucommit)
library(tibble)
data(rt)
rt
#> # A tibble: 3,170 x 90
#>    user_id status_id created_at          screen_name text  source
#>    <chr>   <chr>     <dttm>              <chr>       <chr> <chr> 
#>  1 129303… 12015125… 2019-12-02 14:44:43 MDubins     @Mar… Twitt…
#>  2 828660… 12015124… 2019-12-02 14:44:35 chris_tt_c… "Nee… Twitt…
#>  3 828660… 12003763… 2019-11-29 11:29:51 chris_tt_c… "Que… Twitt…
#>  4 739773… 12015121… 2019-12-02 14:43:13 ikashnitsky @maa… Twitt…
#>  5 739773… 11983562… 2019-11-23 21:42:44 ikashnitsky "#30… Twitt…
#>  6 739773… 11991158… 2019-11-26 00:01:00 ikashnitsky "@dm… Twitt…
#>  7 739773… 11993309… 2019-11-26 14:15:47 ikashnitsky Soun… Twitt…
#>  8 739773… 11996318… 2019-11-27 10:11:40 ikashnitsky "@rm… Twitt…
#>  9 739773… 11996342… 2019-11-27 10:21:17 ikashnitsky "@rm… Twitt…
#> 10 739773… 12007874… 2019-11-30 14:43:26 ikashnitsky @eol… Twitt…
#> # … with 3,160 more rows, and 84 more variables: display_text_width <dbl>,
#> #   reply_to_status_id <chr>, reply_to_user_id <chr>,
#> #   reply_to_screen_name <chr>, is_quote <lgl>, is_retweet <lgl>,
#> #   favorite_count <int>, retweet_count <int>, quote_count <int>,
#> #   reply_count <int>, hashtags <list>, symbols <list>, urls_url <list>,
#> #   urls_t.co <list>, urls_expanded_url <list>, media_url <list>,
#> #   media_t.co <list>, media_expanded_url <list>, media_type <list>,
#> #   ext_media_url <list>, ext_media_t.co <list>, ext_media_expanded_url <list>,
#> #   ext_media_type <chr>, mentions_user_id <list>, mentions_screen_name <list>,
#> #   lang <chr>, quoted_status_id <chr>, quoted_text <chr>,
#> #   quoted_created_at <dttm>, quoted_source <chr>, quoted_favorite_count <int>,
#> #   quoted_retweet_count <int>, quoted_user_id <chr>, quoted_screen_name <chr>,
#> #   quoted_name <chr>, quoted_followers_count <int>,
#> #   quoted_friends_count <int>, quoted_statuses_count <int>,
#> #   quoted_location <chr>, quoted_description <chr>, quoted_verified <lgl>,
#> #   retweet_status_id <chr>, retweet_text <chr>, retweet_created_at <dttm>,
#> #   retweet_source <chr>, retweet_favorite_count <int>,
#> #   retweet_retweet_count <int>, retweet_user_id <chr>,
#> #   retweet_screen_name <chr>, retweet_name <chr>,
#> #   retweet_followers_count <int>, retweet_friends_count <int>,
#> #   retweet_statuses_count <int>, retweet_location <chr>,
#> #   retweet_description <chr>, retweet_verified <lgl>, place_url <chr>,
#> #   place_name <chr>, place_full_name <chr>, place_type <chr>, country <chr>,
#> #   country_code <chr>, geo_coords <list>, coords_coords <list>,
#> #   bbox_coords <list>, status_url <chr>, name <chr>, location <chr>,
#> #   description <chr>, url <chr>, protected <lgl>, followers_count <int>,
#> #   friends_count <int>, listed_count <int>, statuses_count <int>,
#> #   favourites_count <int>, account_created_at <dttm>, verified <lgl>,
#> #   profile_url <chr>, profile_expanded_url <chr>, account_lang <lgl>,
#> #   profile_banner_url <chr>, profile_background_url <chr>,
#> #   profile_image_url <chr>
```

Calculate the Numbers time series data

``` r
calculate_numbers(rt)
#> # A tibble: 10 x 2
#>    created_at          numbers
#>    <dttm>                <int>
#>  1 2019-11-23 00:00:00     104
#>  2 2019-11-24 00:00:00     156
#>  3 2019-11-25 00:00:00     249
#>  4 2019-11-26 00:00:00     286
#>  5 2019-11-27 00:00:00     232
#>  6 2019-11-28 00:00:00     179
#>  7 2019-11-29 00:00:00     158
#>  8 2019-11-30 00:00:00     141
#>  9 2019-12-01 00:00:00     153
#> 10 2019-12-02 00:00:00     105
```

Calculate the Unity time series data

``` r
calculate_unity(rt)
#> # A tibble: 10 x 2
#>    created_at          unity
#>    <dttm>              <dbl>
#>  1 2019-11-23 00:00:00 0.760
#>  2 2019-11-24 00:00:00 0.780
#>  3 2019-11-25 00:00:00 0.771
#>  4 2019-11-26 00:00:00 0.777
#>  5 2019-11-27 00:00:00 0.774
#>  6 2019-11-28 00:00:00 0.760
#>  7 2019-11-29 00:00:00 0.724
#>  8 2019-11-30 00:00:00 0.729
#>  9 2019-12-01 00:00:00 0.760
#> 10 2019-12-02 00:00:00 0.705
```

Calculate the Commitment time series data

``` r
calculate_commitment(rt)
#> # A tibble: 10 x 2
#>    created_at          commitment
#>    <dttm>                   <dbl>
#>  1 2019-11-23 00:00:00      0.404
#>  2 2019-11-24 00:00:00      0.436
#>  3 2019-11-25 00:00:00      0.378
#>  4 2019-11-26 00:00:00      0.294
#>  5 2019-11-27 00:00:00      0.276
#>  6 2019-11-28 00:00:00      0.324
#>  7 2019-11-29 00:00:00      0.291
#>  8 2019-11-30 00:00:00      0.248
#>  9 2019-12-01 00:00:00      0.118
#> 10 2019-12-02 00:00:00     NA
```
