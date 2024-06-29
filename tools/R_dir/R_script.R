###########################
### Build & Earn graphs ###
###########################
# This R script reads CSV files saved weekly and creates a line graph for each project, with the amount staked during the ‘Build&Earn’ period as the Y-axis.”


library(dplyr)
library(ggplot2)

# The csv file to be read is the save directory
# (Note) The archive must be deployed in advance.
setwd("../store/save")

extract_date_from_filename <- function(filename) {
  date_str <- substr(filename, 1, 8)
  formatted_date <- format(as.Date(date_str, format = "%Y%m%d"), "%Y-%m-%d")
  return(formatted_date)
}

read_csv_and_extract_date <- function(filename) {
  data <- read.csv(filename, header = TRUE)
  data$date <- extract_date_from_filename(filename)
  return(data)
}

file_list <- list.files(pattern = "*-data.csv")

df_total <- data.frame()

for (x in file_list){
  df_new <- read_csv_and_extract_date(x)
  df_total <- rbind(df_total,df_new)
}

df_total$date <- as.Date(df_total$date)

filtered_data <- df_total
# filtered_data <- subset(df_total, TotalStaked < 1500000) # < Tier4
# filtered_data <- subset(df_total, TotalStaked < 15000000) # < Tier3
# filtered_data <- subset(df_total,  TotalStaked > 1500000 & TotalStaked < 15000000) # = Tier4
# filtered_data <- subset(df_total,  TotalStaked > 15000000 & TotalStaked < 50000000) # = Tier3
# filtered_data <- subset(df_total,  TotalStaked > 50000000 & TotalStaked < 200000000) # = Tier2
# filtered_data <- subset(df_total,  TotalStaked > 200000000 ) # = Tier1
# filtered_data <- subset(df_total,  TotalStaked > 200000000 )


# Create graph
ggplot(filtered_data, aes(x = date, y = BuildAndearn, group = Name, color = Name)) +
  geom_line(size = 1) +
  theme_minimal() +
  labs(title = 'Time-series line graph by Project',
       x = 'DATE',
       y = 'BuildAndEarn') +
  scale_color_viridis_d() +
  scale_y_continuous(
    labels = scales::comma,
    limits = c(0, 110000000), 
    breaks = seq(0, 110000000, by = 5000000) 
    ) + 
  theme(legend.position = 'right')
