#https://www.businessinsider.com/how-to-use-a-pairs-trading-strategy-with-etfs-2013-2/?IR=T

source("cointegration.R")

#Try cointegration strategy against respective sector ETFs
snp500 = read.csv("snp500_list.csv", stringsAsFactors = F)

#Tabulate by sectors & industries
table(snp500$GICS.Sector)
# Consumer Discretionary           Consumer Staples                     Energy                 Financials                Health Care                Industrials 
# 80                         33                         31                         68                         63                         67 
# Information Technology                  Materials                Real Estate Telecommunication Services                  Utilities 
# 75                         24                         32                          3                         29 

table(snp500$GICS.Sub.Industry)

#Find cointegration pairs
fin = pair(snp500$Ticker.symbol[which(snp500$GICS.Sector == "Financials")])
tele = pair(snp500$Ticker.symbol[which(snp500$GICS.Sector == "Telecommunication Services")])


