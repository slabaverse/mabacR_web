# Load packages ----------------------------------------------------------------
detach("package:mabacR", unload = TRUE)
devtools::install_github("https://github.com/slabaverse/mabacR.git", ref = "master")

library(mabacR)
library(shiny)
library(readxl)
library(DT)
library(plotly)
library(ggplot2)
library(bslib)
source("baa_calc.R")

# UI---------------------------------------------------------------------------------------------------------------------------------

ui <- fluidPage(
  theme = bs_theme(version = version_default(), bootswatch = "lumen"),
  titlePanel("mabacR"),
  sidebarLayout(sidebarPanel(
    fileInput("file", "Select file:"),
    tags$div(
      hr(),
      h6(
        "This application implements the Multi-Attributive Border Approximation Area Comparison (MABAC) method, a robust multi-criteria decision-making tool. To improve your experience and understanding, we recommend downloading the 'User Manual' (PT-Br or En) and watching the video tutorial, 'Como preencher a planilha padrão? (PT-Br only)'. Additionally, the standard spreadsheet template for entering the data to be analyzed is available for download below."
      ),
      hr(),
      HTML(
        "User's guide (PT-Br): <a href =
               'https://arslabadack.shinyapps.io/mabacR/manual_pt.pdf'>
               manual_pt.pdf</a>"
      ),
      p(),
      HTML(
        "User's guide (En): <a href =
               'https://arslabadack.shinyapps.io/mabacR/manual_en.pdf'>
               manual_en.pdf</a>"
      ),
      p(),
      HTML(
        "Standard spreadsheet: <a href =
               'https://arslabadack.shinyapps.io/mabacR/mabacr.xlsx'>
               mabacr.xlsx</a>"
      ),
      p(),
      HTML(
        "YouTube video (only in PT-Br): <a href =
               'https://youtu.be/a5Y0Gs3d1ig'>
               Como preencher a planilha mabacr.xlsx?</a>"
      ),
      p(),
      # ALTERAR O REPO NO GITHUB
      HTML(
        "Repository: <a href =
               'https://github.com/slabaverse/mabacR_web.git'>
               GitHub</a>"
      ),
      p(),
      HTML(
        "Paper: SLABADACK, A. R., SANTOS, M. Implementação do método multicritério MABAC na linguagem R: uma ferramenta para
tomada de decisão.USP/Esalq. Piracicaba-SP, 2023. <a href =
               'https://arslabadack.shinyapps.io/mabacR/adam_slabadack_tcc.pdf'>
               tcc.pdf</a>"
      ),
      p(),
      hr(),
      h6(
        "I invite you to check out the article that introduced MABAC, we based ourselves on the calculations presented there to create this tool, in addition, the data used in the standard spreadsheet comes from this work:"),
        p(),
        h6(
        "PAMUČAR, D.; ĆIROVIĆ, G. The selection of transport and handling resources in logistics centers using Multi-Attributive Border Approximation area Comparison (MABAC). Expert systems with applications, v. 42, n. 6, p. 3016–3028, 2015."
      ),
      p(),
      hr(),
      h6(
        "We are very happy that you chose our application to assist in your decision making. Feel free to use it and, if you want to know more in depth, the source code is available in the item 'Repository on GitHub: GitHub'. We would be grateful if you mentioned us in your results. If you want to check out the work resulting from this application, it is available in the item 'Implementation of the MABAC Multicriteria Method in the R Language: A Tool for Decision Making'."
      ),
      p(),
      HTML(
        "How to cite: <em>SLABADACK, A. R., SANTOS, M. (2024). mabacR: Assisting Decision Makers (Version 0.1.0) [R package]. Comprehensive R Archive Network (CRAN). DOI: [10.32614/CRAN.package.mabacR](https://doi.org/10.32614/CRAN.package.mabacR).</em>"
      ),
      p(),
      HTML(
        "Contact us: <a href =
               'mailto:arslabadack@gmail.com'>arslabadack@gmail.com</a>"
      ),
    )
  ), # MAIN PANEL---------------------------------------------------------------------------------------------------------------------------------
  mainPanel(
    tabsetPanel(
      tabPanel(
        "Data",
        dataTableOutput("table")
      ),
      tabPanel(
        "Results",
        fluidRow(
          column(6, h4("Ordering"), verbatimTextOutput("results")),
          column(
            6,
            h4("Border Approximation Area Values (BAA)"),
            verbatimTextOutput("baa")
          )
        ),
        h4(
          "Classification of Items Analyzed in Relation to the Border Approximation Area (BAA)"
        ),
        selectInput("filter", "Select a criteria:", choices = NULL),

        plotOutput("plot_1")
      )
    )
  ))
)
server <- function(input, output, session) {
  # Reactive expression to read the uploaded file
  mabac_data <- reactive({
    req(input$file)
    file <- input$file$datapath
    mabac_df <- read_excel(file)
    return(mabac_df)
  })

  # Render the table with the uploaded data
  output$table <- renderDataTable({
    req(mabac_data())
    mabac_data()
  })

  # Run mabacR function and display the ranking results
  output$results <- renderPrint({
    req(mabac_data())
    mabac_result <- mabacR(mabac_data())
    mabac_result
  })

  # Calculate and display BAA values
  output$baa <- renderPrint({
    req(mabac_data())
    mabac_df <- as.data.frame(mabac_data())
    baa <- baa_calc(mabac_df)
    baa
  })

  result_list <- reactive({
    req(mabac_data())
    mabac_result <- mabacR(mabac_data())
    mabac_result
    return(mabac_result)

  })

# GRAPHICS---------------------------------------------------------------------------------------------------------------------------------
  observe({
    req(mabac_data())
    criteria <- mabac_data()[, 1]
    updateSelectInput(session, "filter", choices = criteria)
  })

  output$plot_1 <- renderPlot({
    req(mabac_data(), input$filter)

    # Cálculos
    baa <- baa_calc(as.data.frame(mabac_data()))
    mabac_result <- mabacR(mabac_data())
    index <- which(mabac_data()[, 1] == input$filter)

    # Verifique o número de linhas
    n_mabac <- nrow(mabac_result)
    baa_value <- baa[index, 1]

    # Crie um vetor para os valores do BAA para igualar o número de linhas
    baa_rep <- rep(baa_value, n_mabac)

    # Preparando os dados para o ggplot2
    mabac_df <- data.frame(
      Criteria = 1:n_mabac,
      Value = mabac_result[, 1],
      BAA_Value = baa_rep
    )

    # Gerando o gráfico com ggplot2
    ggplot(mabac_df) +
      geom_line(aes(x = Criteria, y = Value), color = "black") +
      geom_line(aes(x = Criteria, y = BAA_Value), linetype = "dashed", color = "red") +
      geom_text(aes(x = n_mabac / 2, y = baa_value,
                    label = format(round(baa_value, 6), nsmall = 4)),
                color = "red", vjust = -1, size = 5) +
      scale_x_continuous(breaks = 1:n_mabac, labels = rownames(mabac_result)) +
      labs(title = NULL,
           x = "Items",
           y = NULL) +
      theme_minimal() +
      theme(
        axis.title.x = element_text(size = 14),  # Tamanho do texto do eixo X
        axis.title.y = element_text(size = 14),  # Tamanho do texto do eixo Y
        axis.text.x = element_text(size = 14),   # Tamanho dos rótulos do eixo X
        axis.text.y = element_text(size = 14),   # Tamanho dos rótulos do eixo Y
        plot.title = element_text(size = 14, hjust = 0.5)  # Tamanho do título
      )
  })
}

shinyApp(ui, server)
