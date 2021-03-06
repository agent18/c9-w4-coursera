library(shiny)
shinyUI(fluidPage(
  titlePanel("Confidence intervals Simulation based on Khan Academy"),
  sidebarLayout(
    sidebarPanel(
        h3("Move the Sliders to see the plot change"),
        sliderInput("n","Sample size(n)",20,100,20),
        sliderInput("p","Probability of Population (p)",0,1,0.5),
        sliderInput("CI","Confindence Interval(CI%)",0,100,95),
        sliderInput("N","Number of samples (N)",0,150,30)
        #actionButton("reset","Click to resample")
             
    ),
    mainPanel(
        h3("Results and Plot"),
        textOutput("hits"),
        plotOutput("plot1"),
        h3("Plot Explanation"),
        textOutput("plot2"),
        h3("Instructions and documentation"),
        textOutput("docu"),
        h4("Expected output"),
        textOutput("docu2"),
        h4("Inspiration"),
        textOutput("insp"),
        h3("Code and calulations of Server and UI"),
        textOutput("code")

        
    )
  )
))
