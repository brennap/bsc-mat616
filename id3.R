quinlan <- data.frame(rbind(
  c("sunny", "hot", "high", "false", "no"),
  c("sunny", "hot", "high", "true", "no"),
  c("overcast", "hot", "high", "false", "yes"),
  c("rainy", "mild", "high", "false", "yes"),
  c("rainy", "cool", "normal", "false", "yes"),
  c("rainy", "cool", "normal", "true", "no"),
  c("overcast", "cool", "normal", "true", "yes"),
  c("sunny", "mild", "high", "false", "no"),
  c("sunny", "cool", "normal", "false", "yes"),
  c("rainy", "mild", "normal", "false", "yes"),
  c("sunny", "mild", "normal", "true", "yes"),
  c("overcast", "mild", "high", "true", "yes"),
  c("overcast", "hot", "normal", "false", "yes"),
  c("rainy", "mild", "high", "true", "no")
))
colnames(quinlan) <- c("outlook","temperature","humidity","windy","play")


# entropy takes a vector of any type, and returns a scalar float
entropy <- function(S){
  if (!(is.vector(S) | is.factor(S))) {
    warning("Entropy is calculated on a vector.")
  }
  if (length(S) == 0) {
    e <- 0
  } else {
    P <- sapply(levels(factor(S)), function(m){sum(m == S)/length(S)})
    e <- -sum(P*log2(P)) 
  }
  return(e)
}

# entropy(quinlan$play)

# conditional_entropy takes a dataframe, and two column names.
# The first column is used to segment the data, 
# The second column contains the classes we are trying to predict
conditional_entropy <- function(data, attribute, class){
  e <- 0
  for (value in levels(data[[attribute]])) {
    instances <- data[[attribute]] == value
    e <- e + sum(instances)/nrow(data)*entropy(data[instances,class])
  }
  return(e)
}

# conditional_entropy(data=quinlan, attribute='temperature', class='play')

gain <- function(data, attribute, class){
  entropy(data[[class]]) - conditional_entropy(data, attribute, class)
}

# gain(data=quinlan, attribute='temperature', class='play')

ID3 <- function(data, class){
  if (length(levels(factor(data[[class]]))) == 1){
    tree <- levels(factor(data[[class]]))
  } else if (length(setdiff(names(data), class)) == 0){
    tree <- names(which.max(table(data[[class]])))
  }else {
    G <- c()
    for (attribute in setdiff(names(data), class)){
      g <- gain(data, attribute, class)
      names(g) <- attribute
      G <- append(G, g)
    }
    node <- names(which.max(G))
    edges <- levels(data[[node]])
    tree <- list()
    tree[[node]] <- list()
    for (value in edges){
      tree[[node]][[value]] <- ID3(data[data[[node]] == value,setdiff(names(data), node)], class)
    }    
  }
  return(tree)
}

tree <- ID3(data=quinlan, class='play')
test <- c(outlook="overcast", temperature="cool", humidity="high", windy="true")

#ID3_walk <- function(instance, tree){
#  if (typeof(tree) == "list"){
#    value <- instance[names(tree) == names(instance)]
#    class <- ID3_walk(instance, tree[[names(value)]][[value]])
#  } else {
#    class <- tree
#  }
#  return(class)
#}

ID3_walk <- function(instance, tree){
  value <- instance[names(tree) == names(instance)]
  if (length(value) == 0){
    warning("Error while walking tree:  No attributes in instance match node.")
    class <- NULL
  }
  sub_tree <- tree[[names(value)]][[value]]
  if (typeof(sub_tree) == "list"){
    class <- ID3_walk(instance, sub_tree)
  } else if(is.null(sub_tree)) {
    warning("Error while walking tree: Instance value does not match ")
    class <- NULL
  } else {
    class <- sub_tree
  }
  return(class)
}

ID3_walk(test, tree)
