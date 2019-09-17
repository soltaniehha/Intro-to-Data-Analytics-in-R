# install.packages("quantmod")

library(quantmod)
library(tidyverse)

# set dates
start <- Sys.Date() - 6000
end   <- Sys.Date()

getSymbols(c("AAPL", "GOOG", "AMZN", "BABA"), src = "yahoo", 
           from = start, to = end)

class(AAPL)
head(AAPL)

# ###########################
# Visualization with quantmod

# candlesticks
chartSeries(AAPL, up.col = "black", dn.col = "red", theme = "white", 
            subset = "2019-01-01/")
addSMA(n = 20)
addSMA(n = c(20, 50))
#addSMA(n = c(20, 50, 200))

# line plot
chartSeries(AAPL, up.col = "black", dn.col = "red", theme = "white", 
            subset = "2019-01-01/", type = "line")
addSMA(n = 20)

# ###########################
# Visualization with ggplot2
# Get date from tidyquant

# install.packages("tidyquant")
library(tidyquant)

# Get the data
mult_stocks <- tq_get(c("AAPL", "GOOG", "AMZN", "BABA"), 
                      from = start, to = end)
# spread
mult_stocks %>% 
  select(date, symbol, close) %>% 
  spread(key = symbol, value = close) -> stocks 

# AMZN vs. GOOG
ggplot(stocks, aes(x = date)) +
  geom_line(aes(y = AMZN, color = "AMZN")) +
  geom_line(aes(y = GOOG, color = "GOOG")) +
  scale_color_manual("", 
                     breaks = c("AMZN", "GOOG"),
                     values = c("orange", "blue"))

# AMZN vs. BABA
# different scales
ggplot(stocks, aes(x = date)) +
  geom_line(aes(y = AMZN, color = "AMZN"), alpha = 1/2) +
  geom_line(aes(y = BABA*10, color = "BABA"), alpha = 1/2) +
  scale_y_continuous(sec.axis = sec_axis(~.  /10, name = "BABA")) +
  scale_color_manual("", 
                     breaks = c("AMZN", "BABA"),
                     values = c("orange", "purple"))

# directly from mult_stocks
mult_stocks %>% filter(symbol %in% c("AMZN", "GOOG")) %>% 
  ggplot() +
  geom_line(aes(x = date, y = close, color = symbol))

# ##############################
# Plotting with forecast package

# install.packages("forecast")
library(forecast)

# WWWusage: A time series of the numbers of users connected to the Internet through a server every minute.
WWWusage %>%
  Arima(order=c(3,1,0)) %>%
  forecast(level = c(95), h=5) %>%
  autoplot

# AirPassengers: Monthly totals of international airline passengers, 1949 to 1960.
d.arima <- auto.arima(AirPassengers)
d.forecast <- forecast(d.arima, level = c(95), h = 50)
autoplot(d.forecast)

# Fit model to first few years of AirPassengers data
air.model <- Arima(window(AirPassengers, end = 1956+11/12), order=c(0,1,1),
                   seasonal = list(order=c(0,1,1), period=12), lambda=0)
plot(forecast(air.model, h=48))
lines(AirPassengers)

# AAPL
xts(stocks$AAPL, order.by=stocks$date) %>%
  auto.arima %>%
  forecast(h=200) %>%
  autoplot
