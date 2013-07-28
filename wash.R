# carwash data analysis
# 20130728 HCrockford


# eventulaly have all data stripping controlled withi script so can run from R CMD
system('./stripper.sh sample_email.txt')
w = readLines("out")
wash = data.frame(matrix(w, ncol = 30, byrow = T))
names(wash) = c("date", paste(0:23,"h",sep = ""), "tot",paste("pc", 1:4, sep = ""))
p = t(apply(wash,1,function(i) as.numeric(as.character(i))))
wash[,2:30] = data.frame(p)[,2:30]
wash$tot = rowSums(wash[2:25])
wash$date = strptime(as.character(wash$date),format = '%m/%d/%Y')


# ts
library(xts)

		
