library(magrittr)
library(readr)
download_dados_data <- function(data) {
  dados <- glue::glue("http://dados.cvm.gov.br/dados/FI/DOC/INF_DIARIO/DADOS/inf_diario_fi_{data}.csv") %>%
    read.csv(encoding = "latin1", stringsAsFactors = F,
             sep = ";" )
}


download_info_cadastral <- function(data) {
  dados <- glue::glue("http://dados.cvm.gov.br/dados/FI/CAD/DADOS/inf_cadastral_fi_{data}.csv") %>%
    read.csv(encoding = "latin1", stringsAsFactors = F,
                                    sep = ";" )
}


#' Download base de dados do site do nefin
download_nefin <- function(link) {
  httr::GET(link, 
            httr::write_disk(tf <- tempfile(fileext = ".xls")))
  readxl::read_xls(tf) %>%
    dplyr::mutate(date = stringr::str_c(year, "-", month, "-", day) %>%
             lubridate::ymd()) %>%
    dplyr::select(-year, -month,-day)
  
}

