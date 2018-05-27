#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("NextWord prediction"),
  
  sidebarLayout(
     sidebarPanel(
        h2("Description"),
        h4("This is a small application that tries to predict the next word of a given sentence."),
        h4("You should enter a sentence in the text box in the main panel and click on Submit button when ready."),
        h4("This algorithm is based on a small ngrams dataset gathered analysing texts from news, blogs and twitter.
           That means that probably rare words are not predicted correctly."),
        h4("NOTE: Unfortunately, public shiny.io webpage gives a poorer performance that usual local run")
     ),
     # Show a plot of the generated distribution
     mainPanel(
       fluidRow(
          
          column(3),
          column(6,
                 tags$div(textInput("text", 
                                    label = h3("Enter your ENGLISH sentence:"),
                                    value = ),
                          submitButton("Submit"),
                          br(),
                          tags$hr(),
                          h4("The predicted next word:"),
                          tags$span(style="color:blue",
                                    tags$strong(tags$h3(textOutput("predictedWord")))),
                          br(),
                          align="center")
          ),
          column(3)
       )
     )
    )

))

