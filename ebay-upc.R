library(rvest)
library(magrittr)
require(RSelenium)

setwd("/Users/ploid/GitHub/ebay-to-amazon")

remDr <- remoteDriver(browserName = "chrome")
remDr$open()

web.page <- "http://www.ebay.com/itm/Prime-Line-Products-M-6192-Shower-Door-Bottom-Guide-Pack-of-2-Gray-AOI-/291827713460?hash=item43f24985b4:g:nhMAAOSwtnpXldpL"

remDr$navigate(web.page)
element <- remDr$findElement(using = 'css', "[itemprop='gtin13']")
element.length <- length(remDr$findElement(using = 'css', "[itemprop='gtin13']"))
element.text <- element$getElementText()

