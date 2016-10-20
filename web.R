I <- diag(rep(1,6))
names <- c('a','b','c','d','e','f')
colnames(I) <- names
rownames(I) <- names
A <- rbind(a = c(a=0,b=0,c=0,d=0,e=0,f=1,g=0),
           b = c(a=0,b=0,c=0,d=0,e=0,f=0,g=1),
           c = c(a=0,b=0,c=0,d=0,e=0,f=0,g=0),
           d = c(a=0,b=0,c=1,d=0,e=0,f=0,g=0),
           e = c(a=0,b=1,c=1,d=1,e=0,f=0,g=0),
           f = c(a=1,b=1,c=0,d=1,e=1,f=0,g=0),
           g = c(a=1,b=0,c=1,d=0,e=0,f=0,g=0))

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

TMatrix <- function(M){
  cn <- colnames(M)
  rn <- rownames(M)
  T <- matrix(rep(0,nrow(M)*ncol(M)),ncol(M))
  for (i in nrow(M)){
    T[,i] <- M[,i]/sum(M[,i])
  }
  colnames(T) <- cn
  rownames(T) <- rn
  return(T)
}


