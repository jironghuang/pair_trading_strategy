#Note: Reference to https://www.r-bloggers.com/co-integration-and-pairs-trading/
#Market neutral strategies

#loading packages
pkgs <- list("quantmod", "doParallel", "foreach", "urca")
lapply(pkgs, require, character.only = T)
registerDoParallel(cores = detectCores())

jtest <- function(t1, t2) {
  tryCatch({
    start <- sd
    getSymbols(t1, from = start)
    getSymbols(t2, from = start)
    j <- summary(ca.jo(cbind(get(t1)[, 6], get(t2)[, 6])))
    r <- data.frame(stock1 = t1, stock2 = t2, stat = j@teststat[2])
    r[, c("pct10", "pct5", "pct1")] <- j@cval[2, ]
    return(r)    
  }, error = function(e){return(NULL)})
}

pair <- function(lst) {
  tryCatch({
  #Creating all combinations 
  d2 <- data.frame(t(combn(lst, 2)))
  stat <- foreach(i = 1:nrow(d2), .combine = rbind) %dopar% jtest(as.character(d2[i, 1]), as.character(d2[i, 2]))
  stat <- stat[order(-stat$stat), ]
  # THE PIECE GENERATING * CAN'T BE DISPLAYED PROPERLY IN WORDPRESS 
  rownames(stat) <- NULL
  return(stat)
  }, error = function(e){return(NULL)})
}

#Co-integration tests since 2010
sd <- "2010-01-01"
# tickers <- c("FITB", "BBT", "MTB", "STI", "PNC", "HBAN", "CMA", "USB", "KEY", "JPM", "C", "BAC", "WFC")
# pair(tickers)

#Think of this like a t-test, the pcts are like thresholds
#     stock1 stock2      stat pct10 pct5  pct1
# 1     STI    JPM 29.543505 12.91 14.9 19.19
# 2    FITB    MTB 22.332482 12.91 14.9 19.19
# 3     MTB    KEY 21.458409 12.91 14.9 19.19

