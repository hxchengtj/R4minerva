library(shiny)
library(ggplot2)
library(ellipse)

# dt <- read.table("/Users/kehao/Desktop/data from minerva/merge_final_data.txt", 
#                  sep = "\t", header = TRUE, check.names = FALSE, as.is = TRUE)
# dt.use <- dt[, c(25:29, 31:35)]
# pca.out <- princomp(dt.use, scale = TRUE)
# data.pca <- pca.out$scores
# 
# df.pca.all <- data.frame(data.pca)
# df.pca <- df.pca.all[, c(1, 2, 3)]
# names(df.pca) <- c("pc1", "pc2", "pc3")


# mean.pc1 <- mean(df.pca[, "pc1"])
# mean.pc2 <- mean(df.pca[, "pc2"])
# mean.pc3 <- mean(df.pca[, "pc3"])
# st.pc1 <- mean(df.pca[, "pc1"])
# st.pc2 <- mean(df.pca[, "pc2"])
# st.pc3 <- mean(df.pca[, "pc3"])

ui <- pageWithSidebar(
  headerPanel("Choose level for print contour"),
  sidebarPanel(
    fileInput('file1', 'Choose TXT file',
              accept = c('text/txt', 'text/comma-separated-valuses,text/plain', '.txt')),
    sliderInput('level', 'level for confidence ellipse',
                min = 0, max = 1, value = 0.5)
  ),
  
  mainPanel(
    tabsetPanel(
      tabPanel('pc1.pca - pc2.pca', plotOutput('plot')),
      tabPanel('pc2.pca - pc3.pca', plotOutput('plot2')),
      tabPanel('pc1.pca - pc3.pca', plotOutput('plot3'))
    )
    # tableOutput('contents')
  )
)

server <- function(input, output){
  
  data.txt <- reactive({
    file1 <- input$file1
    
    if(is.null(file1))
      return(NULL)
    dt <- read.table(file = file1$datapath, sep = "\t", header = TRUE,
                     check.names = FALSE, as.is = TRUE)
    dt.use <- dt[, c(25:29, 31:35)]
    pca.out <- princomp(dt.use, scale = TRUE)
    data.pca <- pca.out$scores

    df.pca.all <- data.frame(data.pca)
    df.pca <- df.pca.all[, c(1, 2, 3)]
    names(df.pca) <- c("pc1", "pc2", "pc3")
    df.pca
  })
  
  pca.123 <- reactive({
    data.txt()
  })

  # pca.12.df <- reactive({
  #   pca.12
  # })
  # pc1 & pc2
  data.12 <- reactive({
    # pca.ellip <- data.txt()[, c(1, 2)]
    dt.ellip.12 <- as.data.frame(with(pca.123(), ellipse(cor(pc1, pc2), scale=c(sd(pc1), sd(pc2)), level = input$level,
                                                   centre = c(mean(pc1), mean(pc2)))))
    names(dt.ellip.12) <- c('x', 'y')
    dt.ellip.12
  })
  # pc1 & pc3
  data.13 <- reactive({
    dt.ellip.13 <- as.data.frame(with(pca.123(), ellipse(cor(pc1, pc3), scale=c(sd(pc1), sd(pc3)), level = input$level,
                                                      centre = c(mean(pc1), mean(pc3)))))
    names(dt.ellip.13) <- c('x', 'y')
    dt.ellip.13
  })
  # pc2 & pc3
  data.23 <- reactive({
    dt.ellip.23 <- as.data.frame(with(pca.123(), ellipse(cor(pc2, pc3), scale=c(sd(pc2), sd(pc3)), level = input$level,
                                                         centre = c(mean(pc2), mean(pc3)))))
    names(dt.ellip.23) <- c('x', 'y')
    dt.ellip.23
  })

  ##----------------
  
  output$plot <- renderPlot({
    if(is.null(pca.123()))
      return(NULL)
    ggplot() + 
      geom_point(data = pca.123(), aes(pc1, pc2)) +
      geom_vline(xintercept = mean(pca.123()[, 1]), linetype = 2) + 
      geom_hline(yintercept = mean(pca.123()[, 2]), linetype = 2) +
      geom_path(data = data.12(), aes(x, y), colour = 'red') 

  })
  
  output$plot2 <- renderPlot({
    if(is.null(pca.123()))
      return(NULL)
    ggplot() +
      geom_point(data = pca.123(), aes(pc1, pc3)) +
      geom_vline(xintercept = mean(pca.123()[, 1]), linetype = 2) +
      geom_hline(yintercept = mean(pca.123()[, 3]), linetype = 2) +
      geom_path(data = data.13(), aes(x, y), colour = 'red')

  })

  output$plot3 <- renderPlot({
    if(is.null(pca.123()))
      return(NULL)
    ggplot() +
      geom_point(data = pca.123(), aes(pc2, pc3)) +
      geom_vline(xintercept = mean(pca.123()[, 2]), linetype = 2) +
      geom_hline(yintercept = mean(pca.123()[, 3]), linetype = 2) +
      geom_path(data = data.23(), aes(x, y), colour = 'red')

  })
  
  # output$contents <- renderTable({
  #   data.txt()
  # })
}

shinyApp(ui = ui,  server = server)