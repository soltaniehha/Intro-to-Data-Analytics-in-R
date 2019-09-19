Churn_vs_var_plot <- function(df, var, legend=F){
  # Plots a bar chart showing churn, faceting by var
  #
  # Args:
  #   df: churn dataframe
  #   var: variable to be used for faceting
  #   legend: whether to include a legend or not
  #
  # Returns:
  #   A ggplot object which is a bar chart
  select(df, Churn, var = var) %>% 
    group_by(var, Churn) %>%
    summarise(n = n()) %>% 
    mutate(percentage = paste0(round(n/sum(n)*100, 1), "%")) %>% 
    ggplot(aes(x = Churn, y = n, group = var, fill = Churn)) + 
    geom_bar(stat="identity", show.legend = legend, alpha = 2/3) +
    labs(y = "Count", x = var) +
    geom_text(aes(label = percentage), vjust = 1) +
    facet_grid(~var) +
    scale_fill_manual( values = c("#37bf49", "#c40505")) +
    theme_minimal()
}

# Multiple graphs on one page (ggplot2)
# http://www.cookbook-r.com/Graphs/Multiple_graphs_on_one_page_(ggplot2)
#
#
# ggplot objects can be passed in ..., or to plotlist (as a list of ggplot objects)
# - cols:   Number of columns in layout
# - layout: A matrix specifying the layout. If present, 'cols' is ignored.
#
# If the layout is something like matrix(c(1,2,3,3), nrow=2, byrow=TRUE),
# then plot 1 will go in the upper left, 2 will go in the upper right, and
# 3 will go all the way across the bottom.
#
multiplot <- function(..., plotlist=NULL, cols=1, layout=NULL) {
  library(grid)
  
  # Make a list from the ... arguments and plotlist
  plots <- c(list(...), plotlist)
  
  numPlots = length(plots)
  
  # If layout is NULL, then use 'cols' to determine layout
  if (is.null(layout)) {
    # Make the panel
    # ncol: Number of columns of plots
    # nrow: Number of rows needed, calculated from # of cols
    layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                     ncol = cols, nrow = ceiling(numPlots/cols))
  }
  
  if (numPlots==1) {
    print(plots[[1]])
    
  } else {
    # Set up the page
    grid.newpage()
    pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))
    
    # Make each plot, in the correct location
    for (i in 1:numPlots) {
      # Get the i,j matrix positions of the regions that contain this subplot
      matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))
      
      print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                      layout.pos.col = matchidx$col))
    }
  }
}