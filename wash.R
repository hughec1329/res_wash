# carwash data analysis
# 20130728 HCrockford


# eventulaly have all data stripping controlled withi script so can run from R CMD
system('./doit.sh cw_holy.txt')
w = readLines("out")
wash = data.frame(matrix(w, ncol = 30, byrow = T))
names(wash) = c("date", paste(0:23,"h",sep = ""), "tot",paste("pc", 1:4, sep = ""))
p = t(apply(wash,1,function(i) as.numeric(as.character(i))))
wash[,2:30] = data.frame(p)[,2:30]
wash$tot = rowSums(wash[2:25])
wash$date = strptime(as.character(wash$date),format = '%d %B %Y')
wash$date$mday = wash$date$mday - 1	   # need to subtract day because emails come through night after
wash$OH = rowSums(wash[10:19])
wash$weekend = weekdays(wash$date, abbreviate = T) %in% c("Sat","Sun")
wash$day = weekdays(wash$date)
source('season.R')
wash$season = getSeason(wash$date)
wash = wash[order(wash$date),]


tapply(wash$tot, wash$season, function(i) mean(i, na.rm = T))
tapply(wash$tot, wash$day, function(i) mean(i, na.rm = T))

source('wunder.R')

save(wash, file = "gw.Rdata")
save(wash, file = "port.Rdata")
save(wash, file = "holy.Rdata")

gw = load("gw.Rdata")
gw = wash
zoo.gw = zoo(gw$tot, order.by = gw$date)
gw$wash = "gw"
port = load("port.Rdata")
port = wash
port$wash = "port"
zoo.port = zoo(port$tot, order.by = port$date)
holy = load("holy.Rdata")
holy = wash
holy = holy[-1:-3,]
holy$wash = "holy"
zoo.holy = zoo(holy$tot, order.by = holy$date)
wash = rbind(holy, gw, port)
wash = wash[-1:-3,]
wash$date = as.Date(wash$date)
table(wash$wash)

wzoo = zoo(wash, order.by = wash$date)

plot(apply.weekly(zoogw, mean))
lines(apply.monthly(zoo.gw,mean),col = "red")

holy = load("holy.Rdata")
holy = wash
holy = holy[-1:-3,]
zoo.holy = zoo(holy$tot, order.by = holy$date)
w.holy = apply.weekly(zoo.holy, mean)
m.holy = apply.monthly(zoo.holy, mean)
plot(w.holy)                           # distinct seasonality
plot(m.holy)                           # losing some
ts.m.holy = ts(m.holy, start = c(2008,5), frequency = 12) # need ts to decomp
ts.w.holy = ts(w.holy, start = c(2008,22), frequency = 52)
plot(decompose(ts.w.holy))             # still too much var.
plot(decompose(ts.m.holy))             # better, but hjave lost seasonality?


plot(decompose(w.holy))


library(ggplot2)
ggplot(aes(x=date, y = tot, color = wash), data = wash[wash$date > as.Date("2012-05-10"),]) + geom_line()


tapply(holy$tot, holy$day, function(i) mean(i, na.rm = T))
tapply(port$tot, port$day, function(i) mean(i, na.rm = T))
tapply(gw$tot, gw$day, function(i) mean(i, na.rm = T))

# ts
library(xts)
wts = ts(wash$date, wash$tot)
		
###################
# getting weather
####################
	

# ended up using data from form at http://www.bom.gov.au/climate/data/, possible could automate through file name. 

# ftp only has current data and forecasts

# below will get daily weather observations with last 14 months available. from http://www.bom.gov.au/climate/dwo/IDCJDW5002.latest.shtml
years = unlist(lapply(2008:2013,function(i) paste(i,c(paste("0",1:9,sep = ""),10:12),sep = "")))
urls = sprintf("http://www.bom.gov.au/climate/dwo/%s/text/IDCJDW5002.%s.csv",years[1:67],years[1:67])
urlss = urls[54:67]                    # as only last 14 months available
weatherr = o[1,]
sapply(urlss, function(i) {
	her = read.csv(i,skip = 8,header = F)
	weatherr = rbind(weatherr,her)
})
for(i in 1:14) {
	paste('ur',i) = read.csv(urlss[i],skip = 8,header = F)
	# rbind(weatherr,weather)
}
names(ur) = c("na","date","minT","maxT","rain","evap","sun")
write.csv(o,file = "complete.csv")


