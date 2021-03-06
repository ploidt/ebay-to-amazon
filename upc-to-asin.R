library(rvest)
library(magrittr)
require(RSelenium)
library(beepr)

setwd("/Users/ploid/GitHub/ebay-to-amazon/data")
remDr <- remoteDriver(browserName = "chrome")
remDr$open()

web.page = "https://www.amazon.com/s/ref=nb_sb_noss?url=search-alias%3Daps&field-keywords="
read.file.name <- "ebay_combined.csv"

dataset <- read.csv(read.file.name,header=TRUE)
dataset <- dataset[ , !(names(dataset) %in% "X")]

get.asin <- function(link){
  remDr$navigate(link)
  web.html <- read_html(remDr$getPageSource()[[1]])
  
  product <- web.html %>%
    html_node(".s-result-item")
  
  asin <- product %>%
    html_attr("data-asin")
}

asin <- rep(NA,nrow(dataset))

for(i in 1:nrow(dataset)){
  link <- paste(web.page, dataset$upc[i], sep = "")
  asin[i] <- get.asin(link)
  if((i %% 20) == 0){
    print(i)
    dataset$asin <- asin
    file.name <- paste("ebay_asin_",i,".csv")
    write.csv(dataset, file = file.name)
  }
}

dataset$asin <- asin
write.csv(dataset, file = "ebay_final.csv")

remDr$close()
dataset %>% View()
beep()