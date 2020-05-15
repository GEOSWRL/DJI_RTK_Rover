# Script for Importing DJI RTK Rover point surveys
rm(list = ls())

library(dplyr)
library(stringr)
library(splitstackshape)

#establish a filepath for the raw GCP file:
Input <- "xxx.txt"

#establish the column names from the collected RTK data files
Columns <- c("altitude(m)", "antennaHeight(m)", "description", "index", "latitude", "longitude", "prefix", "stdAlt(cm)", "stdLat(cm)", "stdLng(cm)")

#read in the initial textfile and clean unnessessary characters/punctuation:
GCPraw <- readChar(Input, nchars = 2000); GCPraw
GCP1 <- sub("rtkPoints","", GCPraw);
GCP2 <- sub('^.......', '"', GCP1);
GCP3 <- sub('...$', '\n', GCP2);
GCP4 <- gsub('\\}.', '\n', GCP3);
GCP5 <- gsub('\\{', '', GCP4); GCP5 #double check that the start and end of the string look corrected

#convert to dataframe
df <- read.csv(text = GCP5, header = FALSE, stringsAsFactors = FALSE, sep = ','); head(df)

#split DJI's column headers from the columns and repopulate table with only relevant data
df1 <- cSplit(df, splitCols = c(1:10), sep = c(":"), drop = FALSE)
df2 <- df1 %>% select(ends_with("_2"));
colnames(df2) <- Columns; head(df2) #reapply proper column names

#reorder and remove uneccessary columns for convienience
final <- df2[ , c("description", "antennaHeight(m)", "latitude", "longitude", "altitude(m)",
                  "stdLat(cm)", "stdLng(cm)", "stdAlt(cm)")]

#write the cleaned GCP RTK points file to the same folder in format: "YYYMMDD_GCP_clean"
write.csv(final, file = "xxx", row.names = FALSE)
#write the cleaned GCP RTK points file to a GCP folder in format: "YYYMMDD_GCP_clean"
write.csv(final, file = "xxx", row.names = FALSE)

##### Firmware update revision - May 15th, 2020 - ZM #####
# Quick additional script to reorder and rename columns to match previous .csv outputs
#establish a filepath for the raw GCP file:
Input <- read.csv("/Users/t38b154/Desktop/20200514_HG_GCPs_20200515043337.csv", header = TRUE, stringsAsFactors = FALSE)

#establish the column names from the collected RTK data files
Columns <- c("description", "antennaHeight(m)", "latitude", "longitude", "altitude(m)",
             "stdLat(cm)", "stdLng(cm)", "stdAlt(cm)")

#reorder columns in Input
df1 <- Input[,c(10,6,3,4,5,7,8,9)]

#rename columns of df1 to matching column names
colnames(df1) <- Columns; head(df1)

#write the cleaned GCP RTK points file to the same folder in format: "YYYMMDD_GCP_clean"
write.csv(df1, file = "xxx", row.names = FALSE)
         
