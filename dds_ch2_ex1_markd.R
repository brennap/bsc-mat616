# Based on: http://www.reed.edu/data-at-reed/software/R/markdown_multiple_reports.html
# Paul Brennan
# Rscript --no-save --no-restore dds_ch2_ex1_markd.R

# Thanks StackOverflow! 
# http://stackoverflow.com/questions/4090169/elegant-way-to-check-for-missing-packages-and-install-them
# R can use a vector as an index key, allowing for nifty set-like things to happen
want.packages <- c("knitr","markdown","rmarkdown","gridExtra")
need.packages <- want.packages[!(want.packages %in% installed.packages()[,"Package"])]
if(length(need.packages)) install.packages(need.packages)
# Extra stuff is needed for CRAN setup if running from Rscript... oh well

# Packages for Markdown
library(knitr)
library(markdown)
library(rmarkdown)

# Used for printing tables to PDF report
#install.packages('gridExtra')
library(grid)
library(gridExtra)

# BaseGraphics++ (Not as nice as ggplot, but no extra packages)
#library(lattice)


#dir_name <- readline(prompt="Data directory: ")
dir_name <- "/home/brennap/Documents/school/MAT-616/doing_data_science/dds_datasets/dds_ch2_nyt"
dir_contents <- c(list.files(path=dir_name, pattern='nyt..csv'), list.files(path=dir_name, pattern='nyt...csv'))
#dir_contents <- list.files(path=dir_name, pattern='nyt1.csv')

for (csv in dir_contents) {
  print(paste0("Running markdown for ", csv))
  rmarkdown::render('./dds_ch2_ex1_markd.Rmd', output_file=paste0("report_", csv, '_', ".html"), output_dir='./html/')
  nyt_data.means.new <- data.frame(t(sapply(split(nyt_data, list(nyt_data$Gender, nyt_data$age_cat), drop=T), 
                  function(dfsub) {
                     c(data=paste(csv),Gender=paste(levels(factor(dfsub$Gender))),
                       age_cat=paste(levels(factor(dfsub$age_cat))),Impressions.mean=mean(dfsub$Impressions), 
                       Clicks.mean=mean(dfsub$Clicks),size=nrow(dfsub))
                  }
  )),row.names=NULL)
  if (exists("nyt_data.means")) rbind(nyt_data.means, nyt_data.means.new) else nyt_data.means <- nyt_data.means.new
  
}

grid.arrange(grid.text("Table of Means", draw=F), tableGrob(nyt_data.means))
quit(save="no") 
