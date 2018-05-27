library(quanteda); 
quanteda_options("threads"=32)
library(tm)
library(dplyr)

mywordsToTest<-function(input){
   input_words<-words(input)
   n<-length(input_words)
   output<-""
   if (n <= 3 & n >= 1){
      output<-c(rep("", 3-n), input_words)
   } else if (n > 3) {
      start<-n-2
      output<-input_words[start:n]
   } 
   return(output)
}

sentenceToTest<-function(sentence){
   sentence<-tolower(sentence)
   stokens<-tokens(sentence, ngrams=1,
                   remove_numbers = TRUE, remove_punct = TRUE, 
                   remove_symbols = TRUE, remove_hyphens = TRUE, concatenator = " ")
   results<-mywordsToTest(stokens$text1)
   results<-setNames(results, c("word2", "word3", "word4"))
   return(results)
}


nextWord<-function(sentence, ngrams, max = 5){
   # using ngrams without freq2, freq3
   # On each ngram check it is set rest of frequencies to 0 to avoid counting several times the same occurrence
   
   test<-sentenceToTest(sentence)
   
   nextWordComing_df4<-filter(ngrams, word4 == test["word4"] & word3 == test["word3"] & word2 == test["word2"]) %>%
      group_by(word5) %>% summarize(freq4 = first(freq4)) %>% 
      as.data.frame %>% mutate(freq3=0, freq2=0) %>% select(word5, freq4, freq3, freq2) %>%
      arrange(desc(freq4))
   nextWordComing_df4<-unique(nextWordComing_df4)[1:max,]
   
   nextWordComing_df3<-filter(ngrams, word4 == test["word4"] & word3 == test["word3"]) %>%
      group_by(word5) %>% summarize(freq3 = sum(freq4)) %>% 
      as.data.frame %>% mutate(freq4=0, freq2=0) %>% select(word5, freq4, freq3, freq2) %>%
      arrange(desc(freq3))
   nextWordComing_df3<-unique(nextWordComing_df3)[1:max,]
   
   # case 2-gram but using freq3 as reference
   nextWordComing_df2<-filter(ngrams, word4 == test["word4"]) %>%
      group_by(word5) %>% summarize(freq2 = sum(freq4)) %>% 
      as.data.frame %>% mutate(freq4=0, freq3=0) %>% select(word5, freq4, freq3, freq2) %>%
      arrange(desc(freq2))
   nextWordComing_df2<-unique(nextWordComing_df2)[1:max,]
   
   nextWordComing_df<-filter(rbind(nextWordComing_df4, nextWordComing_df3, nextWordComing_df2),
                             !is.na(freq4) & !is.na(freq3) & !is.na(freq2)) %>%
      group_by(word5) %>% summarize(freq4 = sum(freq4), freq3 = sum(freq3), freq2 = sum(freq2)) %>% as.data.frame %>%
      arrange(desc(freq4), desc(freq3), desc(freq2))
   
   return(nextWordComing_df)
}

