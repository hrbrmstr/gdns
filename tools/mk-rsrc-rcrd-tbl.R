library(rvest)
library(tidyverse)

read_html("https://en.wikipedia.org/wiki/List_of_DNS_record_types") %>%
  html_node(xpath=".//table[contains(., 'Address record')]") %>%
  html_table() %>%
  tbl_df() %>%
  janitor::clean_names() %>%
  select(type=2, name=1, description=4, purpose=5) %>%
  filter(name != "ALIAS") %>%
  mutate(type = as.numeric(type)) -> resource_record_tbl

use_data(resource_record_tbl)

