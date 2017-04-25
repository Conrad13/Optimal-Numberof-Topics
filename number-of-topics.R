

### readning all the text files in directory and adding thhem to a single text file
setwd('C:\\Users\\Admin\\Desktop\\2008 Election_Docs')
filelist = list.files(pattern = ".*.TXT")
data <- NULL
for (f in filelist) {
  conn <- file(f,open="r")
  linn <-readLines(conn)
  
  #tempData = scan( f, what="character")
  data <- c(data,linn)    
  close(conn)
} 

write(data, "test_set.txt")
###

### preprocessing
library(tm)
data = tolower(data) #make it lower case
data = gsub('[[:punct:]]', '', data) #remove punctuation
#stopword removal
stopwords_regex = paste(stopwords('en'), collapse = '\\b|\\b')
stopwords_regex = paste0('\\b', stopwords_regex, '\\b')
data = stringr::str_replace_all(data, stopwords_regex, '')
###

### calculating document-term matrix
myCorpus <- Corpus(VectorSource(data))
dtm <- TermDocumentMatrix(myCorpus, control = list(removePunctuation = TRUE, stopwords=TRUE))
inspect(dtm)
###

################# finding the optimal number of topics
#install.packages("ldatuning")
library("ldatuning")
library("topicmodels")

#data("AssociatedPress", package="topicmodels")
#dtm <- AssociatedPress[1:10, ]

# Start the clock!
ptm <- proc.time()

result <- FindTopicsNumber(
  dtm,
  topics = seq(from = 2, to = 200, by = 1),
  metrics = c("Griffiths2004", "CaoJuan2009", "Arun2010", "Deveaud2014"),
  method = "Gibbs",
  control = list(seed = 77),
  mc.cores = 2L,
  verbose = TRUE
)

# Stop the clock
proc.time() - ptm



FindTopicsNumber_plot(result)
