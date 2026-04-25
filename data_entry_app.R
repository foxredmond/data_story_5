setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(shiny)
library(lubridate)
library(DT)

# Function for saving data to a CSV file
log_line <- function(newdata, filename = 'app_data.csv'){
  (dt <- Sys.time() %>% round %>% as.character)
  (newline <- c(dt, newdata) %>% paste(collapse=',') %>% paste0('\n'))
  cat(newline, file=filename, append=TRUE)
  print('Data stored!')
}

################################################################################
################################################################################

ui <- fluidPage(
  titlePanel(h2("Farm to Table Food & Drink")),
  p("This Shiny Data Collection is designed to track food and drink quantities at Sewanee's Farm to Table event
    that occured on April 17th. \n The goal is that by tracking the amount purchased vs consumed, the event can mitigate purhcasing too much food, leading to food waste, which has occured in past iterations of the event."),
  br(),
  fluidRow(

    # Input: selecting pre-canned options
    column(4, selectInput('select',
                          label='Select Food/Drink',
                          choices = c('Meatballs', 'Burgers', 'Bratwursts', 'Mushrooms','Kombucha','Water Kefir'),
                          width='95%'),
           helpText("This is the food or drink you'll be recoding")),
           

    # Input: toggling between options
    column(4, radioButtons('radio',
                           label= 'Initial purchase or final remainder?',
                           choices = c('purchased', 'remaining'),
                           inline = TRUE,
                           width='95%'),
           helpText("This is where you select whether you are recoding after purchasing the food or after surveying the leftovers.")),

    #Input: Numeric entry
  column(4, numericInput(
    "quantity",
    "Quantity of selected food/drink (lbs)",
    value = 1,
    min = 0,
    max = 100),
    helpText("This is where you select the quanity of the selected food at the selected time."))),

  br(),
  br(),
  
  #Input: Save button
  fluidRow(column(2),
           column(8, actionButton('save',
                                  h2('Save!'),
                                  width='100%')),
           column(2))
)

################################################################################
################################################################################

server <- function(input, output) {

  # Save button ================================================================
  observeEvent(input$save, {
    newdata <- c(input$text, input$select, input$radio, input$quantity)
    log_line(newdata)
    showNotification("Save successful!")
  })
  #=============================================================================

}

################################################################################
################################################################################

shinyApp(ui, server)

#
