library(rvest)
library(magrittr)
require(RSelenium)

setwd("/Users/ploid/GitHub/ebay-to-amazon/data")

remDr <- remoteDriver(browserName = "chrome")
remDr$open()

web.page <- "http://www.ebay.com/sch/happytimesforever/m.html?_ipg=50&_sop=12&LH_Complete=1&LH_Sold=1&rt=nc&_trksid=p2046732.m1684"
start.page <- 1
end.page <- 3

for(i in seq(start.page, end.page, 1)){
  file.name <- paste("ebay2amazon_",i,".csv", sep = "")
  remDr$navigate(paste(web.page, "&_pgn=", i ,sep = ""))
  
  web.html <- read_html(remDr$getPageSource()[[1]])
  d = NULL
  
  get.all.info <- function(web.html){
    products <- web.html %>%
      html_nodes(".sresult")
    
    title.html <- products %>%
      html_node("h3")
    
    link <- title.html %>%
      html_node("a") %>%
      html_attr("href")
    
    title <- title.html %>%
      html_text(trim = TRUE)
    
    data <- data.frame(title, link, stringsAsFactors = FALSE)
  }
  
  temp <- get.all.info(web.html)
  d = rbind(d,temp)
  
  get.upc <- function(link){
    remDr$navigate(link)
    
    try(
      {
        element.length <- length(remDr$findElements(using = 'css', "[itemprop='gtin13']"))
        if(element.length != 0){
          element <- remDr$findElement(using = 'css', "[itemprop='gtin13']")
          element.text <- element$getElementText()
        }else{
          element.text <- NA
        }
      }
      )
    return(element.text)
  }
  
  get.stock <- function(link){
    product.html <- read_html(remDr$getPageSource()[[1]])
    try({
      element.length <- length(remDr$findElements(using = 'css', ".qtyTxt"))
      if(element.length != 0){
        stock <- product.html %>%
          html_nodes(".qtyTxt") %>%
          html_text(trim = TRUE) %>%
          gsub("\n","",.) %>%
          gsub("\t","",.)
      }else{
        stock <- NA
      }
    })
    
    return(stock)
  }
  
  upc <- rep(NA,nrow(d))
  stock <- rep(NA,nrow(d))
  
  for(i in 1:nrow(d)){
    upc[i] <- get.upc(d$link[i])
    stock[i] <- get.stock(d$link[i])
  }
  
  d$upc <- unlist(upc)
  d$stock <- unlist(stock)
  
  write.csv(d,file = file.name)
}

remDr$close()
d %>% View()

