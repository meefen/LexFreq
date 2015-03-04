# LexFreq

LexFreq is an R package for lexical frequency analysis. It currently implements Lexical Frequency Profile analysis and P_Lex.

## Installation

You can install `LexFreq` from `github` using the `devtools` package

```coffee
require(devtools)
install_github('meefen/LexFreq')
```

## Usage

Read help information of `LexicalFrequency` and `P_Lex` first.  Basically, feed a piece of text to either of these functions and you will get the results. Vectorized functions will be coming soon (hopefully).

```r
library(LexFreq)
text = "In the early months of that year, the Fed pressed ahead with the bold measures it had initiated in 2008 to arrest the financial crisis. By summer it had largely succeeded, and economists would later determine that the economy stopped shrinking in June. Officials then began to grapple with how the Fed could best support and hasten a recovery."
LexicalFrequency(text)
P_Lex(text)
```

## Resources

- [A case study of using lexical frequency analysis to evaluate student writing](http://meefen.github.io/blog/2015/02/04/longitudinal-productive-vocabulary/)
- Laufer, B. (2013). Lexical Frequency Profiles. In C. A. Chapelle (Ed.), The Encyclopedia of Applied Linguistics. Blackwell Publishing Ltd.
- Meara, P., & Bell, H. (2001). P_Lex: A Simple and Effective Way of Describing the lexical Characteristics of Short L2 Tests. Prospect, 16(3), 5–19.


## Disclaimer

I will not be responsible for any consequences of using this R package. Use it at your own risk.
