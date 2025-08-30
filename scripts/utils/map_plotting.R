install.packages("psych")
install.packages("dplyr")
install.packages("rstatix")
install.packages("ggplot2")
install.packages("magrittr")
library(psych) 
library(dplyr)
library(rstatix)
library(ggplot2)
library(magrittr)
library(e1071)
library("lattice")

# Load required packages
library(sf)
library(ggplot2)
library(dplyr)
library(readr)
library(ggspatial)


#-----------------------map plotting for installed wind capacity by county in ireland--------------

# Packages
library(sf)
library(ggplot2)
library(dplyr)
library(readr)
library(ggspatial)
library(ggrepel)
library(stringr)

# ---- Paths ----
shp_dir   <- "C:/Projects/GitHub/Ireland-energy-forecast/data/raw/gadm41_IRL_shp"
wind_csv  <- "C:/Projects/GitHub/Ireland-energy-forecast/data/processed/Aggregated_Wind_Capacity_By_County.csv"
out_png   <- "C:/Projects/GitHub/Ireland-energy-forecast/outputs/figures/wind_capacity_map_final_clean.png"

# ----  Load & clean shapefile ----
ireland_map <- st_read(shp_dir, layer = "gadm41_IRL_1") %>%
  mutate(NAME_1 = tolower(trimws(NAME_1)),
         NAME_1 = ifelse(NAME_1 == "na", "cork", NAME_1))

# ---- Load & clean wind capacity data ----
agg_data <- read_csv(wind_csv, show_col_types = FALSE) %>%
  mutate(County = tolower(trimws(County)))

# ---- Join map with capacity and keep counties that have data ----
county_capacity <- ireland_map %>%
  left_join(agg_data, by = c("NAME_1" = "County")) %>%
  filter(!is.na(Installed_MW)) %>%
  st_as_sf()

# ---- % share label (by visible counties) ----
county_capacity <- county_capacity %>%
  mutate(Share_Label = paste0(str_to_title(NAME_1), " (",
                              round(Installed_MW / sum(Installed_MW) * 100, 1), "%)"))

# ---- Compute label/bubble coordinates safely in a projected CRS ----
county_cap_2157 <- st_transform(county_capacity, 2157)
pts_2157        <- st_point_on_surface(county_cap_2157)

# Bring points back to WGS84 and extract coords
pts_wgs84 <- st_transform(pts_2157, 4326)
coords    <- st_coordinates(pts_wgs84)

# Build a simple df for plotting (no sf geometry in aesthetics)
bubble_df <- county_capacity %>%
  st_drop_geometry() %>%
  mutate(X = coords[, 1],
         Y = coords[, 2],
         label = Share_Label) %>%
  # small manual nudge for cork
  mutate(X = ifelse(NAME_1 == "cork", X - 0.25, X),
         Y = ifelse(NAME_1 == "cork", Y + 0.15, Y))

# ---- Plot ----
p <- ggplot() +
  # Base map
  geom_sf(data = ireland_map, fill = "#f5f5f5", color = "gray80", size = 0.3) +
  
  # Bubbles
  geom_point(data = bubble_df,
             aes(x = X, y = Y, size = Installed_MW),
             shape = 21, fill = "#00b4a2", color = "#00b4a2",
             alpha = 0.85, stroke = 0) +
  
  # Labels
  geom_text_repel(data = bubble_df,
                  aes(x = X, y = Y, label = label),
                  size = 3.2, fontface = "bold", color = "black",
                  max.overlaps = 50, box.padding = 0.4, family = "sans") +
  
  # Map ornaments
  annotation_scale(location = "bl", width_hint = 0.25, pad_y = unit(-1, "lines")) +
  annotation_north_arrow(location = "tl", which_north = "true",
                         style = north_arrow_fancy_orienteering()) +
  
  # ---- Titles & theme----
  labs(
    title = "Installed Wind Capacity by County in Ireland",
    subtitle = "Bubble size represents installed export capacity (MW)",
    caption = "Data source: SEAI & GADM",
    size = "Export Capacity (MW)",
    x = "Longitude", y = "Latitude"
  ) +
  scale_size_continuous(range = c(3, 10), breaks = c(30, 60, 90)) +
  theme_minimal(base_size = 12) +
  theme(
    panel.grid = element_blank(),
    panel.background = element_rect(fill = "white", color = NA),
    plot.background  = element_rect(fill = "white", color = NA),
    plot.title       = element_text(face = "bold", size = 14),
    plot.subtitle    = element_text(size = 11),
    plot.caption     = element_text(size = 8.5, hjust = 0.5, margin = margin(t = 10)),
    legend.position  = "top",
    legend.spacing.x = unit(0.6, 'cm'),
    plot.margin      = margin(10, 50, 50, 30)
  ) +
  coord_sf(expand = FALSE)

# Draw it
print(p)

# ----  Save (uncomment to write file) ----
 ggsave(filename = out_png, plot = p, device = "png",
     width = 8, height = 10, units = "in", dpi = 300)



  
#--------------------map plotting for installed solar capacity by county in ireland--------------------

library(sf)
library(ggplot2)
library(dplyr)
library(readr)
library(ggspatial)
library(ggrepel)
library(stringr)
library(scales)

