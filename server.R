# Derived from http://econometricsbysimulation.shinyapps.io/OLS-App/
options(shiny.trace=TRUE)
options(shiny.fullstacktrace=TRUE)
# set mirror
options(repos=structure(c(CRAN="http://cran.rstudio.com")))

if (!("shiny" %in% names(installed.packages()[,"Package"]))) {install.packages("shiny")}
suppressMessages(library(shiny, quietly = TRUE))

if (!("openintro" %in% names(installed.packages()[,"Package"]))) {install.packages("openintro")}
suppressMessages(library(openintro, quietly = TRUE))

if (!("plotrix" %in% names(installed.packages()[,"Package"]))) {install.packages("plotrix")}
suppressMessages(library(plotrix, quietly = TRUE))

sessionInfo()

library(DBI)
library(RMariaDB)
library(growthrates)

con <- dbConnect(
  drv = RMariaDB::MariaDB(), 
  username = 'root',
  password = '',
  dbname = "corona",  
  host='localhost')
  
rs1 <- dbSendQuery(con, "SELECT * FROM death WHERE death_no != 0 AND death_no > 10;")
data1 <- dbFetch(rs1)
dbClearResult(rs1)

x = data1$date;
# z = data1$date;
y = data1$death_no;
# okay so here we are going to keep the date value but we are going to adjust it so that day 1 is the day that the death_no > 0 and so forth
# according to our data days 1, 2, 3, 4, corresponds to (2020-02-29" "2020-03-01" "2020-03-02" "2020-03-03") respectively etc....


# here i can see the need to create a tuple list with the first value being the obsevation number and the second value being the date
# food for thought...

numofx = length(x);
# here we have at least 1 and as of 3/28 we have 29 observations
x1 = 1:numofx;
# so now our analysis is run on x1 with y values. easy...


# dbDisconnect()
# dbDisconnect(con)

# INSERT INTO death (date, death_no) VALUES ('2020-03-29', 2467);
# INSERT INTO death (date, death_no) VALUES (2020-03-30, 2978);
# UPDATE death SET date = '2020-03-29' WHERE ID = 68;
# UPDATE death SET date = '2020-03-30' WHERE ID = 69;

# y = x^2.395655

shinyServer(function(input, output) {
  
	output$deathplot <- renderPlot({
		plot(x1,y);		
	})
	
	output$logdeathplot <- renderPlot({
		plot(log(x1),log(y));		
	})
		
	# in order to refine our model we need to exclude values of 0 since the logarithm of 0 is not defined. duh...	
	
	# in my calculation this particular link was found to be useful and will be incuded here for reference
	
	# https://stackoverflow.com/questions/31851936/exponential-curve-fitting-in-r/31854405
	
	# ok so now we need to accound for the fact that we cannot just simply take the log of a date so instead we need to take the log of the id of the data set
	# but of course since we removed all the zero alues then we need to readjust our observation number so that we begin at 1...
	
	output$deathsummary <- renderPrint({
		exponential.model <- lm(log(y)~ log(x1))
		summary(exponential.model)		
	})
	
	output$deathfit <- renderPrint({
		fit = lm(log(y) ~ log(x1));
		fit$coefficients;
	})
	
	output$fitdeathplot <- renderPlot({
		fit = lm(log(y) ~ log(x1));
		fit$coefficients;
		plot(x1, y)
		lines(x1, x1 ^ fit$coefficients[2], col = "red")	
	})
	
	output$deathgrowthsummary <- renderPrint({
		fit <- fit_easylinear(x1, y);
		summary(fit);
	})
	
	output$fitgrowthdeathplot <- renderPlot({
		fit <- fit_easylinear(x1, y);
		par(mfrow = c(1, 2));
		plot(fit, log = "y");
		plot(fit);
	})
	
	
	
	
	

 
	
  
})
