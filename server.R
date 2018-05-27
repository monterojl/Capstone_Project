#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

shiny.maxRequestSize=50*1024^2
ngrams<-readRDS("C-2400k3-4ngrams_only4_f43plus1-ah.rds")

source("./myPredictiveFunctions.R")


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
   myword <- reactive({
      if (length(words(input$text))>0){
         prediction<-as.character(nextWord(input$text,ngrams)[1,1])
         if (is.na(prediction)){prediction<-"the"}
         myword <- prediction

      } else {
         myword<-"Please, enter a sentence"
      }
   })
   output$predictedWord <- renderText(myword())
})

