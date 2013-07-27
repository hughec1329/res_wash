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