read.csv("complete.csv")

### real weather - manually compiled from airport data.

weather = read.csv('airportweather.csv') # get data 
weather$date = strptime(apply(weather, 1,function(i) paste(i[1],i[2],i[3], sep = '-')),format = "%Y-%m-%d")
w = weather[,c(8,4:7)]
w$hasRain  <-  w$rain>0                # make categorical for wet or not

hist(w$sun)                            # look at solar radiation and try to figure out threshold
plot(w$sun)                            # very seasonal - collinearity if include season and this??
# source('season.R')                     # import getSeason function
# w$season = factor(getSeason(w$date))   # set season
boxplot(sun ~ season, data = w)        # outliers even in summer = cloudy days. 
tapply(w$sun, w$season, function(i) mean(i, na.rm = T)) # chose cutoff of 20 as sunny day
w$isSun  <- w$sun>20

# modelling on hollywood as only one with data.

holy = load("holy.Rdata")
holy = wash
holy = holy[-1:-3,]
zoo.holy = zoo(holy$tot, order.by = holy$date)
w.holy = apply.weekly(zoo.holy, mean)
m.holy = apply.monthly(zoo.holy, mean)
plot(w.holy)                           # distinct seasonality
plot(m.holy)                           # losing some
ts.m.holy = ts(m.holy, start = c(2008,5), frequency = 12) # need ts to decomp
ts.w.holy = ts(w.holy, start = c(2008,22), frequency = 52)
ts.d.holy = ts(holy$tot, start = c(2008,171), frequency = 365)


plot(decompose(ts.w.holy))             # still too much var. keep additive as fits with data and makes sense
plot(decompose(ts.m.holy))             # better, but hjave lost seasonalit

# merge weather and data
holy$datechar = as.character(holy$date) # mergre cant handle dates so convert to char
w$datechar = as.character(w$date)
all = merge(holy,w,by = 'datechar')
all = all[,c(-1,-36)]
all$day = factor(all$day)
all$season = factor(all$season)              # categorise what needs to be.

# EDA
boxplot(tot ~ hasRain, data = all)
boxplot(tot ~ season, data = all)      # autumn lowest
all$season = relevel(all$season, 'Autumn') # relevel so autumn is ref
boxplot(tot ~ day, data = all)
tapply(all$tot, all$day, mean)         # wed is lowest
all$day = relevel(all$day, 'Wednesday')
 ggplot(aes(day,tot), data = all) +  geom_boxplot()

plot(tot ~ rain, data = all)           # rain good predictor
boxplot(tot ~ hasRain, data = all)     # 1sd close to being different

plot(tot ~ sun, data = all)            # sun looks good too
boxplot(tot ~ isSun, data = all)     # 1sd close to being different
all$isSun  <- all$sun>20
all$isSun2  <- all$sun>12              # look at plot sees drop off at 12
par(mfrow=c(1,2))
boxplot(tot ~ isSun, data = all,main = 'split = 20')     # better split
boxplot(tot ~ isSun2, data = all,main = 'split = 12')     # better split
par(mfrow=c(1,1))

plot(tot ~ maxtemp, data = all)
plot(tot ~ mintemp, data = all)        # no real pattern in temperature





# modelling
max.mod = lm(tot ~ tot + weekend + day + season + rain + maxtemp + mintemp + sun + hasRain + isSun, data = all)
summary(max.mod)
stepAIC(max.mod)


mod = lm(tot ~ day + season + hasRain + sun,data = all,na.action = na.exclude ) # winter coeff is only positive seasonal?? 
summary(mod)
# cannot include weekend and day in as perfectly collinear.
mod = lm(tot ~ weekend + season + hasRain + sun,data = all,na.action = na.exclude ) # summer still negative?
summary(mod)
mod = lm(tot ~ day + season ,data = all,na.action = na.exclude ) # summer still negative?
summary(mod)                           # thurs, tue not important, rest sig and coef add up.
mod = lm(tot ~ day + season + hasRain,data = all,na.action = na.exclude ) #  add rain
summary(mod)                           # large r2 increase(15 -> 34), coef still good.
mod = lm(tot ~ day + season + hasRain + maxtemp,data = all,na.action = na.exclude )  # add temp - as continous
summary(mod)                           # small r2 jump, temp not worth it.
mod = lm(tot ~ day + season + hasRain + isSun,data = all,na.action = na.exclude ) 
summary(mod)                           #  # sun is collinear?? reversal of summer sign
table(all$isSun, all$season)           # summer winter v close
vif(mod)                               # as expected is sun and season v collinear
mod = lm(tot ~ day + hasRain + season,data = all,na.action = na.exclude ) 
summary(mod)
mod = lm(tot ~ day + hasRain + isSun,data = all,na.action = na.exclude ) 
summary(mod)                           # sun better than season

