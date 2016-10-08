# Used for printing tables to PDF report
#install.packages('gridExtra')
library(grid)
library(gridExtra)

library(lattice)


#dir_name <- readline(prompt="Data directory: ")
dir_name <- "/home/brennap/Documents/school/MAT-616/doing_data_science/dds_datasets/dds_ch2_nyt"
#dir_contents <- list.files(path=dir_name, pattern='*.csv')
dir_contents <- c(list.files(path=dir_name, pattern='nyt..csv'), list.files(path=dir_name, pattern='nyt...csv'))
#dir_contents <- list.files(path=dir_name, pattern='nyt1.csv')
pdf(file="nyt_data.pdf")
par(mfrow = c(2,2))
for (csv in dir_contents) {
  nyt_data <- read.csv(file=paste(dir_name, csv, sep="/"))
  nyt_data$age_cat <- cut(nyt_data$Age, c(-Inf,0,18,24,34,44,54,64,Inf))
  nyt_data$ctr <- nyt_data$Clicks / nyt_data$Impressions
  nyt_data$Gender[nyt_data$Gender == 1] <- "male"
  nyt_data$Gender[nyt_data$Gender == 0] <- "female"
  nyt_data$Gender[nyt_data$Signed_In == 0] <- "unknown"
  nyt_data$Gender <- factor(nyt_data$Gender)
  #print(paste0("Analysis of ",csv))
  #print(summary(nyt_data))
  grid.arrange(grid.text(paste0("Summary of ",csv)),tableGrob(summary(nyt_data)))
  print(histogram(~ Impressions | age_cat, data=nyt_data,
                  main="Distribution of Impressions by Age Cat."))
  print(histogram(~ ctr | age_cat, data=nyt_data,
                  main="Distribution of CTR by Age Cat."))
  print(histogram(~ ctr | age_cat, data=subset(nyt_data,ctr != 0),
                  main="Distribution of Non-Zero CTR by Age Cat."))
  
  print(densityplot(~ Impressions | age_cat, groups=Gender, auto.key=T, data=nyt_data, plot.points=F,
                    main="Distribution of Impressions by Age Cat."))
  print(densityplot(~ ctr | age_cat, groups=Gender, auto.key=T, data=nyt_data, plot.points=F,
                    main="Distribution of CTR by Age Cat."))
  print(densityplot(~ ctr | age_cat, groups=Gender, auto.key=T, data=subset(nyt_data,ctr != 0), plot.points=F,
                    main="Distribution of Non-Zero CTR by Age Cat."))
  print(densityplot(~ ctr, groups=Signed_In, data=subset(nyt_data,ctr!=0), plot.points=F, auto.key=T,
              main="Distribution of Non-Zero CTR by Signed-In State"))
  
  
  print(bwplot(age_cat ~ ctr | Gender, data=subset(nyt_data, ctr != 0), layout=c(1,3),
               main="Distribution of Non-Zero CTR by Age and Gender"))
  
  
  #plot(nyt_data$Impressions, nyt_data$Clicks, pch=levels(factor(nyt_data$age_cat)))
  #lapply(split(nyt_data, nyt_data$Gender), 
  #   function(sub1)
  #      sapply(split(sub1, sub1$age_cat), 
  #         function(sub2) 
  #            colMeans(sub2[,c("Impressions","Clicks")],)
  #      )
  #)
  #print("Means of Impressions and Clicks by Demographic")
  nyt_data.means.new <- data.frame(t(sapply(split(nyt_data, list(nyt_data$Gender, nyt_data$age_cat), drop=T), 
         function(dfsub) {
            c(data=paste(csv),Gender=paste(levels(factor(dfsub$Gender))),
                       age_cat=paste(levels(factor(dfsub$age_cat))),Impressions.mean=mean(dfsub$Impressions), 
                       Clicks.mean=mean(dfsub$Clicks),size=nrow(dfsub))
         }
  )),row.names=NULL)
  if (exists("nyt_data.means")) rbind(nyt_data.means, nyt_data.means.new) else nyt_data.means <- nyt_data.means.new
  #sapply(split(nyt_data, list(nyt_data$Gender, nyt_data$age_cat), drop=T), 
  #       function(sub) {
  #         summary(sub$Impressions)
  #         summary(sub$Clicks)
  #       }
  #)
  #grid.arrange(tableGrob(rows=c('values'), cols=names(table), d=t(table)),
  #grid.arrange(tableGrob(as.data.frame(table)), main="Unclicked Impressions per Person by Demographic")
  #grid.arrange(tableGrob(as.data.frame(table)))
  
  rm(nyt_data)
}

grid.arrange(grid.text("Table of Means", draw=F), tableGrob(nyt_data.means))
dev.off()

