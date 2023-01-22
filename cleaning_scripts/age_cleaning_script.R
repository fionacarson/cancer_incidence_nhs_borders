library(tidyverse)

age_data <- read_csv("raw_data/opendata_inc1620comb_hb_5_year_summary.csv") %>% 
  janitor::clean_names()

# Filter for NHS Borders data 
# Remove columns containing statistical qualifiers 
borders_age_data <- age_data %>% 
  filter(hb == "S08000016") %>% 
filter(!sex == "All") 


names(borders_age_data) <- sub('^incidences_', '', names(borders_age_data))
names(borders_age_data) <- sub('^incidence_', '', names(borders_age_data))

borders_age_data <- borders_age_data %>% 
  filter(!sex == "All") %>% 
  select(-ends_with("qf"), -starts_with("rate"), -starts_with("crude"), 
         -starts_with("easr"), -starts_with("wasr"), -starts_with("sir"),
         -"standardised_incidence_ratio")  
  
  
                    

rm(age_data)


# The following report was reviewed and the categories for the cancers refined 
# based on it. 
# https://publichealthscotland.scot/media/12645/2022-04-12-cancer-incidence-report.pdf


# Remove data which overlaps e.g. there is data categorised as C18, C18-C20 and 
# C19-20, only the C18-C20 was kept. 
# Data for all cancer types and for C44 which is non-melanoma skin cancer was removed.
# The data provided for "All cancer types" excludes C44 from the total. It is a 
# very high number and swamps the rest of the data. It is also not included in 
# the report linked above.
subset_borders_age_data <- borders_age_data %>% 
  filter(!cancer_site == "All cancer types") %>% 
  filter(!cancer_site_icd10code %in% 
           c("C44", "C44, M-8090-8098", "C44, M-8050-8078, M-8083-8084", "C18", "C19-C20", 
             "D06", "D18.0, D32-D33, D35.2-D35.4, D42-D43, D44.3-D44.5", "C00-C14", 
             "C70-C72, C75.1-C75.3, D18.0, D32-D33, D35.2-D35.4, D42-D43, D44.3-D44.5", 
             "C71", "D05", "C91.1", "C54", "C01-C06", "C92.0", 
             "C01, C02.4, C05.1, C05.2, C09, C10", "C03-C06", "C01-C02", "C53", 
             "C92.1-C92.2", "C91.0", "C07-C08", "C40-C41", "C47+C49", "C32")) %>% 
  mutate(cancer_site = replace(cancer_site, cancer_site == 
          "Malig brain ca (incl pit. gland, cranio. duct, pineal gland)", 
          "Malignant brain cancer"),
         cancer_site = replace(cancer_site, cancer_site == 
          "Multiple myeloma and malignant plasma cell neoplasms",
          "Plasma cell neoplasms (inc multiple myeloma)"),
          cancer_site = replace(cancer_site, cancer_site == 
          "Colorectal cancer",
          "Colorectal")
          )





write_csv(subset_borders_age_data, "clean_data/borders_age_data.csv")




         