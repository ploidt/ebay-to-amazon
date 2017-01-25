library(beepr)

setwd("/Users/ploid/GitHub/ebay-to-amazon/data")
rm(dataset)
file.list <- list.files()

for(file in file.list) {
  if(!exists("dataset")){
    dataset <- read.csv(file,header=TRUE)
  }
  
  if(exists("dataset")){
    temp.dataset <- read.csv(file,header=TRUE)
    dataset <- rbind(temp.dataset,dataset)
    dataset <- unique(dataset)
    rm(temp.dataset)
  }
}
dataset <- dataset[complete.cases(dataset),]
dataset <- dataset[ , !(names(dataset) %in% "X")]
write.csv(dataset, file = "ebay_combined.csv")
beep()