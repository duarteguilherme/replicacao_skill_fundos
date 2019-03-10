library(dplyr)
library(purrr)


# Carregando funções para download e limpeza dos dados
source('R/functions.R')

# Fazendo download dos fatores do site do NEFIN
dados_nefin <- c('http://www.nefin.com.br/Risk%20Factors/Risk_Free.xls',
                 'http://www.nefin.com.br/Risk%20Factors/IML_Factor.xls',
                 'http://www.nefin.com.br/Risk%20Factors/WML_Factor.xls',
                 'http://www.nefin.com.br/Risk%20Factors/HML_Factor.xls',
                 'http://www.nefin.com.br/Risk%20Factors/SMB_Factor.xls',
                 'http://www.nefin.com.br/Risk%20Factors/Market_Factor.xls') %>%
  purrr::map(download_nefin) %>%
  purrr::reduce(dplyr::inner_join)
  
saveRDS(dados_nefin, 'data/dados_nefin.Rds')



fundos <- download_info_cadastral('20190301')

# Queremos apenas os fundos existentes antes de marco de 2018
# e que funcionaram ate fevereiro de 2019, em fncionamento normal
# e que sejam FIA
fundos <- fundos %>%
  filter(DT_INI_EXERC >= lubridate::dmy('01-03-2018'),
         DT_INI_EXERC < lubridate::dmy('01-03-2019'),
         CLASSE == "Fundo de Ações",
         SIT == "EM FUNCIONAMENTO NORMAL")

datas <- c(
  3:12 %>% 
    stringr::str_pad(2,pad = '0') %>%
    stringr::str_c('2018', .),
  "201901", "201902")


# Download dados dos fundos
dados_fundos <- purrr::map(datas,
                    ~ {
                      print(.x)
                      download_dados_data(.x) %>%
                        dplyr::inner_join(fundos, by = c("CNPJ_FUNDO")) #%>%
#                        dplyr::mutate_at(vars(starts_with("VL_")),
#                                              funs(as.character))
                      }) %>%
  dplyr::bind_rows()
    
    
saveRDS(dados_fundos, "data/dados_fundos.rds")





