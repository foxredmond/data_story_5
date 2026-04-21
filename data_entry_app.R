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
    that occured on April 17th."),
    p("The goal is that by tracking consumption, the event can mitigate purhcasing too much food, leading to food waste, which has occured in past iterations of the event."),
  br(),
  fluidRow(

    # Example input: selecting pre-canned options
    column(4, selectInput('select',
                          label='Select Food/Drink',
                          choices = c('Meatballs', 'Burgers', 'Bratwursts', 'Mushrooms', 'Cookies','Kombucha','Water Kefir'),
                          width='95%')),

    # Example input: toggling between options
    column(4, radioButtons('radio',
                           label='Before or After Event',
                           choices = c('Before', 'After'),
                           inline = TRUE,
                           width='95%')),

    # Example input: Numeric entry
  column(4, numericInput(
    "quantity",
    "Quantity of selected food/drink after event (lbs)",
    value = 1,
    min = 0,
    max = 100))),

  br(),
  br(),
  fluidRow(column(2),
           # Save button!
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
