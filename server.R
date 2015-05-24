library(dplyr)

shinyServer(function(input, output, session) {
  
  # Provide an explicit color for each distance, so they don't get recoded when the
  # different series happen to be ordered differently from year to year.
  # http://andrewgelman.com/2014/09/11/mysterious-shiny-things/
  defaultColors <- c("#3366cc", "#dc3912", "#ff9900", "#109618", "#990099", "#0099c6", "#dd4477", "#223366", "#885577", "#450688")
  series <- structure(
    lapply(defaultColors, function(color) { list(color=color) }),
    names = levels(as.factor(data$smoke))
  )
  
  
  XaxisLimData <- reactive({
    xlim <- 
    if ("weight (pounds)" == input$explVariable) xlim_w
    else if ("age (years)" == input$explVariable) xlim_a
    else if ("height (inches)" == input$explVariable) xlim_h
  })
  
  YaxisLimData <- reactive({  
    ylim <- 
    if ("weight (pounds)" == input$explVariable) xlim_w
    else if ("age (years)" == input$explVariable) xlim_a
    else if ("height (inches)" == input$explVariable) xlim_h
  })
  
  weekData <- reactive({
    # Filter to the desired week, and put the columns the order that Google's Bubble Chart expects them (name, x, y, color, size). 
    # Also sort by smoke so that Google Charts orders and colors the distances consistently.
    # All of above for the parent exploratory variable selected by the user.
    if ("weight (pounds)" == input$explVariable) (
      data_w %>%
      filter(week == input$week) %>%
      select(id, mother_weight=wt1, father_weight=dwt, smoke, baby_weight_ounces=wt) %>%
      arrange(smoke)
    )
    else if ("age (years)" == input$explVariable) (
      data_a %>%
      filter(week == input$week) %>%
      select(id, mother_age=age, father_age=dage, smoke, baby_weight_ounces=wt) %>%
      arrange(smoke)
    )
    else if ("height (inches)" == input$explVariable) (
      data_h %>%
      filter(week == input$week) %>%
      select(id, mother_height=ht, father_height=dht, smoke, baby_weight_ounces=wt) %>%
      arrange(smoke)
    )      
 
  })
  
  quantileData <- reactive({
    # Filter to the desired week, and put the columns the order that Google's Bubble Chart expects them (name, x, y, color, size). 
    # Also sort by smoke so that Google Charts orders and colors the distances consistently.
    # All of above for the parent exploratory variable selected by the user.
    if ("highest" == input$weightRange) (
      
      if ("weight (pounds)" == input$explVariable) (
        data_w[data_w$wt > quantile(data_w$wt, 0.95), ] %>%
          select(id, mother_weight=wt1, father_weight=dwt, smoke, baby_weight_ounces=wt) %>%
          arrange(smoke)
      )
      else if ("age (years)" == input$explVariable) (
        data_w[data_w$wt > quantile(data_w$wt, 0.95), ] %>%
          select(id, mother_age=age, father_age=dage, smoke, baby_weight_ounces=wt) %>%
          arrange(smoke)
      )
      else if ("height (inches)" == input$explVariable) (
        data_w[data_w$wt > quantile(data_w$wt, 0.95), ] %>%
          select(id, mother_height=ht, father_height=dht, smoke, baby_weight_ounces=wt) %>%
          arrange(smoke)
      )  
      
    )
    
    else if ("lowest" == input$weightRange) (
      
      if ("weight (pounds)" == input$explVariable) (
        data_w[data_w$wt < quantile(data_w$wt, 0.05), ] %>%
          select(id, mother_weight=wt1, father_weight=dwt, smoke, baby_weight_ounces=wt) %>%
          arrange(smoke)
      )
      else if ("age (years)" == input$explVariable) (
        data_w[data_w$wt < quantile(data_w$wt, 0.05), ] %>%
          select(id, mother_age=age, father_age=dage, smoke, baby_weight_ounces=wt) %>%
          arrange(smoke)
      )
      else if ("height (inches)" == input$explVariable) (
        data_w[data_w$wt < quantile(data_w$wt, 0.05), ] %>%
          select(id, mother_height=ht, father_height=dht, smoke, baby_weight_ounces=wt) %>%
          arrange(smoke)
      )  
    )
    
  })
  
  output$chart <- reactive({
    # Return the data and options
    list(
      data = googleDataTable(weekData()),
      options = list(
        title = sprintf(
          "Babies born on week %s after study start (1961-62)",
          input$week),
        series = series,
        hAxis = list(
          title = sprintf("Mother %s ", input$explVariable),
          viewWindow = XaxisLimData(),
          gridlines = list(count = 10)
        ),
        vAxis = list(
          title = sprintf("Father %s ", input$explVariable),
          viewWindow = YaxisLimData(),
          gridlines = list(count = 10)
        )
      )
    )
  })
  
  output$chart3 <- reactive({
    # Return the data and options
    list(
      data = googleDataTable(quantileData()),
      options = list(
        title = sprintf(
          "Babies born with weight at the %s quantile (1961-62)",
          input$weightRange),
        series = series,
        hAxis = list(
          title = sprintf("Mother %s ", input$explVariable),
          viewWindow = XaxisLimData(),
          gridlines = list(count = 10)
        ),
        vAxis = list(
          title = sprintf("Father %s ", input$explVariable),
          viewWindow = YaxisLimData(),
          gridlines = list(count = 10)
        )        
      )
    )
  })    
  
})
