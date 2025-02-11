install.packages("RMariaDB")
install.packages("DBI")

library(RMariaDB)
library(DBI)

con <- dbConnect(RMariaDB::MariaDB(),
                 dbname = "team11",
                 username = "team11",
                 password = "te@mzaii",
                 host = "giniewicz.it")

plik_csv <- "adresy_data.csv"
dane <- read.csv(plik_csv)
dbWriteTable(con, "Adresy", dane, append = TRUE, row.names = FALSE)

plik_csv <- "klienci_data.csv"
dane <- read.csv(plik_csv)
dbWriteTable(con, "Klienci", dane, append = TRUE, row.names = FALSE)

plik_csv <- "pracownicy_data.csv"
dane <- read.csv(plik_csv)
dbWriteTable(con, "Pracownicy", dane, append = TRUE, row.names = FALSE)

dbDisconnect(con)