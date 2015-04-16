
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)


nyse <- read.delim("data/NYSE.txt")
stocks <- head(levels(nyse$Description),100)
#rets <- allReturns(getSymbols("SBUX",auto.assign=FALSE) )

shinyUI(fluidPage(theme = "bootstrap.css",
        tabsetPanel(
                tabPanel("Portfolio Returns Compare App",
        titlePanel(title="",windowTitle = "Portfolio Returns Compare App"),
        h1("Portfolio Returns Compare App",align="center"),
        h5("(Access documentation from 'Usage Documentation' tab above)",align="center"),
                
        fluidRow(
                column(6,
                       h4("Portfolio 1 Details",align="center"),
                       numericInput("p1count", label = h5("No of Stocks"), value=2,min=1,max=4),
                       fluidRow(
                               column(6,
                                      uiOutput("P1StockList")
                               ),
                               column(6,
                                      uiOutput("P1WeightList")
                               )
                       )
                       
                ),
                column(6,
                       h4("Portfolio 2 Details",align="center"),
                       numericInput("p2count", label = h5("No of Stocks"), value=2,min=1,max=4),
                       fluidRow(
                               column(6,
                                      uiOutput("P2StockList")
                               ),
                               column(6,
                                      uiOutput("P2WeightList")
                               )
                       )
                )
        ),
        fluidRow(
                column(4),
                column(4,
                       numericInput("days",label = h5("Historical Returns to Consider (# of Days)"), value=90,min=30,max=365),
                       actionButton("compare", label = "Compute Summary"),
                       p("Click the button to Compute & update the value displayed in the Summary Details panel."),
                       h3("Summary Details",align="center")
                ),
                column(4)
        ),
                                
        fluidRow(
                
                column(6,align="right",textOutput("p1Summary")),
                column(6,align="left",textOutput("p2Summary"))
                
        ),
        fluidRow(
                column(3,align="center",textOutput("p1defaultweights")),
                column(3,align="center",tableOutput("portfolio1Table")),
                column(3,align="center",tableOutput("portfolio2Table")),
                column(3,align="center",textOutput("p2defaultweights"))
        )
),
tabPanel("Usage Documentation",
         h1("Introduction",style = "color:black"),
         p(h4("This App is a simple and easy to use tool to compare 2 Portfolios based on historical returns of the stocks in the Portfolio")),
         helpText("Note: This is just a prototype of the actual App. It has certain limitations that are described in the later part of this document",style="color:tomato"),
        h1("How to use the App?",style = "color:black"),
        p(h4("Usage of this App is self explanatory for the most part. Described below are the working of the App in terms of input and output, mentioning prototype limitations as appropriate")),
        h3("User Input",style = "color:green"),
        p(h4("For each of Portfolio 1 and Portfolio 2")),
        p(h4("(1) Select the No. of Stocks in the Portfolio")),
        helpText("Note: The prototype limits the number of stocks to a maximum of 4. This restriction will be removed in the final version",style = "color:tomato"),
        p(h4("(2) Select the Stocks from the drop down menu")),
        helpText(h5("** Appropriate number of dropdowns will be displayed based on No. of Stocks")),
        helpText("Note: Stock dropdown for the prototype includes only 100 stocks from NYSE. The full version will include options to select stocks from various exchanges without any limit on the number of stocks",style = "color:tomato"), 
        p(h4("For each of the Stocks in Portfolio 1 and Portfolio 2")),
        p(h4("(3) Select the Stocks Weights relative to Portfolio")),
        helpText(h4("Make sure that the Stock Weights Add up to 100%")),
        helpText("Note: Protype does not check wheter the stock weights add up to 100%. If they do not add up to 100%, it will assume equal stock weights for that Portfolio and continue. This will be addressed in the final version",style = "color:tomato"),
        p(h4("(4) Select the number of days of historical Stocks returns to consider to calculate Portfolio returns")),
        helpText("Note: The prototype limits the number of days to a minimum of 30 and a maximum of 365. This limitation will be addressed in the final version",style = "color:tomato"),
        p(h4(align="center","Once you have selected all the inputs, hit on 'Compute Summary' Button")),
          h3("Output",style="color:green"),
          p(h4("The Summary Details section displays the calculated Portfolio returns for Portfolio 1 and Portfolio 2")),
        p(h4("Output will be in the form of 2 tables, one each for Portfolio 1 and Portfolio 2")),
        p(h4("The tables display the Expected Return of the Portfolios with details of Daily, Weekly, Monthly, Quarterly and Yearly Returns")),
        h1("Interpreting the Output",style = "color:black"),
        h4("Based on [X] No of days of Daily, Weekly, Monthly, Quarterly and Yearly returns of the stocks in the Portfolio, the output displays the Daily, Weekly, Monthly, Quarterly and Yearly Expected Return of the Portfolios"),
        h4("Based on the output we can conclude whether Portfolio 1 is better compared to Portfolio 2 or vice versa"),
        helpText("Note: The prototype is for demo purpose only. It is based soley on historical returns without considering other factors that affect overall returns such as different forms of risk, risk free rate of return and so on.The real world return will be quite different from what you get from this App.",style = "color:tomato"),
        helpText("Final version of the App will try to include as many factors that are involved in real world returns calculation so that it can be used in finantial modeling",style = "color:tomato"),
        h1("References and Additional Resources",style = "color:black"),
        h4("Contact us at support@pcomare.com to know more and customize the App as per your requirement"),
        h4("Alternatively, to know more about our company and product, you can log on to our website",a("www.pcompare.com", href = "http://www.pcompare.com ")),
        h4("Access the Portfolio Compare App Presentation at",a("Keynote Presentation", href = "http://rpubs.com/karthikrv82/DDP"))
        
        
          )
)
))

