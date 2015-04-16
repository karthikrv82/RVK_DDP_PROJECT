
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(quantmod)

nyse <- read.delim("data/NYSE.txt")
stocks <- head(levels(nyse$Description),100)


nyse <- read.delim("data/NYSE.txt")

shinyServer(function(input, output) {
        output$P1StockList <- renderUI({
                
                DDL <- vector("list",input$p1count)
                for( i in 1:input$p1count){
                        DDL[i] <- list(selectInput(inputId = paste0("p1s",i), label = h5(paste0("Stock ",i)),choices = stocks,selected=stocks[i]))
                }
                return(DDL)        
                
        })
        
        output$P1WeightList <- renderUI({
                
                DS <- vector("list",input$p1count)
                for( i in 1:input$p1count){
                        DS[i] <- list(sliderInput(inputId = paste0("p1w",i), label = h5(paste0("Stock ",i," Weight")),min = 0, max = 100, value = 100/input$p1count,round=TRUE, post="%", step=5))
                }
                return(DS)        
                
        })
        
        output$P2StockList <- renderUI({
                DDL <- vector("list",input$p2count)
                for( i in 1:input$p2count){
                        DDL[i] <- list(selectInput(inputId = paste0("p2s",i), label = h5(paste0("Stock ",i)),choices = stocks,selected=stocks[i+1]))
                }
                return(DDL)        
        })
        
        output$P2WeightList <- renderUI({
                
                DS <- vector("list",input$p2count)
                for( i in 1:input$p2count){
                        DS[i] <- list(sliderInput(inputId = paste0("p2w",i), label = h5(paste0("Stock ",i," Weight")),min = 0, max = 100, value = 100/input$p2count,round=TRUE, post="%", step=5))
                }
                return(DS)        
                
        })
        
        
        P1Weights <- reactive({
                
                p1weights <- array()
                
                
                for ( i in 1:input$p1count){
                        p1weights[i] <-  input[[paste0("p1w", i)]]
                }
                return(p1weights)
        })
        
        P2Weights <- reactive({
                
                p2weights <- array()
                
                
                for ( i in 1:input$p2count){
                        p2weights[i] <-  input[[paste0("p2w", i)]]
                }
                return(p2weights)
        })
        
        Portfolio1Summary <- eventReactive(input$compare,{
                
                p1stocks <- array()
                p1symbols <- array()
                p1weights <- P1Weights()
                
                if ( sum(p1weights) < 99 || sum(p1weights) > 100){
                        p1weights[] <- 100/input$p1count
                }
                
                for ( i in 1:input$p1count){
                        p1stocks[i] <-  input[[paste0("p1s", i)]]
                        p1symbols[i] <- as.character(subset(nyse,nyse$Description %in% p1stocks[i])$Symbol)
                        
                }
                
                
                p1StockReturns <- list()
                p1MeanStockReturns <- list()
                
                
                
                for (i in 1:length(p1symbols)){
                        p1StockReturns[[i]]<- tail(allReturns(getSymbols(p1symbols[i],auto.assign=F) ),input$days)
                        p1MeanStockReturns[[i]] <- colMeans(p1StockReturns[[i]][],na.rm=T) 
                        
                }
                
                
                p1MeanReturn <- data.frame(
                        Daily=numeric(),
                        Weekly=numeric(),
                        Monthly=numeric(),
                        Quarterly=numeric(),
                        Yearly=numeric()
                )
                
                
                for ( i in 1:input$p1count){
                        
                        p1MeanReturn <- rbind(p1MeanReturn,setNames(as.list(p1MeanStockReturns[[i]]*p1weights[i]/100), names(p1MeanReturn)))
                        
                }
                rownames(p1MeanReturn)<-p1stocks
                
                
                p1ExpectedReturn <-data.frame("Portfolio 1 Expected Return"=c(colSums(p1MeanReturn)*100))
                colnames(p1ExpectedReturn) <- c("Portfolio 1 Expected Return")
                
                
                return(p1ExpectedReturn)
                
                
        })
        
        
        Portfolio2Summary <- eventReactive(input$compare,{
                
                p2stocks <- array()
                p2symbols <- array()
                p2weights <- P2Weights()
                
                if ( sum(p2weights) < 99 || sum(p2weights) > 100){
                        p2weights[] <- 100/input$p2count
                }
                
                for ( i in 1:input$p2count){
                        p2stocks[i] <-  input[[paste0("p2s", i)]]
                        p2symbols[i] <- as.character(subset(nyse,nyse$Description %in% p2stocks[i])$Symbol)
                        
                }
                
                p2StockReturns <- list()
                p2MeanStockReturns <- list()
                
                
                
                for (i in 1:length(p2symbols)){
                        p2StockReturns[[i]]<- tail(allReturns(getSymbols(p2symbols[i],auto.assign=F) ),input$days)
                        p2MeanStockReturns[[i]] <- colMeans(p2StockReturns[[i]][],na.rm=T) 
                        
                }
                
                
                p2MeanReturn <- data.frame(
                        Daily=numeric(),
                        Weekly=numeric(),
                        Monthly=numeric(),
                        Quarterly=numeric(),
                        Yearly=numeric()
                )
                
                
                for ( i in 1:input$p2count){
                        
                        p2MeanReturn <- rbind(p2MeanReturn,setNames(as.list(p2MeanStockReturns[[i]]*p2weights[i]/100), names(p2MeanReturn)))
                        
                }
                rownames(p2MeanReturn)<-p2stocks
                
                
                p2ExpectedReturn <-data.frame("Portfolio 2 Expected Return"=c(colSums(p2MeanReturn)*100))
                colnames(p2ExpectedReturn) <- c("Portfolio 2 Expected Return")
                
                return(p2ExpectedReturn)
                
                
        })
        
        output$p1Summary <- eventReactive(input$compare,{
                "Portfolio 1 Summary"
        })
        
        output$p2Summary <- eventReactive(input$compare,{
                "Portfolio 2 Summary"
        })
        
        output$portfolio1Table <- renderTable({
                
                p1MeanSummary <- Portfolio1Summary()
                p1MeanSummary$"Portfolio 1 Expected Return" <- paste0(round(p1MeanSummary$"Portfolio 1 Expected Return",2)," %")
                return(p1MeanSummary)
                
        })
        
        output$portfolio2Table <- renderTable({
                p2MeanSummary <- Portfolio2Summary()
                p2MeanSummary$"Portfolio 2 Expected Return" <- paste0(round(p2MeanSummary$"Portfolio 2 Expected Return",2)," %")
                return(p2MeanSummary)
        })
        
        P1defaultweights <- eventReactive(input$compare,{
                p1weights <- P1Weights()
                if(sum(p1weights)<99||sum(p1weights)>100){
                        return("Portfolio 1 Stock Weights not totaling 100%. Using equal Stock Weights for Portfolio 1")
                }
                
        })
        
        output$p1defaultweights <- renderText({
                P1defaultweights()
        })
        
        P2defaultweights <- eventReactive(input$compare,{
                p2weights <- P2Weights()
                if(sum(p2weights)<99||sum(p2weights)>100){
                        return("Portfolio 2 Stock Weights not totaling 100%. Using equal Stock Weights for Portfolio 2")
                }
                
        })
        
        output$p2defaultweights <- renderText({
                P2defaultweights()
        })
        
})