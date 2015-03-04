
#' Load GSL/AWL
#' 
#' Load the General Service List (GSL) developed by by Michael West (1953) 
#' and the Academic Word List developed by Coxhead (2000).
#' 
#' @return A list of word lists. Each list is represented as a character vector.
#' @examples
#' lists = LoadGslAwl()
LoadGslAwl = function() {
  
  data(GslAwl)
}

#' A utility function to clean text
#' 
#' A utility function to clean text
#' 
#' @param text A piece of text to be cleaned. Not a vector.
#' @return Cleaned text.
CleanText = function(text) {
  require(stringr)
  
  text = tolower(str_trim(text))
  text = gsub("^ *|(?<= ) | *$", "", text, perl=T) # remove extra spaces
  text = gsub("[^[:alnum:][:space:]']", "", text) # remove all punctuation except apostrophes
  text = gsub("\\d", "", text) # remove numbers
  return(text)
}

## LFP

#' Compute lexical frequency
#'
#' Compute lexical frequency for a piece of text.
#' 
#' @param text Text to be analyzed.
#' @param wordlist Word list to be used. Only GSL/AWL is currently supported.
#' @return An integer vector, containing frequencies for different types of 
#' words defined by the specified word list. 
#' @export
#' @examples
#' LexicalFrequency(some_awesome_text)
LexicalFrequency = function(text, wordlist="GslAwl") {
  # decide word list
  if(wordlist == "GslAwl") {
    LoadGslAwl()
    K1 = GslAwl$K1
    K2 = GslAwl$K2
    K3 = GslAwl$K3
  }
  
  text = CleanText(text)
  words = str_split(text, " ")[[1]]
  
  words_type = sapply(words, function(x) {
    if(x %in% K1) 1
    else if(x %in% K2) 2
    else if(x %in% K3) 3
    else 4
  })
  freq = table(words_type)
  if(wordlist == "GslAwl")
    names(freq) = c("FirstK", "SecondK", "AWL", "Beyond")
  return(freq)
}

## P_Lex

#' Segment a piece of text
#' 
#' Split a piece of text into segments of n words. This is a utility function for calculating P_Lex.
#' 
#' @param text The piece of text to be segmented.
#' @param len The length of each segment. In other words, the number of words in each segment.
#' @return Text segments, represented by a character vector.
GetSegments <- function(text, len = 10) {
  require(stringr)
  
  text = str_trim(text)
  total_len = length(str_split(text, " ")[[1]])
  
  if(total_len < len) return("")
  
  sapply(seq(1, as.integer(total_len / len)), function(i) {
    word(text, 1 + (i-1)*len, i*len)
  })
}

#' Count occurrences of "difficult" words
#' 
#' Given a list of "easy" words, count occurrences of "difficult" words---
#' words not in the provided easy word list. This is a utility function for 
#' calculating P_Lex.
#' 
#' @param text A piece (segment) of text to be counted.
#' @param easy_word_list A list of easy words.
#' @return The count of difficult words
CountDifficultWords <- function(text, easy_word_list) {
  if(nchar(text) == 0) return(0)
  words = str_split(text, " ")[[1]]
  sum(!(words %in% easy_word_list))
}

#' Calculate P_Lex for a piece of text
#' 
#' Calculate P_Lex for a piece of text. Technically, P_Lex is the lambda score 
#' of the distribution of counts of difficult words in segments of a piece of text.
#' 
#' @param text A piece of text to be analyzed.
#' @param len The number of words contained in each segment.
#' @param wordlist The word list the computation is based. Default: `GslAwl`.
#' Only GSL/AWL is currently supported. More will be added in the future.
#' @return A lamda score, with a higher score denoting more difficult text.
#' @export
#' @references
#' Meara, P., & Bell, H. (2001). P_Lex: A Simple and Effective Way of Describing the 
#' lexical Characteristics of Short L2 Tests. Prospect, 16(3), 5–19.
P_Lex <- function(text, len=10, wordlist="GslAwl") {
  require(MASS)
  
  # decide word list
  if(wordlist == "GslAwl") {
    LoadGslAwl()
    easy_word_list = GslAwl$K1
  }
  # get counts for segments
  segs = GetSegments(text, len)
  counts = as.vector(sapply(segs, function(x) CountDifficultWords(x, easy_word_list)))
  
  # fit distribution and get estimate
  f <- fitdistr(counts, "poisson")
  f$estimate
}
