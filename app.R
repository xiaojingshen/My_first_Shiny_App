#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(plotly)
library(tidyverse)
#Reading in the data set
exam<- read.csv("data/Exam_data.csv")

library(shiny)
library(plotly)
library(tidyverse)
exam <- read_csv("data/Exam_data.csv")
ui <- fluidPage(
    titlePanel("Drill-down Bar Chart"),
    mainPanel(
        plotlyOutput("race"),
        plotlyOutput("gender"),
        verbatimTextOutput("info")
    )
)
# Define server logic required to draw a histogram
server <- function(input, output) {
    output$race <- renderPlotly({
        p <- exam %>%
            plot_ly(x = ~RACE)
    })
    output$gender <- renderPlotly({
        d <- event_data("plotly_click")
        if (is.null(d)) return(NULL)
        p <- exam %>% 
            filter(RACE %in% d$x) %>% 
            ggplot(aes(x=GENDER)) +
            geom_bar() 
        ggplotly(p) %>%
            layout(xaxis = list(title = d$x))
    })
    output$info <- renderPrint({
        event_data("plotly_click")
    })    
}
# Run the application 
shinyApp(ui = ui, server = server)
