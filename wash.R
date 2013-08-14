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
holy$wash = "holy"
wash = rbind(holy, gw, port)
wash = wash[-1:-3,]
wash$date = as.Date(wash$date)
table(wash$wash)

wzoo = zoo(wash, order.by = wash$date)

plot(apply.weekly(zoogw, mean))
lines(apply.monthly(zoo.gw,mean),col = "red")

library(ggplot2)
ggplot(aes(x=date, y = tot, color = wash), data = wash[wash$date > as.Date("2012-05-10"),]) + geom_line()


tapply(holy$tot, holy$day, function(i) mean(i, na.rm = T))
tapply(port$tot, port$day, function(i) mean(i, na.rm = T))
tapply(gw$tot, gw$day, function(i) mean(i, na.rm = T))

# ts
library(xts)
wts = ts(wash$date, wash$tot)
		
# getting weather

	
years = unlist(lapply(2008:2013,function(i) paste(i,c(paste("0",1:9,sep = ""),10:12),sep = "")))
urls = sprintf("http://www.bom.gov.au/climate/dwo/%s/text/IDCJDW5002.%s.csv",years[1:67],years[1:67])

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

o$hasRain = o$rain > 0 


mod = lm(tot ~ weekend + day + season + hasRain + sun,data = o)
summary(mod)

mod = lm(tot ~ hasRain + sun,data = o)
summary(mod)
