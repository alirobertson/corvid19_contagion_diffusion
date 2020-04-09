#Reference: https://www.econstor.eu/bitstream/10419/168541/1/Sudtasan-Mitomo.pdf

library(dplyr)

#Load data
country <- iom
iom <- "iomCorona.csv"
uk <- "ukCorona.csv"
italy <- "italyCorona.csv"

#df <- read.csv("italyCorona.csv")
#df <- read.csv("ukCorona.csv")
df <- read.csv(country)
#Parse data for charting - creates new dataframe called chart
chart <- data.frame(df["period"],df["uptake"] )
plot(chart)
chart
y <- as.matrix(chart[2])
t <- as.matrix(chart[1])

#Start population
if (country==iom){
  pop = 1000 
} else {pop=300000}


#Bass model
nonlin_mod_bass=nls(y~m*(1 - (exp(-(p+q)*t)))/(1 + (q/p)*exp(-(p+q)*t)),start=list(m = pop, p=0.00062, q = 0.2))
print(nonlin_mod_bass)

#Logistic model
nonlin_mod_logistic=nls(y~m/(1+exp(-a*(t-b))), start=list(m=pop, a= 0.2, b=27))
nonlin_mod_logistic

#Gompertz model
#UK Gompertz
#UK nonlin_mod_gompertz=nls(y~m*exp(-exp(-a*(t-b))), start=list(m=pop, a= 0.24, b=30))
#Italy gompertz
#Italy nonlin_mod_gompertz=nls(y~m*exp(-exp(-a*(t-b))), start=list(m=pop, a= 0.24, b=27))
#nonlin_mod_gompertz=nls(y~m*exp(-exp(-a*(t-b))), start=list(m=pop, a= 0.24, b=10))

if(country==uk){nonlin_mod_gompertz=nls(y~m*exp(-exp(-a*(t-b))), start=list(m=pop, a= 0.24, b=30))
} else if(country==italy) {nonlin_mod_gompertz=nls(y~m*exp(-exp(-a*(t-b))), start=list(m=pop, a= 0.24, b=15))
} else {nonlin_mod_gompertz=nls(y~m*exp(-exp(-a*(t-b))), start=list(m=pop, a= 0.24, b=10))}

nonlin_mod_gompertz

#BASSMAPE
errorBass=abs(y-predict(nonlin_mod_bass))/y
nlm_error_bass_mape <- 100*(sum(errorBass))/nrow(y)
print("Bass Model Error(MAPE):")
print(nlm_error_bass_mape)

#LOGISTICMAPE
errorLogistic=abs(y-predict(nonlin_mod_logistic))/y
nlm_error_logistic_mape <- 100*(sum(errorLogistic))/nrow(y)
print("Logistic Model Error(MAPE):")
print(nlm_error_logistic_mape)

#GOMPERTZMAPE
errorGompertz=abs(y-predict(nonlin_mod_gompertz))/y
nlm_error_gompertz_mape <- 100*(sum(errorGompertz))/nrow(y)
print("Gompertz Model Error(MAPE):")
print(nlm_error_gompertz_mape)

#Final chart
plot(chart, main="Contagion under different model types", xlab ="Time (days)", ylab="Detected Infections")
lines(t,predict(nonlin_mod_bass),col="red")
lines(t,predict(nonlin_mod_logistic),col="blue")
lines(t,predict(nonlin_mod_gompertz),col="green")
legend("bottomleft", 
       legend = c("Actual","Bass", "Logistic", "Gompertz"), 
       col = c("black",
               "red", 
               "blue",
               "green"),
       pch = c("_","_","_","_"), 
       bty = "n", 
       pt.cex = 2, 
       cex = 1.2, 
       text.col = "black", 
       horiz = F , 
       inset = c(0.1, 0.1))

#Forward predictions

#Model Predictions 100 days from start of infection
#Bass parameters
bassCoef = data.frame(coef(nonlin_mod_bass))
bassCoef <- bassCoef$coef.nonlin_mod_bass.
mBass = bassCoef[1]
p = bassCoef[2]
q = bassCoef[3]

#Logistic parameters
logisticCoef = data.frame(coef(nonlin_mod_logistic))
logisticCoef <- logisticCoef$coef.nonlin_mod_logistic.
mLog = logisticCoef[1]
aLog = logisticCoef[2]
bLog = logisticCoef[3]

#Logistic parameters
gompertzCoef = data.frame(coef(nonlin_mod_gompertz))
gompertzCoef <- gompertzCoef$coef.nonlin_mod_gompertz.
mGom = gompertzCoef[1]
aGom = gompertzCoef[2]
bGom = gompertzCoef[3]

rm(dfCompiled)

period <- 0

while (period <=100) {
  predBass = round(mBass*(1 - (exp(-(p+q)*period)))/(1 + (q/p)*exp(-(p+q)*period)),0)
  predLogistic = round(mLog/(1+exp(-aLog*(period-bLog))),0)
  predGompertz = round(mGom*exp(-exp(-aGom*(period-bGom))),0)
  if(country==iom){date = d <- as.Date(43908+period, origin = "1900-01-01")
  } else if(country==italy){date = d <- as.Date(43878+period, origin = "1900-01-01")
  } else {date = d <- as.Date(43884+period, origin = "1900-01-01")}
  df <- data.frame(date, period,predBass,predLogistic,predGompertz)
  if (period == 0 ){
  dfCompiled <- rbind(df)
  } else {
  dfCompiled <- rbind(dfCompiled, df)
  }
  period = period +1
 }

allData <- full_join(chart, dfCompiled, by=c("period" = "period"))

if(country==iom){
  plot(allData$date, allData$uptake, pch =4, main="Manx contagion forecasts by different model types", xlab ="Time (days)", ylab="Detected Infections", col="black", ylim=c(0,600))
} else {plot(allData$date, allData$uptake, pch =4, main="Contagion forecasts by different model types", xlab ="Time (days)", ylab="Detected Infections", col="black", ylim=c(0,300000))}
lines(allData$date, allData$predBass,  col="red")
lines(allData$date, allData$predLogistic,  col="blue")
lines(allData$date, allData$predGompertz,  col="green")
legend("topleft", 
       legend = c("Actual","Bass", "Logistic", "Gompertz"), 
       col = c("black",
               "red", 
               "blue",
               "green"),
       pch = c("_","_","_","_"), 
       bty = "n", 
       pt.cex = 2, 
       cex = 1.2, 
       text.col = "black", 
       horiz = F , 
       inset = c(0.1, 0.1))
