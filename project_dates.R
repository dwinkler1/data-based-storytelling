library(dplyr)
library(kableExtra)
mytable_sub = data.frame(
    Component = c(
             "Preliminary story outline", 
             "Last coaching",
             "Website submission"
             ),
    Date = c(
      "Jan. 21",
      "Jan. 24",
      "Feb. 18"
    )
    )
#pander::pander(mytable_sub, keep.line.breaks = TRUE, style = 'grid', justify = 'left')
mytable_sub %>% kable(escape = T,  col.names = gsub("[_]", " ", names(mytable_sub))) %>%
  kable_paper(c("hover"), full_width = F) 