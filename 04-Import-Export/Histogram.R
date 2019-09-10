library(tidyverse)
library(plotly)

Histogram <- function(data, column){
  p <- ggplot(data) +
    geom_histogram(aes(get(column)), color = "white", fill = "black") +
    theme_dark()
  ggplotly(p)
}
