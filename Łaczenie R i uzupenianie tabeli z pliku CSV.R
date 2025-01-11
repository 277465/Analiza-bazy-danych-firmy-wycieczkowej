install.packages("RMariaDB")
install.packages("DBI")

# Wczytanie danych z pliku CSV
plik_csv <- "klienci_data.csv"  # Ścieżka do pliku CSV
dane <- read.csv(plik_csv)

library(RMariaDB)
library(DBI)

con <- dbConnect(RMariaDB::MariaDB(),
                 dbname = "team11",
                 username = "team11",
                 password = "te@mzaii",
                 host = "giniewicz.it")

dbWriteTable(con, "Klienci", dane, append = TRUE, row.names = FALSE)
dbDisconnect(con)

query <- "SELECT * FROM Klienci LIMIT 10;"  # Pobiera 10 pierwszych wierszy
wyniki <- dbGetQuery(con, query)
print(wyniki)



query <- "DELETE FROM Klienci;"
dbExecute(con, query)