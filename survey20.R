
#dir_name <- readline(prompt="Data directory: ")
dir_name <- "/home/brennap/Documents/school/MAT-616/survey20"
dir_contents <- list.files(path=dir_name, pattern='*.csv')
cols <- c("Surveyer","Volunteer","Gender","Major","Age","A1","A2")
survey <- data.frame()
for (csv in dir_contents) {
  tmp_survey <- read.csv(file=paste(dir_name, csv, sep="/"),header=FALSE,col.names=cols)
  tmp_survey[,"Volunteer"] <- toupper(tmp_survey[,"Volunteer"])
  tmp_survey[,"Gender"] <- toupper(tmp_survey[,"Gender"])
  tmp_survey[,"Major"] <- toupper(tmp_survey[,"Major"])
  tmp_survey$data_set <- rep(csv, nrow(tmp_survey))
  tmp_survey[grep('^ *M', tmp_survey$Gender),"Gender"] <- "MALE"
  tmp_survey[grep('^ *F', tmp_survey$Gender),"Gender"] <- "FEMALE"
  survey <- rbind(survey,tmp_survey)
}
survey$Gender <- factor(survey$Gender)
survey$data_set <- factor(survey$data_set)
survey$A1 <- as.numeric(gsub('[ a-z]*','',survey$A1))
survey$A2 <- as.numeric(gsub('[ a-z]*','',survey$A2))
survey$G1 <- (survey$A1 == 2)
survey$G2 <- (survey$A2 == 5)
survey[is.na(survey$A2),"G2"] <- FALSE


## Age Dist
boxplot(Age ~ G1, data=survey, main="Correct Answer 1 by Age", ylab="Age", xlab="Correct?")
boxplot(Age ~ G2, data=survey, main="Correct Answer 2 by Age", ylab="Age", xlab="Correct?")

## Raw Answer distribution
plot(x=survey$A1, y=survey$A2, log="", main="Distribution of Answers", xlab="Answer 1", ylab="Answer 2")
points(x=2,y=5,pch=19,col="red")
grid(nx=5,ny=5)
rug(survey$A1,side=1)
rug(survey$A2,side=2)

barplot(table(survey$A1),space=0,xlab="Question 1 Answers", ylab="Frequency", main="Answer 1 Distribution")
text(labels="Correct",x=50,srt=90,adj=c(0,1.5))
barplot(table(survey$A2),space=0,xlab="Question 2 Answers", ylab="Frequency", main="Answer 2 Distribution")
text(labels="Correct",x=100,srt=90,adj=c(0,8.1))

gmeans <- cbind(G1=sapply(levels(survey$data_set), function(csv){mean(survey[survey$data_set == csv,"G1"])}),
                G2=sapply(levels(survey$data_set), function(csv){mean(survey[survey$data_set == csv,"G2"])}))

dotchart(gmeans[,"G1"], main="Q1 Correct Rate" )
dotchart(gmeans[,"G2"], main="Q2 Correct Rate" )

cor(x=gmeans[,"G1"], y=gmeans[,"G2"])

## Custom Plot
ff.n <- nrow(survey[(survey$G1 == F & survey$G2 == F),])
tf.n <- nrow(survey[(survey$G1 == T & survey$G2 == F),])
ft.n <- nrow(survey[(survey$G1 == F & survey$G2 == T),])
tt.n <- nrow(survey[(survey$G1 == T & survey$G2 == T),])
t1.n <- tf.n + tt.n
t2.n <- ft.n + tt.n
f1.n <- ft.n + ff.n
f2.n <- tf.n + ff.n
mx <- max(t1.n,t2.n,f1.n,f2.n)*1.05
plot(x=NA,y=NA, xlim=c(-mx,mx), ylim=c(-mx,mx), xlab="A1", ylab="A2")
#grid()
# x/y axis
lines(x=c(-mx,mx), y=c(0,0), col="grey", lty=3)
lines(x=c(0,0), y=c(-mx,mx), col="grey", lty=3)
# Diagonal Guides
lines(x=c(-mx,mx),y=c(-mx,mx), col="grey", lty=3)
lines(x=c(-mx,mx),y=c(mx,-mx), col="grey", lty=3)
# Subsets
points(x=c(-ff.n, tf.n,tt.n,-ft.n),
        y=c(-ff.n,-tf.n,tt.n, ft.n))
text(x=c(-ff.n, tf.n,tt.n,-ft.n),
     y=c(-ff.n,-tf.n,tt.n, ft.n),
     labels=c("FF","TF","TT","FT"),adj=c(-0.5,-0.5))
# Range
lines(x=c(-f1.n,t1.n), y=c(0,0))
lines(x=c(0,0), y=c(-f2.n,t2.n))

# Horizontal Guides
lines(x=c(-mx,mx),y=c(tt.n,tt.n), col="grey", lty=3)
lines(x=c(-mx,mx),y=c(-tf.n,-tf.n), col="grey", lty=3)
lines(x=c(-mx,mx),y=c(ft.n,ft.n), col="grey", lty=3)
lines(x=c(-mx,mx),y=c(-ff.n,-ff.n), col="grey", lty=3)
# Verticle Guides
lines(y=c(-mx,mx),x=c(tt.n,tt.n), col="grey", lty=3)
lines(y=c(-mx,mx),x=c(tf.n,tf.n), col="grey", lty=3)
lines(y=c(-mx,mx),x=c(-ft.n,-ft.n), col="grey", lty=3)
lines(y=c(-mx,mx),x=c(-ff.n,-ff.n), col="grey", lty=3)
