library(dagitty)
library(ggdag)
library(tidyverse)
dagify(y ~ x + a ,
       x ~ a,
       b ~ y + x,
       coords = list(x = c(x = 1, y = 2, a = 1.5, b = 1.5, c = 1, d = 2, m = 1.5), y = c(x=1, y = 1,  a = 2, b = 0, c = 2, d= 2, m = 1))
) %>% 
  tidy_dagitty() %>%
  #mutate(fill = ifelse(name == "a", "Collider", "variables of interest")) %>% 
  ggplot(aes(x = x, y = y, xend = xend, yend = yend)) + 
  geom_dag_point(size=7, 
                 #aes(color = fill)
  ) + 
  geom_dag_edges(show.legend = FALSE)+
  geom_dag_text() +
  theme_dag() +
  theme(legend.title  = element_blank(),
        legend.position = "top") #+
#  annotate("text", x = 0.8, y = c(0, 1, 2), label = c("lower", "middle", "upper"))
ggsave("dag_exercise.png", width=4, height=2)
