library(shiny)
#rename shiny::column function to workaround name collision with googlecharts package, as in
#http://stackoverflow.com/questions/29423602/unused-argument-error-with-offset-in-column-for-shiny
if("package:googleCharts" %in% search()) detach("package:googleCharts", unload=TRUE)
library(shiny)
column2 = column
library(shinythemes)
library(googleCharts)
# More info on google charts:
#   https://github.com/jcheng5/googleCharts
# Install:
#   devtools::install_github("jcheng5/googleCharts")


shinyUI(
  
  navbarPage("Babies", #1)
  tabPanel("Read me first", 
           HTML(paste(
           "<h1>Babies</h1>",
           "<br/>", 
           "This application enable some exploratory data analysis on the dataset <b>'babies'</b> contained in the package <b>'UsingR'</b>.<br/>",
           "The dataset is a collection of variables taken for each new mother in a Child and Health Development Study executed in 1961 and 1962, it contains 1,236 observations on 23 variables.",
           "<br/>",
           "I have focused the analysis on the weight of the babies and their parents selected variables, as well as the smoking habits of the mother. The available parents variables are: age, weight anf height",
           "You can select one of them on the drop-down below:<br/>")),
           
           selectInput("explVariable", label = h3("Select parents variable"), 
                       choices = list("age" = "age (years)", "height" = "height (inches)", "weight" = "weight (pounds)"),
                       selectize = FALSE, selected = "weight (pounds)", width = "50%"),
           
           HTML(paste(
           "In each of the next 2 pages, which you can access by clicking on the menu above, you'll find a bubble chart. They both share the following features:",
           "<ul><li>the X-axis contains the selected variable reported for the mother in the indicated unit of measure</li>",
           "<li>the Y-axis contains the selected variable reported for the father in the indicated unit of measure</li>",
           "<li>the size of the bubble is proportional to the weight in ounces of their baby</li>",
           "<li>the color of the bubble represent the smoking habit of the mother</li>",
           "</ul>",
           "<h2>Weekly Chart</h2>",
           "In the sidebar panel of this page you see a slider whose values range from week 0 to week 52 of the study, with 1 week step. Clicking anywhere on the slide selects a week and updates the chart.<br/>",
           "Alternatively, you can press the play button at the bottom-right corner of the slider to run across all weeks and therefore animate the chart. You can stop the animation by clicking again on pause button (same place of the play button).<br/>",
           "If you want to change the parents variable on both axis, come back to this <b>Read me first</b> page - again through the menu above - to select a new variable.<br/>",
           "<h2>Quantile Chart</h2>",
           "In the sidebar panel of this page you see a drop-down whose values indicates the highest(95%) and lowest(5%) quantile of the baby weight distribution. Selecting one of them makes the chart show the baby weights of that quartile vs the selected parents variable and the smoking habits of the mother.<br/>",
           "If you want to change the parents variable on both axis, come back to this <b>Read me first</b> page - again through the menu above - to select a new variable.<br/>",
           "<h2>Nota Bene</h2>",
           "In both charts you can zoom-in by dragging a rectangular region with the mouse and reset the zoom by right-clicking with the mouse on the chart.<br/>",
           "Please note, that the charts axis have always the same scale and range. This means the points along the diagonal (left-low to right-up) represents the same value of the selected variable for both parents.",
           "Therefore, points above such diagonal mean the father has an higher value for the selected parent variable and, likewise, points below the diagonal mean the mother has an higher value for the selected parent variable.",
           "That makes you understand whose parent variable has more influence on the baby weight data shown.",
           "Finally, remember to wait few deciseconds to have the Bubble chart to refresh its data whenever you interact with the application UI."
           ))
          ),
  
  tabPanel("Weekly Chart", 
             
  fluidPage(theme = shinytheme('spacelab'),

  titlePanel("Weight of babies vs. their parents parameters and mother smoking habits"),
  
  mainPanel(
                    # This line loads the Google Charts JS library
                    googleChartsInit(),
                    
                    # Use the Google webfont "Source Sans Pro"
                    tags$link(
                      href=paste0("http://fonts.googleapis.com/css?",
                                  "family=Source+Sans+Pro:300,600,300italic"),
                      rel="stylesheet", type="text/css"),
                    tags$style(type="text/css",
                               "body {font-family: 'Source Sans Pro'}"
                    ),
            
                    googleBubbleChart("chart",
                    width="100%", height = "600px",
                    
                    # See https://developers.google.com/chart/interactive/docs/gallery/bubblechart for option documentation.
                    options = list(
                      fontName = "Source Sans Pro",
                      fontSize = 13,
                      # Set axis labels and ranges
                      hAxis = list(
                        title = "Mother pre-pregnancy weight (pounds)",
                        viewWindow.max = xlim_w["max"],
                        viewWindow.min = xlim_w["min"]
                        #gridlines = list(count = 10)
                      ),
                      vAxis = list(
                        title = "Father weight (pounds)",
                        viewWindow.max = ylim_w["max"],
                        viewWindow.min = ylim_w["min"]
                        #gridlines = list(count = 10)
                      ),
                      # The default padding is a little too spaced out
                      chartArea = list(
                        top = 50, left = 75,
                        height = "75%", width = "75%"
                      ),
                      # Allow pan/zoom
                      explorer = list(keepInBounds="true", actions=c("dragToZoom", "rightClickToReset")),
                      # Set bubble visual props
                      bubble = list(
                        opacity = 0.4, stroke = "none",
                        # Hide bubble label
                        textStyle = list(
                          color = "none"
                        )
                      ),
                      # Set fonts
                      titleTextStyle = list(
                        fontSize = 16
                      ),
                      tooltip = list(
                        textStyle = list(
                          fontSize = 12
                        )
                      )
                    )
                  )
                ),
          
  sidebarPanel(
    
    fluidRow(
      column2(12, offset=0,
                  sliderInput("week", "Week", label = h3("Select week"), 
                              min = min(data$week), max = max(data$week),
                              value = min(data$week), step = 1, animate = TRUE)
            )
          )
        ) #end sidebarPanel
      ) #end fluidpage chart1
    ), #end tabpanel chart1
  
  tabPanel("Quantile Chart", 
           
           fluidPage(theme = shinytheme('spacelab'),
                     
                     titlePanel("Weight of babies vs. their parents parameters and mother smoking habits"),
                     
                     mainPanel(
                       
                       googleBubbleChart("chart3",
                                         width="100%", height = "600px",
                                         # See
                                         # https://developers.google.com/chart/interactive/docs/gallery/bubblechart
                                         # for option documentation.
                                         
                                         options = list(
                                           fontName = "Source Sans Pro",
                                           fontSize = 13,
                                           # Set axis labels and ranges
                                           hAxis = list(
                                             title = "Mother pre-pregnancy weight (pounds)",
                                             viewWindow = xlim,
                                             gridlines = list(count = 10)
                                           ),
                                           vAxis = list(
                                             title = "Father weight (pounds)",
                                             viewWindow = ylim,
                                             gridlines = list(count = 10)
                                           ),
                                           # The default padding is a little too spaced out
                                           chartArea = list(
                                             top = 50, left = 75,
                                             height = "75%", width = "75%"
                                           ),
                                           # Allow pan/zoom
                                           explorer = list(keepInBounds="true", actions=c("dragToZoom", "rightClickToReset")),
                                           # Set bubble visual props
                                           bubble = list(
                                             opacity = 0.4, stroke = "none",
                                             # Hide bubble label
                                             textStyle = list(
                                               color = "none"
                                             )
                                           ),
                                           # Set fonts
                                           titleTextStyle = list(
                                             fontSize = 16
                                           ),
                                           tooltip = list(
                                             textStyle = list(
                                               fontSize = 12
                                             )
                                           )
                                         )
                       )
                     ),
                     
                     
                     sidebarPanel(
                       
                       fluidRow(
                         column2(12, offset=0,
                                 selectInput("weightRange", label = h3("Select baby weight range"), 
                                                    choices = list("higher than 95% quantile" = "highest", "lower than 5% quantile" = "lowest"),
                                                    selectize = FALSE)
                         )
                       )
                     ) #end sidebarPanel
           ) #end fluidpage chart3
  ) #end tabpanel chart3
  
  
  ) #end navbarPage
) #end shinyUI
