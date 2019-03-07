download.file("http://thematicmapping.org/downloads/TM_WORLD_BORDERS_SIMPL-0.3.zip" , destfile="world_shape_file.zip")
system("unzip world_shape_file.zip")


library(dplyr)
library(leaflet)
library(rgdal)
library(viridis)

# reading the downloaded geoJson
world_spdf=readOGR( dsn= getwd() , layer="TM_WORLD_BORDERS_SIMPL-0.3")

# Look at the info provided with the geospatial object
head(world_spdf@data)

# provided CSV file
gtdData <- read.csv("C:/Users/dell/Desktop/eventsGTDCountries.csv")
head(gtdData)

# creating subset to rename column
sb_gtd <- gtdData %>%
  rename(NAME=country)
#sb_gtd

# merging the 2 datasets on NAME
world_spdf@data <- left_join(world_spdf@data, sb_gtd, by="NAME")
head(world_spdf@data)

# removing NA to 0
world_spdf@data$count[ which(is.na(world_spdf@data$count))] = 0


# range of data
# 0-10	      60
# 10-50	      29
# 50-100	    9
# 100-1000	  24
# 1000-7000	  13
# 7000+ 	    1


# creating Palatte
# Create a color palette with handmade bins.
mybins=c(0,10,50,100,1000,7000,Inf)
pal = colorBin( palette="YlOrRd", domain=world_spdf@data$count, na.color="transparent", bins=mybins)

# creating Palatte ~ DEFAULT 
# pal <- colorNumeric(palette="viridis", domain=world_spdf@data$count, na.color="transparent")


# creating popup
# popup_sb <- paste0("Attacks: ", as.character(world_spdf@data$count))
popup_sb <- paste0("Country: ", world_spdf@data$NAME,"<br/>", "Terror Attacks: ", round(world_spdf@data$count, 2), sep="") %>%
  lapply(htmltools::HTML)




# creating th map plot
leaflet() %>% 
   addProviderTiles("CartoDB.Positron") %>%
   setView( lat=10, lng=0 , zoom=2) %>%
   addPolygons(data=world_spdf,
               fillColor=~pal(world_spdf@data$count),
               fillOpacity=.9,
               weight=.2,
               smoothFactor=.2,
               highlight = highlightOptions(
                  weight = 2,
                  color = "#666",
                  fillOpacity = 0.7,
                  bringToFront = TRUE),
               label=popup_sb,
               #  popup=~popup_sb
               labelOptions = labelOptions(
    style = list("font-weight" = "normal", padding = "3px 8px"),
    textsize = "15px",
    direction = "auto"))  %>%
  addLegend(pal = pal, 
            values = world_spdf@data$count, 
            position = "bottomleft", 
            title = "Terror Attacks<br />2014 - 2017")


 






