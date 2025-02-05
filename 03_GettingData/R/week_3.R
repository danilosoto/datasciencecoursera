# Week 3 Quiz

# Question 1
# -----------------------------------------------------------------------------
# The American Community Survey distributes downloadable data about United States communities. Download the 2006 microdata survey about housing for the state of Idaho using download.file() from here: https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv and load the data into R. The code book, describing the variable names is here: https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf
#Create a logical vector that identifies the households on greater than 10 acres who sold more than $10,000 worth of agriculture products. Assign that logical vector to the variable agricultureLogical. Apply the which() function like this to identify the rows of the data frame where the logical vector is TRUE.

library(RCurl)
library(readr)
library(dplyr)

myurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
download.file(url=myurl, destfile="./Data/2006microdatasurvey.csv", method="curl")
df <- read_csv("./Data/2006microdatasurvey.csv")
glimpse(df)

df <- df %>% mutate(agricultureLogical=ifelse(ACR==3 & AGS == 6, TRUE, FALSE))
agricultureLogical <- as.vector(df$agricultureLogical)
which(agricultureLogical)

# Question 2
# -----------------------------------------------------------------------------
# Using the jpeg package read in the following picture of your instructor into R https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg Use the parameter native=TRUE. What are the 30th and 80th quantiles of the resulting data? (some Linux systems may produce an answer 638 different for the 30th quantile)

library(jpeg)
myurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg"
download.file(url=myurl, destfile = "./Data/jeff.jpeg")
pic <- readJPEG(source = "./Data/jeff.jpeg", native=TRUE)
quantile(pic, probs=0.3)
quantile(pic, probs=0.8)

# Question 3, 4 & 5
# -----------------------------------------------------------------------------
# Load the Gross Domestic Product data for the 190 ranked countries in this data set: https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv

# Load the educational data from this data set: https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv

# Match the data based on the country shortcode. How many of the IDs match? Sort the data frame in descending order by GDP rank (so United States is last). What is the 13th country in the resulting data frame?

gdpurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
edurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"

download.file(url=gdpurl, destfile = "./Data/gdp.csv")
download.file(url=edurl, destfile = "./Data/education.csv")

gdp <- read_csv("./Data/gdp.csv", skip=5, col_names = FALSE, n_max=190, col_types = "cicccccccc") %>% select(X1:X5, -X3) %>% rename(CountryCode=X1)
gdp$X5 <- gsub( "[^[:alnum:]-]", "", gdp$X5)
gdp$X5 <- as.numeric(gdp$X5)

edu <- read_csv("./Data/education.csv")
glimpse(edu)

df <- gdp %>% inner_join(edu) %>% arrange(desc(X2))
df[13,]

# What is the average GDP ranking for the "High income: OECD" and "High income: nonOECD" group?
df %>% group_by(`Income Group`) %>% summarise_each(funs(mean),X2)

# Cut the GDP ranking into 5 separate quantile groups. Make a table versus Income.Group. How many countries are Lower middle income but among the 38 nations with highest GDP?

df$RankingGroup <- cut(df$X2, breaks = 5)
table(df$RankingGroup, df$`Income Group`)
