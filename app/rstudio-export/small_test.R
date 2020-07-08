f <- read.csv(file = "edges_1_5.csv", header = FALSE)
edges <- c()
g= graph()
# read.graph("edges_1_5.csv", format="edgelist")
# read.graph("edges_1_5.txt", format="edgelist")
print(dim(f)[1])
for (e in 1:dim(f)[1]){
  edges <- append(edges, c(f[e, 1], f[e, 2]))
}

print(edges)
length(edges)
G <- graph_from_edgelist(as.matrix(f),  directed = TRUE)
# G = graph_from_literal(7--8, 5--32, 24--43, 50--66, 34--70)
V(G)
E(G)

G = graph.data.frame(f, directed=TRUE, vertices=NULL)
V(G)
E(G)

l = layout_on_sphere(G)
lines_df_x <- c()
lines_df_y <- c()
lines_df_z <- c()
print(length(f$V1))
mapper = c()
i  = 1

list_data <- list(c(V(G)$name))
match("8", list_data)
list_data
list_data <- as.numeric(list_data)
list_data_1 <- list()
for (j in 1:length(V(G))){
  # print(c(list_data[[1]][j]))
  list_data_1 <- append(list_data_1, c(list_data[[1]][j]))
  # print(list_data[[1]][j])
}


for (i in 1:(length(f$V1))){
  p1 <- (f[i, 1])
  p2 <- (f[i, 2])
  p1 <- match(p1, list_data[[1]])
  p2 <- match(p2, list_data[[1]])
  print(p1)
  print(p2)
  x1 <-  (l[p1,1])
  y1 <-  (l[p1,2])
  z1 <-  (l[p1,3])
  x2 <- (l[p2,1])
  y2 <- (l[p2,2])
  z2 <- (l[p2,3])
  
  lines_df_x <- c(lines_df_x, x1, x2, rep(NA,1))
  lines_df_y <- c(lines_df_y,y1, y2, rep(NA,1))
  lines_df_z <- c(lines_df_z,z1, z2, rep(NA,1))
  print(i)}
p <- plot_ly(as.data.frame(l), x=l[,1], y = l[,2], z = l[,3],type = 'scatter3d')%>% 
  add_paths(x=lines_df_x,y=lines_df_y,z=lines_df_z)
p