# --- Paths ---
shapefile_path <- "C:/Projects/GitHub/Ireland-energy-forecast/data/raw/gadm41_IRL_shp"
solar_csv      <- "C:/Projects/GitHub/Ireland-energy-forecast/data/processed/Aggregated_Solar_Capacity_By_County.csv"
out_png        <- "C:/Projects/GitHub/Ireland-energy-forecast/outputs/figures/solar_capacity_map_final_clean.png"

# --- Style (match wind map) ---
BUBBLE_COL <- "#ff9800"  # keep teal to match wind; use "#ff9800" if you prefer orange

# Shapefile
ireland_map <- st_read(shapefile_path, layer = "gadm41_IRL_1", quiet = TRUE) %>%
  mutate(NAME_1 = tolower(trimws(NAME_1)),
         NAME_1 = ifelse(NAME_1 == "na", "cork", NAME_1))

# Solar capacity CSV (NOTE: uses Total_MW)
agg_data <- read_csv(solar_csv, show_col_types = FALSE) %>%
  mutate(
    County    = tolower(trimws(County)),
    Longitude = as.numeric(Longitude),
    Latitude  = as.numeric(Latitude),
    Total_MW  = as.numeric(Total_MW)
  )

#  Merge map + data
county_capacity <- ireland_map %>%
  left_join(agg_data, by = c("NAME_1" = "County")) %>%
  filter(!is.na(Total_MW)) %>%
  st_as_sf()

#  % share labels
county_capacity <- county_capacity %>%
  mutate(Share_Label = paste0(str_to_title(NAME_1), " (", round(Total_MW / sum(Total_MW) * 100, 1), "%)"))

#  Bubble points from provided lon/lat
bubble_data <- county_capacity %>%
  st_drop_geometry() %>%
  select(NAME_1, Share_Label, Longitude, Latitude, Total_MW) %>%
  st_as_sf(coords = c("Longitude", "Latitude"), crs = 4326) %>%
  mutate(label = Share_Label)

# --- Bubble points from provided lon/lat ---
bubble_data <- county_capacity |>
  st_drop_geometry() |>
  select(NAME_1, Share_Label, Longitude, Latitude, Total_MW) |>
  st_as_sf(coords = c("Longitude", "Latitude"), crs = 4326)

# Add label text
bubble_data$label <- bubble_data$Share_Label


idx_cork <- bubble_data$NAME_1 == "cork"
if (any(idx_cork)) {
  st_geometry(bubble_data)[idx_cork] <- st_geometry(bubble_data)[idx_cork] + c(-0.25, 0.15)
}

# Nice legend break
brks <- pretty(range(bubble_data$Total_MW, na.rm = TRUE), n = 3)

# Plot
p <- ggplot() +
  geom_sf(data = ireland_map, fill = "#f5f5f5", color = "gray80", size = 0.3) +
  geom_sf(data = bubble_data, aes(size = Total_MW), shape = 21,
          fill = "#ff9800", color = "#ff9800", alpha = 0.85, stroke = 0) +
  geom_text_repel(
    data = bubble_data |> cbind(st_coordinates(bubble_data)),
    aes(x = X, y = Y, label = label),
    size = 3.2, fontface = "bold", color = "black",
    max.overlaps = 50, box.padding = 0.4
  ) +
  annotation_scale(location = "bl", width_hint = 0.25, pad_y = unit(-1, "lines")) +
  annotation_north_arrow(location = "tl", which_north = "true",
                         style = north_arrow_fancy_orienteering()) +
  labs(
    title    = "Installed Solar Capacity by County in Ireland",
    subtitle = "Bubble size represents installed capacity (MW)",
    caption  = {
      top5 <- county_capacity |>
        arrange(desc(Total_MW)) |> slice(1:5) |>
        mutate(txt = paste0(stringr::str_to_title(NAME_1), ": ",
                            round(Total_MW / sum(county_capacity$Total_MW) * 100, 1), "%")) |>
        pull(txt)
      paste("Data source: SEAI & GADM | Top 5 Counties –", paste(top5, collapse = " | "))
    },
    size = "Capacity (MW)",
    x = "Longitude", y = "Latitude"
  ) +
  scale_size_continuous(range = c(3, 10), breaks = brks) +
  theme_minimal(base_size = 12) +
  theme(
    panel.grid       = element_blank(),
    panel.background = element_rect(fill = "white", color = NA),
    plot.background  = element_rect(fill = "white", color = NA),
    plot.title       = element_text(face = "bold", size = 14),
    plot.subtitle    = element_text(size = 11),
    plot.caption     = element_text(size = 8.5, hjust = 0.5, margin = margin(t = 10)),
    legend.position  = "top",
    legend.spacing.x = unit(0.6, 'cm'),
    plot.margin      = margin(10, 50, 50, 30)
  ) +
  coord_sf(expand = FALSE)

print(p)

ggsave(
  "C:/Projects/GitHub/Ireland-energy-forecast/outputs/figures/solar_capacity_map_final_clean.png",
  p, device = "png", type = "cairo", width = 8, height = 10, units = "in", dpi = 300
)