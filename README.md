# car wash BI project

## goal : 

## references
### weather
- http://casoilresource.lawr.ucdavis.edu/drupal/node/991
- http://billalex.wordpress.com/2013/04/30/r-weather/
- ended up pollin glast 6 years from bom and writing script to strip out - now in r data frame 'weather.r'

### dashboarding/displaying
- http://binalytics.wordpress.com/2012/06/18/quick-web-app-with-r-rook-and-ggplot2-for-a-stock-symbol-candle-chart/ using rook and ggplot
- better dynamic server - shiny
- http://www.rstudio.com/shiny/
- https://github.com/rstudio/shiny-server/wiki/Ubuntu-step-by-step-install-instructions - host locally.
- https://github.com/ramnathv/dashifyr - dashboarding framework using js plugins knob rcharts and shiny server
- https://github.com/trestletech/ShinyDash - another dashboard built on shiny server and js

### js libraries
- rcharts - highcharts
- http://shopify.github.io/dashing/
- d3 - need to learn actual javascript of jquery

## getting data
- intially export mail manually matching srearch: from
-- eventually automate to scrape of entire outlook backup - pst.
- ubuntu cli readpst -S to individual plaintext files
- awk/cut/sed to strip out data from each email 
-- play with file 'sample_email.txt'

## modelling
### EDA
- ramp up time for new wash
- daily split/ weekday/weekend


### dependents
- total number washes
- washes in OH
- percent premium wash
- time of washes - within oh or without

### independent
- weather - can scrape from BOM, GSOD??
-- sunlight
-- precipitation
-- temperature
- weekend vs weekday
- public holiday
- season - 2 or 4?? - categorical.

- demographics - population, 
- shopping centre numbers>?? can get?

