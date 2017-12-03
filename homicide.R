library(rvest)
library(dplyr)
library(tidyr)
library(ggplot2)

### save the url in page
page<-"https://en.wikipedia.org/wiki/List_of_U.S._states_by_homicide_rate"

###read the html, get the table node, and convert the node into a dataframe
homicide<-page %>%
  read_html() %>%
  html_node("table")%>%
  html_table()


###clean dataset
homicide2<-homicide %>% 
  gather(2:7, key="year", value="homicide_rate")



###create maps
library(stringr)
library(ggplot2)

###read in the state map of US
map<-map_data("state")
###change the state variable to lowercase, so it can be merged to the map data frame
homicide2$State<-tolower(homicide2$State)
homicide_map<-right_join(x=map, y=homicide2, by=c("region"="State"))

ggplot(homicide_map, aes(x=long, y=lat, group=group, fill=homicide_rate))+
  geom_polygon(color="black")+
  scale_fill_gradient(low="beige", high="darkred")+
  facet_wrap(ncol=2,~(year))+
  labs(title="Homicide Rate by State over Time")+
  guides(fill=guide_legend("Homicides \n(Per 100,000)",reverse = TRUE))+
  theme_void()