cor(all$sun, all$rain,use = 'complete.obs') # neg cor bt sun and rain  -expected.
cor(all$maxtemp, all$sun,use = 'complete.obs') # neg cor bt sun and rain  -expected.
cor(all$maxtemp, all$rain,use = 'complete.obs') # neg cor bt sun and rain  -expected.
table(all$isSun, all$season)           # sun cor w season
tapply(all$maxtemp, all$isSun, mean)
tapply(all$mintemp, all$isSun, mean)
boxplot(mintemp ~ season, data = all)
boxplot(maxtemp ~ season, data = all)  

mod = lm(tot ~ day + hasRain + isSun,data = all,na.action = na.exclude ) 
summary(mod)
mod = lm(tot ~ day + hasRain + isSun + maxtemp,data = all,na.action = na.exclude ) 
summary(mod)                           # max temp adds nothing
mod = lm(tot ~ day + hasRain + isSun + mintemp,data = all,na.action = na.exclude ) 
summary(mod)                           # mintemp good predictor, but coefficinet backwards - as mintemperature increases, less washes??

mod = lm(tot ~ day + hasRain + isSun,data = all,na.action = na.exclude ) 
mod2 = lm(tot ~ day + hasRain + isSun2,data = all,na.action = na.exclude ) 
summary(mod)
summary(mod2)                          # r2 increases w lower split





########
# final model using climate data
#######

clim.mod = lm(tot ~ day + hasRain + isSun2,data = all,na.action = na.exclude ) 
summary(clim.mod)

library(car)
anova(clim.mod)
vif(clim.mod)                               # no colin
plot(rstandard(clim.mod))                   # some large student resids
influencePlot(clim.mod)                     # no big lev or distances, strange (temporal??) pattern?
hist(rstandard(clim.mod))                   # noraml.

pred.mod = predict(clim.mod)
plot(pred.mod,type = "l")

# from http://druedin.com/2012/08/11/moving-averages-in-r/
mav <- function(x,n=5){filter(x,rep(1/n,n), sides=2)}

ma.pred = mav(pred.mod, 7)
plot(ma.pred)                          # predictions look good!
ma.pred = mav(pred.mod, 14)
plot(ma.pred)                          # 14 d better

mean(all$tot)
sdd = (ma.pred - all$tot)/mean(all$tot)      # ~SD
plot(sdd)                              # massive var - preds are one mean above actual

ma.actual = mav(all$tot,14)
sdd = (ma.pred - ma.actual)/mean(all$tot)      # ~SD
plot(sdd)                              # 14d rolling average better
acf(sdd)

sum(sdd>0.3,na.rm = T)                 # 55 at 0.3 sd limit
plot(sdd>0.3)                 # 55 at 0.3 sd limit
plot(sdd<-0.3,na.rm = T)                 # 55 at 0.3 sd limit
all$date.x[which(sdd>0.3)]                 # 55 at 0.3 sd limit

sddNA = na.approx(sdd)
sdd.holy = ts(sddNA, start = c(2008,171), frequency = 365) # throw to ts so can use decomp etc
plot(decompose(sdd.holy))              # still seasonality, 
plot(decompose(sdd.holy)$seasonal[194:559],type = "l") # low in winter, high in summer.
acf(sdd.holy)                          # signifignat autocorrelation
spec.pgram(sdd.holy)                   # another method of finding season, unsing Fourier - need to learn? FFT?



########
# final model NO climate data
#######

mod = lm(tot ~ day + season ,data = all,na.action = na.exclude ) #  add rain
summary(mod)                           # large r2 increase(15 -> 34), coef still good.

# next - set control linmits and see how many alerts thrown over in sample data
