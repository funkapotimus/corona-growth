options(shiny.trace=TRUE)
options(shiny.fullstacktrace=TRUE)
# Define UI for OLS demo application
shinyUI(fluidPage(
  
  
  includeCSS("style.css"),
  #  Application title
  headerPanel("Coronavirus COVID-19: Fitting an Exponential Model"),
  
  sidebarPanel(
    
  
		helpText("so my hypothesis is that the number of deaths as well as the number of reported cases due to COVID-19 are rising exponentially. so i will attempt to fit an exponential model to the data.
		for now the scope of this project will only include the US (United States) though i aim to make something similar to John Hopkins university's tracker. start small then make it bigger. ok go."),
		helpText(""),
		helpText("this was last updated 3/30/2020"),
		helpText("")
	
	),
    
  
  
  
  
  # Show the main display
  mainPanel(	
  
	verbatimTextOutput("deathgrowthsummary"),
	# verbatimTextOutput("deathfit"),
	# plotOutput("deathplot"),
	# plotOutput("logdeathplot"),
	# plotOutput("fitdeathplot"),
	plotOutput("fitgrowthdeathplot")

	
  )
))