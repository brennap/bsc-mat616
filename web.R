######################## Function Definition ########################

# Function for computing powers of a Matrix
# Should probably check or otherwise account
#  for a non-square matrix
#  and x <= 0
MatrixPower <- function(M, x){
  T <- diag(rep(1,nrow(M)))
  cn <- colnames(M)
  #rn <- rownames(M)
  for (i in 1:x){
    T <- M %*% T
    colnames(T) <- cn
    #rownames(T) <- rn
  }
  return(T)
}

# Creates a Transition Matrix from an Adjacency Matrix
TMatrix <- function(M){
  cn <- colnames(M)
  rn <- rownames(M)
  T <- matrix(rep(0,nrow(M)*ncol(M)),ncol(M))
  colnames(T) <- cn
  rownames(T) <- rn
  for (i in 1:ncol(M)){
    s <- sum(M[i,])
    if(s > 0){
      T[i,] <- M[i,]/s
#    } else {
#      T[i,] <- rep(1/ncol(M),ncol(M))
    }
  }
  return(T)
}

IsRowStoc <- function(M){
  ans <- TRUE
  for (i in 1:nrow(M)){
    if(sum(M[i,]) != 1){
      ans <- FALSE
      break()
    }
  }
  return(ans)
}

MakeRowStoc <- function(M){
  for (i in 1:nrow(M)){
    if(sum(M[i,]) != 1){
      M[i,] <- M[i,]+((1-sum(M[i,]))/ncol(M))
    }
  }
  return(M)
}

######################## Main Code ########################
print("All matrices use the convention 'from row to column'")

A <- rbind(a = c(a=0,b=0,c=0,d=0,e=0,f=1,g=0),
           b = c(a=0,b=0,c=0,d=0,e=0,f=0,g=1),
           c = c(a=0,b=0,c=0,d=0,e=0,f=0,g=0),
           d = c(a=0,b=0,c=1,d=0,e=0,f=0,g=0),
           e = c(a=0,b=1,c=1,d=1,e=0,f=0,g=0),
           f = c(a=1,b=1,c=0,d=1,e=1,f=0,g=0),
           g = c(a=1,b=0,c=1,d=0,e=0,f=0,g=0))

print("Adjacency Matrix:")
print(A)

# Identity Matrix for Strongly Conected Test (Not used)
I <- diag(rep(1,7))
verts <- c('a','b','c','d','e','f','g')
colnames(I) <- verts
rownames(I) <- verts

W <- TMatrix(A)
if (IsRowStoc(W)){
  print("The transition matrix is strongly connected.")
} else {
  print("The transition matrix is not strongly conected.")
  print("Forcing the matrix to be row-stochastic...")
  W <- MakeRowStoc(W)
}

print("Weighted transition matrix:")
print(W)

ESys <- eigen(t(W))
for (i in 1:length(ESys$values)){
  if(signif(ESys$values[i],7) == 1){
    EVec <- ESys$vectors[,i]
    break()
  }
}
P <- as.double(EVec/sum(EVec))
names(P) <- verts
print("Page rank from eigen-method:")
print(P)
P2 <- t(rep(1/ncol(W),ncol(W))) %*% MatrixPower(W,100)
print("Page rank from matrix-power-method:")
print(P2)
print("Test that both methods are equivilant to 7 significant figures:")
print(signif(P,7) == signif(P2,7))
