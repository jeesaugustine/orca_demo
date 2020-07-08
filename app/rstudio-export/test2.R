# Generate colors based on media type:

library(plotly)
library(igraph)
library(threejs)
library(htmlwidgets)
# data(karate, package="igraphdata")
# G <- upgrade_graph(karate)



f <- read.csv(file = "edges_with_index_1.csv", header = FALSE)
edges <- c()
print(dim(f)[1])
for (e in 1:dim(f)[1]){
  edges <- append(edges, c(f[e, 1], f[e, 2]))
}
length(edges)
G <- make_graph(edges)
E(G)
print(length(V(G)))
print(length(E(G)))
net = G
net.js <- net
graph_attr(net.js, "layout") <- NULL 
gjs <- graphjs(net.js, main="Network!", bg="gray10", showLabels=F, stroke=F, 
               curvature=0.1, attraction=0.9, repulsion=0.8, opacity=0.2)
print(gjs)
saveWidget(gjs, file="Media-Network-gjs.html")
browseURL("Media-Network-gjs.html")
net <- simplify(net, remove.multiple = F, remove.loops = T) 
plot(net, edge.arrow.size=.4,vertex.label=NA)

plot(net)
colrs <- c("gray50", "tomato", "gold")
#V(net)$color <- colrs[V(net)$media.type]

# Compute node degrees (#links) and use that to set node size:
deg <- degree(net, mode="all")
# V(net)$size <- deg*3
# We could also use the audience size value:
# V(net)$size <- V(net)$audience.size*0.6

# The labels are currently node IDs.
# Setting them to NA will render no labels:
# V(net)$label <- NA

# Set edge width based on weight:
# E(net)$width <- E(net)$weight/6

#change arrow size and edge color:
E(net)$arrow.size <- .2
E(net)$edge.color <- "gray80"

# We can even set the network layout:
graph_attr(net, "layout") <- layout_with_lgl
#plot_ly(net)
print(length(V(net)))
l = layout_on_sphere(net)

p <- plot_ly(as.data.frame(l), x=l[,1], y = l[,2], z = l[,3],type = 'scatter3d')%>% 
add_paths(x=lines_df_x,y=lines_df_y,z=lines_df_z)
#,x=lines_df_x,y=lines_df_y,z=lines_df_z
f <- read.csv(file = "edges_with_index_1.csv", header = FALSE)

print(length(f$V1))
lines_df_x <- c()
lines_df_y <- c()
lines_df_z <- c()
for (i in 1:(length(f$V1))){
  p1 <- (f[i, 1])
  p2 <- (f[i, 2])
  x1 <-  (l[p1,1])
  y1 <-  (l[p1,2])
  z1 <-  (l[p1,3])
  x2 <- (l[p2,1])
  y2 <- (l[p2,2])
  z2 <- (l[p2,3])

    lines_df_x <- c(lines_df_x, x1, x2, rep(NA,1))
    lines_df_y <- c(lines_df_y,y1, y2, rep(NA,1))
    lines_df_z <- c(lines_df_z,z1, z2, rep(NA,1))
    print(i)
  
  
}

