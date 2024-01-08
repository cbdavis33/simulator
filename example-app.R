library(shiny)
library(log4r)

ui <- fluidPage(
  h1("example app"),
  uiOutput("ui_admin_panel"),
  selectizeInput("model_selector", "select your model", 
                 choices = tools::file_path_sans_ext(basename(fs::dir_ls("models", 
                                                                         type = "file")))),
  selectizeInput("dose_input_type", "dose input type", 
                 choices = c("numeric", "slider")),
  uiOutput("ui_dose_input"),
  actionButton("run_sim", "run simulation")
)

whoami <- function(user) {
  if (is.null(user)) {
    return("casey")
  }
  return(user)
}

logger <- logger(appenders = console_appender(logfmt_log_layout()))

server <- function(input, output, session) {
  
  message("logged in user: ", whoami(session$user))
  user <- whoami(session$user)
  
  output$ui_dose_input <- renderUI({
    req(input$dose_input_type)
    if (input$dose_input_type == "numeric") {
      return(numericInput("dose","dose", min = 100, max = 1000, step = 100, value = 200))
    } else {
      return(sliderInput("dose","dose", min = 100, max = 1000, step = 100, value = 200))
    }
  })
  
  output$ui_admin_panel <- renderUI({
    if (user == "casey") {
      return(h2("you're an admin!"))
    }
    return(h2("you're a regular user"))
  })
  
  observeEvent(input$run_sim, {
    info(logger, message = "changing dose", user = user, dose = input$dose)
  })
  
}

shinyApp(ui, server)