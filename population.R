setwd("C:/Users/Asus/OneDrive/Documents/")
data <- read.csv("population_state.csv")

install.packages("ggplot2")
library(ggplot2)
install.packages("gridExtra")
library(gridExtra)
install.packages("dplyr")
library(dplyr)
install.packages("reshape2")
library(reshape2)

print(data)

install.packages("janitor")
library(janitor)

data2 <- clean_names(data)
print(data2)

data3 <- remove_empty(data2, which = c("rows","cols"), quiet = FALSE)
print(data3)

data_cleaned <- distinct(data3)
print(data_cleaned)

data <- read.csv("population_state.csv")

str(data)

summary(data)

#Q1
# Separate year from date
data$year <- format(as.Date(data$date), "%Y")

# Subset the data for Penang and specified year
penang_data <- subset(data, year %in% c("2020","2021","2022","2023"))

if (!requireNamespace("plotly", quietly = TRUE)) {
  install.packages("plotly")
}
library(plotly)

penang_data_subset <- subset(penang_data, year %in% c(2020, 2021, 2022, 2023) )

penang <- subset(population, State == "Penang", select = c("Year", "Ethnicity", "Sex", "Age"))

# Create a new plot object
plot <- ggplot(penang_data, aes(x = Age, y = Population, fill = Ethnicity)) +
  geom_bar(stat = "identity", position = "dodge") +
  facet_grid(rows = vars(Sex), cols = vars(Year)) +
  labs(title = "Population of Penang by Ethnicity, Gender, and Age Group",
       x = "Age Group", y = "Population")

# Display the plot
plot

fig <- plot_ly(
  data = penang_data_subset,
  x = ~interaction(ethnicity, sex, age),
  y = ~population,
  type = "bar",
  color = ~ethnicity,
  colors = RColorBrewer::brewer.pal(4, "Set1"),
  hoverinfo = "text",
  text = ~paste("Ethnicity: ", ethnicity, "<br>Sex: ", sex, "<br>Age : ",)
)

fig %>% layout(layout)
