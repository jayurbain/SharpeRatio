# Jay Urbain, jay.urbain@gmail.com
# 10/24/2015
#
# Sharpe Ratio & Cummulative Return Vis
#
# ui.R

library(shiny)

shinyUI(fluidPage(
  titlePanel("Sharpe Ratio & Cummulative Return Vis"),

  sidebarLayout(
    sidebarPanel(
      helpText("Author: Jay Urbain"),

      helpText("Objective: Interactive tool for evaluating the relative risk-adjusted rate of return for two assets."),

      helpText("The Sharpe Ratio is a measure for calculating risk-adjusted return.
               It was developed by Nobel laureate William F. Sharpe."),
      helpText("The Sharpe ratio is the average return earned in excess of a benchmark asset
               per unit of volatility or total risk."),

      withMathJax(helpText("$$Sharpe\\ Ratio_a=\\frac{E[R_a - R_b]}{\\sigma_{R_a-R_b}}=\\frac{E[R_a - R_b]}{\\sqrt{R_a-R_b}}$$")),
      withMathJax(helpText("$$R_a = Asset\\ return$$")),
      withMathJax(helpText("$$R_b = Return\\ of\\ benchmark\\ asset$$")),
      withMathJax(helpText("$$E[R_a - R_b] = Expected\\ excess\\ return$$")),
      withMathJax(helpText("$$\\sigma_{ab} = Standard\\ deviation\\ of\\ this\\ excess\\ return$$")),

      br(),

      textInput("symb", "Stock Symbol (a)", "AAPL"),

      textInput("benchmark", "Benchmark/Stock Symbol (b)", "SPY"),

      dateRangeInput("dates",
        "Date range",
        start = "2013-01-01",
        end = as.character(Sys.Date())),

      submitButton("Submit")
    ),

    mainPanel(
      plotOutput("plot"),
      textOutput("sharpeText"),
      textOutput("stockCumRetText"),
      textOutput("benchmarkCumRetText")
    )
  )
))