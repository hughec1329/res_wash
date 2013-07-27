# car wash BI project

## goal : 

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



## cross hedge
- form cross hedge with traded commodoties to most closely reflect farmgate price milk.

- traded commodoties for inclusion - all from http://future.aae.wisc.edu/tab/prices.html#3, secion CME Butter and Cheese Spot Prices (Daily, Weekly, and Monthly)
* CME block cheddar
* CME butter
* CME (?) NFDM - grade A and extra Grade.

### techniques
- look at cors,
- regression - farmgate dependent.
* adjust for auto cor??
* ARIMA?? - take to tsai?
* ARCH/GARCH models - jacob 139. http://en.wikipedia.org/wiki/Autoregressive_conditional_heteroskedasticity

## optimal hedging ratio
- use cross hedge from part I, calculate optimal hedging ratio
- HR = d cash / d futures
- OLS - find dCP = B0 + B1 dFP

# Look at implied volatility in milk options
- use short dated option - source??
- compare with price
- look at seasonality - cf corn - affected by weather at planting ( may) and tasseling (??) - spikes.


# post meeting 5/30
- conditional heteroskedastic
- use diff butter and cream diff proportions at time.
- ratio as a fiunction of time



