# Jay Urbain, jay.urbain@gmail.com
# 10/24/2015
#
# Sharpe Ratio & Cummulative Return Vis
#
# # server.R

library(quantmod)

shinyServer(function(input, output) {

  # parse list of stock symbols, limit to 1
  stockText <- reactive({
    p<-unlist(strsplit(input$symb, "\\s+"))
    return(p[1])
  })

  # parse benchmark assest, limit to 1
  benchmarkText <- reactive({
    b<-unlist(strsplit(input$benchmark, "\\s+"))
    return(b[1])
  })

  # if stock changes, or date range changes, fetch updated stock data
  stock <- reactive({
    p<-stockText()
    s<-getSymbols(p, src="yahoo",
                    from = input$dates[1],
                    to = input$dates[2],
                    auto.assign = FALSE)
    names(s)<-c("Open", "High", "Low", "Close", "Volume", "Adjusted")
    s$adjCumReturn<-s$Adjusted/as.double(s$Adjusted[1])
    return(s)
  })

  # if benchmark stock/assest changes, or date range changes, update benchmark data
  benchmark <- reactive({
    b<-benchmarkText()
    s<-getSymbols(b, src="yahoo",
                    from = input$dates[1],
                    to = input$dates[2],
                    auto.assign = FALSE)
    names(s)<-c("Open", "High", "Low", "Close", "Volume", "Adjusted")
    s$adjCumReturn<-s$Adjusted/as.double(s$Adjusted[1])
    return(s)
  })

  # render plot of cumulative returns of selected stock and benchmark
  output$plot <- renderPlot({
    ymin<-min(benchmark()$adjCumReturn-1, stock()$adjCumReturn-1)
    ymax<-max(benchmark()$adjCumReturn-1, stock()$adjCumReturn-1)
    plot(benchmark()$adjCumReturn-1, ylim=c(ymin,ymax),
         main="Cumulative Return",
         ylab="Cumulative Return",lty="dashed")
    lines(stock()$adjCumReturn-1, col="red")
    legend("topleft",c(stockText(),benchmarkText()),
           col=c("red","black"),lty=c("solid","dashed"))
  })

  # Calculate Sharpe Ratio
  sharpe <- reactive({
    stkRetSd<-sd(stock()$adjCumReturn, na.rm=TRUE)
    sp<-mean(stock()$adjCumReturn - benchmark()$adjCumReturn) / stkRetSd
    return(sp)
  })

  output$sharpeText <- renderText({
    paste(stockText(), "Sharpe Ratio", "with respect to", benchmarkText(), ":", format(round(sharpe(), 2), nsmall = 2))
  })

  output$stockCumRetText <- renderText({
    stkCumReturn<-stock()$adjCumReturn
    stkTotalCumReturn<-stkCumReturn[length(stkCumReturn)]-1
    paste(stockText(), "Total Cumulative Return:", format(round(stkTotalCumReturn, 2), nsmall = 2))
  })

  output$benchmarkCumRetText <- renderText({
    benchmarkCumReturn<-benchmark()$adjCumReturn
    benchmarkTotalCumReturn<-benchmarkCumReturn[length(benchmarkCumReturn)]-1
    paste(benchmarkText(), "Total Cumulative Return:", format(round(benchmarkTotalCumReturn, 2), nsmall = 2))
  })
})





