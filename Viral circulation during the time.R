getwd()

library(dplyr)
library(ggplot2)
library(lubridate)
library(tidyr)

data <- read.csv("C:/Users/willi/OneDrive/Desktop/Poster_Thesis_Data_Base - Copy.csv", sep = ";")

data$Date_Sample_Collection <- as.Date(data$Date_Sample_Collection)

data$Month <- format(data$Date_Sample_Collection, "%Y-%m")

data_viruses <- data %>%
  select(Month, RV, SARS_CoV_2, RSV_A, RSV_B, MPV, PIV_1, PIV_2, PIV_3, AdV_B, AdV_C, AdV_E)

data_sum <- data_viruses %>%
  group_by(Month) %>%
  summarise(across(everything(), ~sum(.x, na.rm = TRUE)))


data_long <- pivot_longer(data_sum, cols = -Month, names_to = "Viruses", values_to = "Cases")

ggplot(data_long, aes(x = Month, y = Cases, color = Viruses, group = Viruses)) +
  geom_line() +
  labs(x = "Month", y = "Number of positive samples", title = "Viral circulation") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
