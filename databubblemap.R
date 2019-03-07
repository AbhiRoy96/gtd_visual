library(maps)
library(ggplot2)
library(tidyverse)
library(viridis)


# add the csv
gtdData <- read.csv("C:/Users/dell/Desktop/eventsGTD.csv")
dim(gtdData)

# reverse the order of names as the csv contains the names in decending order
new_dd <- gtdData%>% arrange(rev(rownames(.)))
new_dd

# blank map
# map('world',col="#f2f2f2", fill=TRUE, bg="white", lwd=0.05, mar=rep(0,4),border=0, ylim=c(-80,80) )


# trying to plot a basic map 
# map('world',col="#f2f2f2", fill=TRUE, bg="white", lwd=0.05,mar=rep(0,4),border=0, ylim=c(-80,80) )
# points(x=new_dd$longitude, y=new_dd$latitude, col="slateblue", cex=2, pch=20)
# text(new_dd$city, x=new_dd$longitude, y=new_dd$latitude,  col="slateblue", cex=1, pos=4)


# loading the map

worldf <- map_data("world")


# basic plot without the options ~~~ bubble plot

ggplot() +
  geom_polygon(data = worldf, aes(x=long, y = lat, group = group), fill="#001a33", alpha=0.4) +
  geom_point( data=new_dd, aes(x=longitude, y=latitude, size=count, color=count), alpha=0.3) +
  scale_size_continuous(range=c(1,25)) +
  scale_color_viridis(option="inferno", trans="log", direction=-1) +
  theme_void() + ylim(-70,85) + coord_map(xlim=c(-180,180)) + theme(legend.position="none")




# Plot with all features

# ggplot() +
#   geom_polygon(data = worldf, aes(x=long, y = lat, group = group), fill="#001a33", alpha=0.7) +
#   geom_point( data=new_dd, aes(x=longitude, y=latitude, size=count, color=count, alpha=count), shape=20, stroke=FALSE) +
#   scale_size_continuous(name="Attacks", trans="log", range=c(1,15)) +
#   scale_alpha_continuous(name="Attacks", trans="log", range=c(0.1, .9)) +
#   scale_color_viridis(option="inferno", trans="log", name="Attacks", direction=1) +
#   theme_void() + ylim(-70,85) + coord_map(xlim=c(-180,180)) + 
#   guides( colour = guide_legend()) +
#   theme(
#     legend.position = "none",
#     text = element_text(color = "#22211d"),
#     plot.background = element_rect(fill = "black", color = NA), 
#     panel.background = element_rect(fill = "#f5f5f2", color = NA), 
#     legend.background = element_rect(fill = "#f5f5f2", color = NA),
#     plot.title = element_text(size= 16, hjust=0.1, color = "#4e4d47", margin = margin(b = -0.1, t = 0.4, l = 2, unit = "cm")),
#   )
