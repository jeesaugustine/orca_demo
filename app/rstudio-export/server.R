#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    library(reshape2)
    library(plotly)
    library(igraph)

    # This command below gives you the topology and the perturbed prior 
    # TODO: add other priors (uniform, gravity)
    system("python3 network_generator.py")
    system("tr '\n' , < ./data/b.csv > ./data/b.txt")
    system("awk '{print $2}' ./data/g.csv > ./data/_xp.txt")
    system("cut -c-8 ./data/_xp.txt > ./data/__xp.myytxt")
    system("tr '\n' , < ./data/__xp.txt > ./data/xp.txt")
    system("cp ./data/a.csv ./data/a.txt")
    
    # Actual Code to our algorithm main
    # Complile the codes 
    system("g++ -o direct ./SR/main.cpp")
    system("g++ -o Ddirect ./SR/main_dynamic.cpp")
    
    # Execution Commands 
    system("./direct -f ./data/ -o output.txt")
    system("./Ddirect -f ./data/ -o output.txt")
    
    # f <- read.csv(file = "edges_with_index_1.csv", header = FALSE)
    f <- read.csv(file = "edges.txt", header = FALSE)
    edges <- c()
    print(dim(f)[1])
    for (e in 1:dim(f)[1]){
        edges <- append(edges, c(f[e, 1], f[e, 2]))
    }
    length(edges)
    # G <- make_graph(edges)
    # G <- graph_from_edgelist(as.matrix(f),  directed = TRUE)
    G = graph.data.frame(f, directed=TRUE, vertices=NULL)
    print(length(E(G)))
    print(length(V(G)))
    print(length(E(G)))
    net = G
    lines_df_x <- c()
    lines_df_y <- c()
    lines_df_z <- c()
    l = layout_on_sphere(net)
    list_data <- list(c(V(G)$name))
    for (i in 1:(length(f$V1))){
        p1 <- (f[i, 1])
        p2 <- (f[i, 2])
        p1 <- match(p1, list_data[[1]])
        p2 <- match(p2, list_data[[1]])
        x1 <-  (l[p1,1])
        y1 <-  (l[p1,2])
        z1 <-  (l[p1,3])
        x2 <- (l[p2,1])
        y2 <- (l[p2,2])
        z2 <- (l[p2,3])
        
        lines_df_x <- c(lines_df_x, x1, x2, NA)
        lines_df_y <- c(lines_df_y,y1, y2, NA)
        lines_df_z <- c(lines_df_z,z1, z2, NA)
        
    }
    
    output$distPlot <- renderPlotly(plot_ly(as.data.frame(l), x=l[,1], y = l[,2], z = l[,3], type = 'scatter3d' ) %>% 
                                    add_paths(x=lines_df_x,y=lines_df_y,z=lines_df_z))
    
#####################################################################################################################################################################    

    ##### Tab 3 ######    
    
#####################################################################################################################################################################    
    library(Cairo)
    library(ggplot2)
    mtcars2 <- mtcars[, c("mpg", "cyl", "disp", "hp", "wt", "am", "gear")]
    output$plot2 <- renderPlot({
      ggplot(mtcars2, aes(wt, mpg)) + geom_point()
    })
    # output$click_info <- renderPrint({
    #   # Because it's a ggplot2, we don't need to supply xvar or yvar; if this
    #   # were a base graphics plot, we'd need those.
    #   nearPoints(mtcars2, input$plot_click, addDist = TRUE)
    #   brushedPoints(mtcars2, input$plot1_brush)
    # })
    output$brush_info <- renderPrint({
      #print('Hi')
      print(input$plot_dblclick)
      #print(input$plot1_click)
      #brushedPoints(mtcars2, input$plot1_brush)
      # brushedPoints(mtcars2)
    })

  

#####################################################################################################################################################################    
    
##### Tab 2 ######    
    
#####################################################################################################################################################################            
    
    output$test <- renderDataTable({
      library(kableExtra)
      library(DT)
      library(Cairo)
      
      file_reader <- read.csv(file = "./data/output.txt", header = FALSE)
      transpose_step1 <- melt(file_reader)
      transpose_table <- as.data.frame(transpose_step1$value)
      colnames(transpose_table) <- c("Traffic")
      transpose_table$sd_id<- cbind(c(1:length(transpose_table$Traffic)))
      datatable(transpose_table, filter = 'top', options = list(pageLength = 5))
    })

    #####################################################################################################################################################################

    ##### Tab 4 ######

    #####################################################################################################################################################################

    mat <- read.csv("aatThreshCompliment.csv", header = FALSE)
    mat2 <- read.csv("aat.csv", header = FALSE)
    print(mat)
    output$heatmap <- renderPlotly(heatmaply(mat2, Rowv = FALSE, Colv = FALSE, margins = c(40,40,40,40), showticklabels = FALSE,scale_fill_gradient_fun = ggplot2::scale_fill_gradient2(low = "white", high = "steelblue"),hide_colorbar=TRUE))
    output$heatmap2 <- renderPlotly(heatmaply(mat, Rowv = FALSE, Colv = FALSE, margins = c(40,40,40,40), showticklabels = FALSE,color=c("grey10","steelblue"),hide_colorbar=TRUE))
})

