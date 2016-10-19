library(stats)
nyt_data <- read.csv(file="doing_data_science/dds_datasets/dds_ch2_nyt/nyt1.csv")

nyt_data$ctr <- nyt_data$Clicks / nyt_data$Impressions
nyt_data$ctr[nyt_data$Impressions == 0] <- 0 # Fixes Div. by 0; Assumes Clisks = 0

nyt_data$Gender[nyt_data$Gender == 1] <- "male"
nyt_data$Gender[nyt_data$Gender == 0] <- "female"
nyt_data$Gender[nyt_data$Signed_In == 0] <- "unknown"
nyt_data$Gender <- factor(nyt_data$Gender)
nyt_data$Signed_In <- as.logical(nyt_data$Signed_In)

#cov(x, y = NULL, use = "everything",
#    method = c("pearson", "kendall", "spearman"))
C1.cols = c("Age","Impressions","Clicks","Signed_In","ctr")
C1 <- cov(nyt_data[,C1.cols])

#nyt_data$age_cat <- cut(nyt_data$Age, c(-Inf,0,18,24,34,44,54,64,Inf))
age_cats <- levels(cut(0, c(-Inf,0,18,24,34,44,54,64,Inf)))
nyt_data$age_cat.n <- as.numeric(cut(nyt_data$Age, c(-Inf,0,18,24,34,44,54,64,Inf)))
C2.cols = c("age_cat.n","Impressions","Clicks","Signed_In","ctr")
C2 <- cov(nyt_data[,C2.cols])


eigen(C2)
E2 <- eigen(C2)
E2$vectors %*% diag(E2$values) %*% solve(E2$vectors)
signif((E2$vectors %*% diag(E2$values) %*% solve(E2$vectors) ),digits=11) == signif(C2,digits=11)

P2 <- prcomp(nyt_data[,C2.cols], center=T, scale.=T)

P2.s <- prcomp(nyt_data[sample(nrow(nyt_data),500),C2.cols], center=T, scale.=T)
biplot(P2.s)

