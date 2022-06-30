####Info----

      #Title: Full ACS Pull
      #Name: Nissim Lebovits
      #Date: 12/20/2021
      #Purpose: To pull, clean, weight, and aggregate 2009, 2014, & 2019 ACS data
      #for the West Philadelphia Promise Zone.

####Outline----

      #Part 1: Set up workspace----
      
              #Step 1: Library
              #Step 2: Working directory
              #Step 3: Census API
              #Step 4: Variables list
      
      
      #Part 2: Create necessary vectors----
      
              #Step 1: Tract vector
              #Step 2: Population vectors
              #Step 3: Education vectors
              #Step 4: Health vectors
              #Step 5: Housing vectors
              #Step 6: Workforce & econ vectors
      
      
      #Part 3: Pull initial variables & rename----
            
  
              #2019----
                #Step 1: Tract vector
                #Step 2: Population vectors
                #Step 3: Education vectors
                #Step 4: Health vectors
                #Step 5: Housing vectors
                #Step 6: Workforce & econ vectors
      
              #2014----
                #Step 1: Tract vector
                #Step 2: Population vectors
                #Step 3: Education vectors
                #Step 4: Health vectors
                #Step 5: Housing vectors
                #Step 6: Workforce & econ vectors
      
              #2009----
                #Step 1: Tract vector
                #Step 2: Population vectors
                #Step 3: Education vectors
                #Step 4: Health vectors
                #Step 5: Housing vectors
                #Step 6: Workforce & econ vectors
      
    

  
      #Part 4: Mutate to create any new variables----

              #Step 1: Create dataframe for each year
              #Step 2: Filter for just variables in the PZ tracts
              #Step 3: Calculate new variables & their MOEs


      #Part 5: Weight by tract----

              #Step 1: Read in .csv of weights
              #Step 2: Convert variables according to appropriate weights
      
      #Part 6: Export as .csv files----
        
              #Step 1: Use write.csv()

      #Part 7: Congrats! You're done!----





####Body----

      ####Part 1----
      
                #Step 1: Library----
                      #Pulls necessary packages
                      library(tidyverse) #For data cleaning & wrangling
                      library(tidycensus) #For working with census data
                      library(dplyr) #For data cleaning & wrangling
                      library(acs) #For working with ACS data
      
                #Step 2: Working directory----
                      #Sets the file on your computer where imported or exported files will be.
                      setwd("C:/Users/Nissim.Lebovits/OneDrive - City of Philadelphia/Desktop/Data/R Scripts and Datasets/American Communities Survey")
      
                #Step 3: Census API----
                    #Sets the API key that you will need to pull ACS and Census data
                    api_key <- "812d5d318590089998837d65be111f34b01526c3"
                    
                    census_api_key(api_key,
                                   install = TRUE,
                                   overwrite = TRUE)
                    
                    readRenviron("~/.Renviron")
      
                #Step 4: Variables list----
      
                    #Sets the list of variables that you will pull from.
                    #This will make your pull faster and make it easier
                    #to check if you've made a mistake.
      
      acs_variable_list.2019 <- load_variables(2019,
                                               "acs5",
                                               cache = TRUE)
      
      acs_variable_list.2014 <- load_variables(2014,
                                               "acs5",
                                                cache = TRUE)
      
      acs_variable_list.2009 <- load_variables(2009,
                                               "acs5",
                                               cache = TRUE)
      
      

      ####Part 2: Create necessary vectors----
      
                #Step 1: Tract vector----
                    #PZ census tracts, including partial ones
                    pzTracts <- c('42101008602',
                                  '42101008701',
                                  '42101008702',
                                  '42101008801',
                                  '42101008802',
                                  '42101009000',
                                  '42101009100',
                                  '42101009200',
                                  '42101010500',
                                  '42101010600',
                                  '42101010700',
                                  '42101010800',
                                  '42101010900',
                                  '42101011000',
                                  '42101036900',
                                  '42101980000')
      
                #Step 2: Population vectors----
                    #Overall population
                    pop.vars <- c("B01003_001E", #Total population
                                  "B11001_001E", #Total number of households
                                  "B11001_006") #Total number of one person female households
                    
                    #Sex
                    sex.vars <- c("B01001_002E", #Total male population
                                  "B01001_026E") #Total female population
                    
                    #Age
                    age.vars <- c("B01002_001", #Median age
                                  "B09001_001", #Total population under 18
                                  "B01001_020E", #Male:!!65 and 66 years
                                  "B01001_021E", #Male:!!67 to 69 years
                                  "B01001_022E", #Male:!!70 to 74 years
                                  "B01001_044E", #Female:!!65 and 66 years
                                  "B01001_045E", #Female:!!67 to 69 years
                                  "B01001_046E", #Female:!!70 to 74 years
                                  "B01001_023E", #Male:!!75 to 79 years
                                  "B01001_024E", #Male:!!80 to 84 years
                                  "B01001_025E", #Male:!!85 years and over
                                  "B01001_047E", #Female:!!75 to 79 years
                                  "B01001_048E", #Female:!!80 to 84 years
                                  "B01001_049E") #Female:!!85 years and over
                    
                    
                    #Race & Ethnicity            
                    race.ethn.vars <- c(#Race
                                        "B02001_002E", #Total white population
                                        "B02001_003E", #Total Black population
                                        "B02001_004E", #American Indian and Alaska Native alone
                                        "B02001_005E", #Total Asian population
                                        "B02001_006E", #Native Hawaiian and Other Pacific Islander alone
                                        "B02001_007E", #Some other race alone
                                        "B02001_008E", #Two or more races
                                        #Ethnicity
                                        "B01001I_001E") #Total: Hispanic or Latino
      
      
                #Step 3: Education vectors----
                    
                    #Education
                    edu.vars <- c("B15003_001E", #Total:25+
                                  "B15003_017E", #Regular high school diploma
                                  "B15003_018E", #GED or alternative credential
                                  "B15003_019E", #Some college, less than 1 year
                                  "B15003_020E", #Some college, 1 or more years, no degree
                                  "B15003_021E", #Associate's degree
                                  "B15003_022E", #Bachelor's degree
                                  "B15003_023E", #Master's degree
                                  "B15003_024E", #Professional school degree
                                  "B15003_025E",  #Doctorate degree 
                                  "B14001_002E", #Total 3+ enrolled in school
                                  "B14001_003E", #Enrolled in school:!!Enrolled in nursery school, preschool
                                  "B14001_004E", #Enrolled in school:!!Enrolled in kindergarten
                                  "B14001_005E", #Enrolled in school:!!Enrolled in grade 1 to grade 4
                                  "B14001_006E", #Enrolled in school:!!Enrolled in grade 5 to grade 8
                                  "B14001_007E", #Enrolled in school:!!Enrolled in grade 9 to grade 12
                                  "B14001_008E", #Enrolled in school:!!Enrolled in college, undergraduate years
                                  "B14001_009E", #Enrolled in school:!!Graduate or professional school
                                  "B14002_006E", #Males enrolled in private pre-K 
                                  "B14002_009E", #Males enrolled in private kindergarten
                                  "B14002_012E", #Males enrolled in private school, grades 1-4 
                                  "B14002_015E", #Males enrolled in private school, grades 5-8 
                                  "B14002_018E", #Males enrolled in private school, grades 9-12
                                  "B14002_030E", #Females enrolled in private pre-K; 
                                  "B14002_033E", #Females enrolled in private kindergarten; 
                                  "B14002_036E", #Females enrolled in private school, grades 1-4; 
                                  "B14002_039E", #Females enrolled in private school, grades 5-8; 
                                  "B14002_042E", #Females enrolled in private school, grades 9-12; 
                                  "B14002_005E", #Males enrolled in public pre-K; 
                                  "B14002_008E", #Males enrolled in public kindergarten; 
                                  "B14002_011E", #Males enrolled in public school, grades 1-4; 
                                  "B14002_014E", #Males enrolled in public school, grades 5-8; 
                                  "B14002_017E", #Males enrolled in public school, grades 9-12; 
                                  "B14002_029E", #Females enrolled in public pre-K; 
                                  "B14002_032E", #Females enrolled in public kindergarten; 
                                  "B14002_035E", #Females enrolled in public school, grades 1-4; 
                                  "B14002_038E", #Females enrolled in public school, grades 5-8; 
                                  "B14002_041E") #Females enrolled in public school, grades 9-12; 
                    
                    
                #Step 4: Health vectors----
                    
                    #Health insurance coverage
                    health.ins.vars <- c("B27010_001E", #Total: Types of Health Insurance Coverage by Age
                                         "B27010_006", #Pop w/o health insurance (pub. or priv.) under 19 years old
                                         "B27010_011", #Pop w/o health insurance (pub. or priv.) 19 to 34 years old
                                         "B27010_016", #Pop w/o health insurance (pub. or priv.) 35 to 64 years old
                                         "B27010_021", #Pop w/o health insurance (pub. or priv.) 65 years old and older
                                         "B27010_004", #Pop. w/only medicare or medicaid, under 19 years old.
                                         "B27010_009", #Pop. w/only medicare or medicaid, 19 to 34 years old.
                                         "B27010_014", #Pop. w/only medicare or medicaid, 35 to 64 years old.
                                         "B27010_019") #Pop. w/only medicare or medicaid, 65 years old and older.
                    
                    #Disability
                    disability.vars <- c("C18108_005E", #Civ noninstitutionalized population under 18 with no disability; 
                                         "C18108_009E", #Civ noninstitutionalized population 18 to 64 with no disability; 
                                         "C18108_013E") #Civ noninstitutionalized population 65 and over with no disability
                    
                    
                #Step 5: Housing vectors----
                    
                    #Housing Occupancy and Vacancy, Home value, age of home, mortgage status
                    housing.basic.vars <-c("B25001_001E", #Number of residential units
                                           "B25002_002E", #Occupied
                                           "B25002_003E", #Vacant
                                           "B25004_004E", #For sale only
                                           "B25004_002E", #For rent
                                           "B25003_002E", #Owner occupied
                                           "B25003_003E", #Renter occupied
                                           "B25077_001E", #Median house value (dollars)
                                           "B25027_002E", #Housing units with a mortgage:
                                           "B25027_010E", #Housing units without a mortgage:
                                           "B07013_005E", #Lived in same house one year ago--Householder lived in owner-occupied housing units; 
                                           "B07013_006E") #Lived in same house one year ago--Householder lived in renter-occupied housing units
                    
                    
                    #Housing costs & cost burdens
                    housing.cost.vars <- c("B25088_002E", #Median selected monthly owner costs (dollars) --!!Housing units with a mortgage (dollars)
                                           "B25088_003E", #Median selected monthly owner costs (dollars) --!!Housing units without a mortgage (dollars)
                                           "B25091_009E", #Housing units with a mortgage:!!35.0 to 39.9 percent
                                           "B25091_010E", #Housing units with a mortgage:!!40.0 to 49.9 percent
                                           "B25091_011E", #Housing units with a mortgage:!!50.0 percent or more
                                           "B25091_020E", #Housing units without a mortgage:!!35.0 to 39.9 percent
                                           "B25091_021E", #Housing units without a mortgage:!!40.0 to 49.9 percent
                                           "B25091_022E", #Housing units without a mortgage:!!50.0 percent or more
                                           "B25064_001E", #Median gross rent
                                           "B25070_002E", #Rent less than 10.0 percent
                                           "B25070_003E", #Rent 10.0 to 14.9 percent
                                           "B25070_004E", #Rent 15.0 to 19.9 percent
                                           "B25070_005E", #Rent 20.0 to 24.9 percent
                                           "B25070_006E", #Rent 25.0 to 29.9 percent
                                           "B25070_007E", #Rent 30.0 to 34.9 percent
                                           "B25070_008E", #Rent 35.0 to 39.9 percent
                                           "B25070_009E", #Rent 40.0 to 49.9 percent
                                           "B25070_010E") #Rent 50.0 percent or more
                    
                    
                    #Household asset availability
                    hh.asset.vars <- c("B08201_002E", #No vehicle available
                                       "B25043_007E", #Owner occupied:!!No telephone service available:
                                       "B25043_016E", #Renter occupied:!!No telephone service available:
                                       "B28001_011E", #No Computer
                                       "B28002_013E") #No internet access
                    
                    
                    #shorter version of var list because only 2019 forward has data on computer & internet
                    hh.asset.vars.short <- c("B08201_002E", #No vehicle available
                                             "B25043_007E", #Owner occupied:!!No telephone service available:
                                             "B25043_016E") #Renter occupied:!!No telephone service available:
                    
                    
                #Step 6: Workforce & econ vectors----
                    
                    #Poverty
                    pov.vars <- c("B17001_001E", #PovStatDet
                                  "B17001_002E") #Income in the past 12 months below poverty level:
                    
                    #Employment
                    empl.vars <- c("B23025_001E", #Total: pop 16 plus
                                   "B23025_003E", #In labor force:!!Civilian labor force:
                                   "B23025_004E", #In labor force:!!Civilian labor force:!!Employed
                                   "B23025_005E", #In labor force:!!Civilian labor force:!!Unemployed
                                   "B23022_001E", #Total: 16 to 64
                                   "B23013_001E", #Median age of workers 16 to 64 years
                                   "B24090_001E", #Total:Workers 16 to 64 who worked full-time year-round
                                   "B23020_001E", #Mean usual hours worked for workers 16 to 64 years 
                                   "B23001_007", #Males 16 to 19 employed in civilian labor force
                                   "B23001_014", #Males 20 to 24 employed in civilian labor force
                                   "B23001_053", #Females 16 to 19 employed in civilian labor force
                                   "B23001_060", #Females 20 to 24 employed in civilian labor force
                                   "B23027_006E", #Did not work in the last 12 months, ages 16 to 19; 
                                   "B23027_011E") #Did not work in the last 12 months, ages 20 to 24
                    
                    
                    #Income & Benefits
                    inc.vars <- c("B19013_001E", #Median household income
                                  "B19057_002E", #Number of households receiving cash public assistance
                                  "B22001_002E", #Household received food stamps/SNAP in past 12 months
                                  "B19067_001E") #Aggregate cash public assistance income
                    
                    
                    #Commute to Work
                    commute.vars <- c("B08008_001E", #Total:WORKERS BY PLACE OF WORK--PLACE LEVEL
                                      "B08008_003E", #Worked inside tract of residence
                                      "B08008_004E", #Worked outside tract of residence
                                      "B08101_001E", #Total Means of Transportation to Work
                                      "B08101_009E", #Car, truck, or van - drove alone:
                                      "B08101_017E", #Car, truck, or van - carpooled,
                                      "B08101_025E", #Took public transit to work
                                      "B08013_001E") #Aggregate Travel Time To Work
                    
      
      ####Part 3: Pull and rename initial variables----
                    #Pull data for each set of variables, in each year, and rename the variables
                    #The longer pieces of code do exactly what's stated above.
                    #The shorter pieces take out the "GEOID" and "NAME" columns from all tables in a year except for the pop.vars tables.
                    #At the end of each year's section, the code binds all the separate tables together into one table for the year.
                    #Taking off "GEOID" and "NAME" columns for most tables ensures that there won't be duplicates of these columns in the final table.
                    
                    
                  #2019----
                    
                    #Step 1: Population vectors----
                    
                    pop.vars.2019.raw <- get_acs(geography = "tract", # What is the lowest level of geography are we interested in?
                                                 year = 2019, # What year do we want - this can also be used for 2000 census data
                                                 variables = pop.vars, # let's use our variables we specified above
                                                 geometry = FALSE, # Do we want this as a shapefile? No, not now.
                                                 state = "PA", # What state?
                                                 county = "Philadelphia", # What County?
                                                 output = "wide") %>% # get a "wide" data type
                                                  rename(TotPop=B01003_001E,
                                                         MOE_TotPop=B01003_001M,
                                                         Households=B11001_001E,
                                                         MOE_Households=B11001_001M,
                                                         One_Person_Fem_HH=B11001_006E,
                                                         MOE_One_Person_Fem_HH=B11001_006M)
                                                
                    
                    sex.vars.2019.raw <- get_acs(geography = "tract", year = 2019, variables = sex.vars, geometry = FALSE, 
                                                 state = "PA", county = "Philadelphia", output = "wide") %>%
                                                  rename(Male=B01001_002E,
                                                         MOE_Male=B01001_002M,
                                                         Female=B01001_026E,
                                                         MOE_Female=B01001_026M)
                    
                    sex.vars.2019.raw.col <- sex.vars.2019.raw %>%
                      select(-"GEOID", -"NAME")
                    
                    
                    
                    age.vars.2019.raw <- get_acs(geography = "tract", year = 2019, variables = age.vars, geometry = FALSE, 
                                                 state = "PA", county = "Philadelphia", output = "wide") %>%
                                                  rename(MedAge=B01002_001E,
                                                         MOE_MedAge=B01002_001M,
                                                         Under18=B09001_001E,
                                                         MOE_Under18=B09001_001M,
                                                         Male65to66=B01001_020E,
                                                         MOE_Male65to66=B01001_020M,
                                                         Male67to69=B01001_021E,
                                                         MOE_Male67to69=B01001_021M,
                                                         Male70to74=B01001_022E,
                                                         MOE_Male70to74=B01001_022M,
                                                         Fem65to66=B01001_044E,
                                                         MOE_Fem65to66=B01001_044M,
                                                         Fem67to69=B01001_045E,
                                                         MOE_Fem67to69=B01001_045M,
                                                         Fem70to74=B01001_046E,
                                                         MOE_Fem70to74=B01001_046M,
                                                         Male75to79=B01001_023E,
                                                         MOE_Male75to79=B01001_023M,
                                                         Male80to84=B01001_024E,
                                                         MOE_Male80to84=B01001_024M,
                                                         Male85Plus=B01001_025E,
                                                         MOE_Male85Plus=B01001_025M,
                                                         Fem75to79=B01001_047E,
                                                         MOE_Fem75to79=B01001_047M,
                                                         Fem80to84=B01001_048E,
                                                         MOE_Fem80to84=B01001_048M,
                                                         Fem85Plus=B01001_049E,
                                                         MOE_Fem85Plus=B01001_049M)
                    
                    age.vars.2019.raw.col <- age.vars.2019.raw %>%
                      select(-"GEOID", -"NAME")
                    
                    
                    race.ethn.vars.2019.raw <- get_acs(geography = "tract", year = 2019, variables = race.ethn.vars, geometry = FALSE, 
                                                       state = "PA", county = "Philadelphia", output = "wide") %>%
                                                        rename(RaceWh=B02001_002E,
                                                               MOE_RaceWh=B02001_002M,
                                                               RaceBl=B02001_003E,
                                                               MOE_RaceBl=B02001_003M,
                                                               RaceAIAN=B02001_004E,
                                                               MOE_RaceAIAN=B02001_004M,
                                                               RaceAsian=B02001_005E,
                                                               MOE_RaceAsian=B02001_005M,
                                                               RaceNHPI=B02001_006E,
                                                               MOE_RaceNHPI=B02001_006M,
                                                               RaceOther=B02001_007E,
                                                               MOE_RaceOther=B02001_007M,
                                                               RaceTwoPlus=B02001_008E,
                                                               MOE_RaceTwoPlus=B02001_008M,
                                                               #Ethnicity
                                                               EthnHispLat=B01001I_001E,
                                                               MOE_EthnHispLat=B01001I_001M)
                    
                    race.ethn.vars.2019.raw.col <- race.ethn.vars.2019.raw %>%
                      select(-"GEOID", -"NAME")
                    
                    
                    pov.vars.2019.raw <- get_acs(geography = "tract", year = 2019, variables = pov.vars, geometry = FALSE, 
                                                 state = "PA", county = "Philadelphia", output = "wide") %>%
                                                  rename(PovStatDet=B17001_001E,
                                                         MOE_PovStatDet=B17001_001M,
                                                         IncBelPov=B17001_002E,
                                                         MOE_IncBelPov=B17001_002M)
                    
                    pov.vars.2019.raw.col <- pov.vars.2019.raw %>%
                      select(-"GEOID", -"NAME")
                    
                    
                    #Step 2: Education vectors----
                    
                    edu.vars.2019.raw <- get_acs(geography = "tract", year = 2019, variables = edu.vars, 
                                                 geometry = FALSE, state = "PA", county = "Philadelphia",
                                                 output = "wide") %>% 
                      rename(Tot25Plus=B15003_001E,
                             MOE_Tot25Plus=B15003_001M,
                             HSDip=B15003_017E,
                             MOE_HSDip=B15003_017M,
                             GED=B15003_018E,
                             MOE_GED=B15003_018M,
                             SomeCollLess1=B15003_019E,
                             MOE_SomeCollLess1=B15003_019M,
                             SomeColl1Plus=B15003_020E,
                             MOE_SomeColl1Plus=B15003_020M,
                             AssocDeg=B15003_021E,
                             MOE_AssocDeg=B15003_021M,
                             BachDeg=B15003_022E,
                             MOE_BachDeg=B15003_022M,
                             MastersDeg=B15003_023E,
                             MOE_MastersDeg=B15003_023M,
                             ProfSchDeg=B15003_024E,
                             MOE_ProfSchDeg=B15003_024M,
                             Doctorate=B15003_025E,
                             MOE_Doctorate=B15003_025M,
                             Tot3PlusEnr=B14001_002E,
                             MOE_Tot3PlusEnr=B14001_002M,
                             EnrPreK=B14001_003E,
                             MOE_EnrPreK=B14001_003M,
                             EnrKinder=B14001_004E,
                             MOE_EnrKinder=B14001_004M,
                             Enr1to4=B14001_005E,
                             MOE_Enr1to4=B14001_005M,
                             Enr5to8=B14001_006E,
                             MOE_Enr5to8=B14001_006M,
                             Enr9to12=B14001_007E,
                             MOE_Enr9to12=B14001_007M,
                             EnrUndergrad=B14001_008E,
                             MOE_EnrUndergrad=B14001_008M,
                             EnrGrad=B14001_009E,
                             MOE_EnrGrad=B14001_009M,
                             Males_PreK_Public=B14002_005E,
                             MOE_Males_PreK_Public=B14002_005M,
                             Males_PreK_Private=B14002_006E,
                             MOE_Males_PreK_Private=B14002_006M,
                             Males_Kinder_Public=B14002_008E,
                             MOE_Males_Kinder_Public=B14002_008M,
                             Males_Kinder_Private=B14002_009E,
                             MOE_Males_Kinder_Private=B14002_009M,
                             Males_1_to_4_Public=B14002_011E,
                             MOE_Males_1_to_4_Public=B14002_011M,
                             Males_1_to_4_Private=B14002_012E,
                             MOE_Males_1_to_4_Private=B14002_012M,
                             Males_5_to_8_Public=B14002_014E,
                             MOE_Males_5_to_8_Public=B14002_014M,
                             Males_5_to_8_Private=B14002_015E,
                             MOE_Males_5_to_8_Private=B14002_015M,
                             Males_9_to_12_Public=B14002_017E,
                             MOE_Males_9_to_12_Public=B14002_017M,
                             Males_9_to_12_Private=B14002_018E,
                             MOE_Males_9_to_12_Private=B14002_018M,
                             Fem_PreK_Public=B14002_029E,
                             MOE_Fem_PreK_Public=B14002_029M,
                             Fem_PreK_Private=B14002_030E,
                             MOE_Fem_PreK_Private=B14002_030M,
                             Fem_Kinder_Public=B14002_032E,
                             MOE_Fem_Kinder_Public=B14002_032M,
                             Fem_Kinder_Private=B14002_033E,
                             MOE_Fem_Kinder_Private=B14002_033M,
                             Fem_1_to_4_Public=B14002_035E,
                             MOE_Fem_1_to_4_Public=B14002_035M,
                             Fem_1_to_4_Private=B14002_036E,
                             MOE_Fem_1_to_4_Private=B14002_036M,
                             Fem_5_to_8_Public=B14002_038E,
                             MOE_Fem_5_to_8_Public=B14002_038M,
                             Fem_5_to_8_Private=B14002_039E,
                             MOE_Fem_5_to_8_Private=B14002_039M,
                             Fem_9_to_12_Public=B14002_041E,
                             MOE_Fem_9_to_12_Public=B14002_041M,
                             Fem_9_to_12_Private=B14002_042E,
                             MOE_Fem_9_to_12_Private=B14002_042M)
                    
                    
                    edu.vars.2019.raw.col <- edu.vars.2019.raw %>%
                      select(-"GEOID", -"NAME")
                    
                    
                    #Step 3: Health vectors----
                    
                    health.ins.vars.2019.raw <- get_acs(geography = "tract", year = 2019, variables = health.ins.vars, geometry = FALSE, 
                                                        state = "PA", county = "Philadelphia", output = "wide") %>%
                      rename(TotInsurance=B27010_001E,
                             MOE_TotInsurance=B27010_001M,
                             Uninsured_Under_19=B27010_006E,
                             MOE_Uninsured_Under_19=B27010_006M,
                             Uninsured_19_to_34=B27010_011E,
                             MOE_Uninsured_19_to_34=B27010_011M,
                             Uninsured_35_to_64=B27010_016E,
                             MOE_Uninsured_35_to_64=B27010_016M,
                             Uninsured_Over_65=B27010_021E,
                             MOE_Uninsured_Over_65=B27010_021M,
                             Medicare_Or_Medicaid_Under_19=B27010_004E,
                             MOE_Medicare_Or_Medicaid_Under_19=B27010_004M,
                             Medicare_Or_Medicaid_19_to_34=B27010_009E,
                             MOE_Medicare_Or_Medicaid_19_to_34=B27010_009M,
                             Medicare_Or_Medicaid_35_to_64=B27010_014E,
                             MOE_Medicare_Or_Medicaid_35_to_64=B27010_014M,
                             Medicare_Or_Medicaid_Over_65=B27010_019E,
                             MOE_Medicare_Or_Medicaid_Over_65=B27010_019M)
                    
                    
                    health.ins.vars.2019.raw.col <- health.ins.vars.2019.raw %>%
                      select(-"GEOID", -"NAME")
                    
                    
                    disability.vars.2019.raw <- get_acs(geography = "tract", year = 2019, variables = disability.vars, 
                                                        geometry = FALSE,state = "PA", county = "Philadelphia", 
                                                        output = "wide") %>%
                      rename(No_Disability_Under_18=C18108_005E,
                             MOE_No_Disability_Under_18=C18108_005M,
                             No_Disability_19_to_64=C18108_009E,
                             MOE_No_Disability_19_to_64=C18108_009M,
                             No_Disability_Over_65=C18108_013E,
                             MOE_No_Disability_Over_65=C18108_013M)
                    
                    disability.vars.2019.raw.col <- disability.vars.2019.raw %>%
                      select(-"GEOID", -"NAME")
                    
                    
                    #Step 4: Housing vectors----
                    
                    
                    housing.basic.vars.2019.raw <- get_acs(geography = "tract", year = 2019, variables = housing.basic.vars, geometry = FALSE, 
                                                           state = "PA", county = "Philadelphia", output = "wide") %>%
                      rename(#Housing occupancy and vacancy
                        TotHousUnits=B25001_001E,
                        MOE_TotHousUnits=B25001_001M,
                        HousUnitsOcc=B25002_002E,
                        MOE_HousUnitsOcc=B25002_002M,
                        HousUnitsVac=B25002_003E,
                        MOE_HousUnitsVac=B25002_003M,
                        VacantForSaleOnly=B25004_004E,
                        MOE_VacantForSaleOnly=B25004_004M,
                        VacantForRent=B25004_002E,
                        MOE_VacantForRent=B25004_002M,
                        OwnerOccUnits=B25003_002E,
                        MOE_OwnerOccUnits=B25003_002M,
                        RenterOccUnits=B25003_003E,
                        MOE_RenterOccUnits=B25003_003M,
                        #Home value, age of home, mortgage status
                        MedOwnOccHomeValue=B25077_001E,
                        MOE_MedOwnOccHomeValue=B25077_001M,
                        UnitsWithMortgage=B25027_002E,
                        MOE_UnitsWithMortgage=B25027_002M,
                        UnitsWOutMortgage=B25027_010E,
                        MOE_UnitsWOutMortgage=B25027_010M,
                        Lives_in_Same_Place_Owns=B07013_005E,
                        MOE_Lives_in_Same_Place_Owns=B07013_005M,
                        Lives_in_Same_Place_Rents=B07013_006E,
                        MOE_Lives_in_Same_Place_Rents=B07013_006M)
                    
                    housing.basic.vars.2019.raw.col <- housing.basic.vars.2019.raw %>%
                      select(-"GEOID", -"NAME")
                    
                    
                    housing.cost.vars.2019.raw <- get_acs(geography = "tract", year = 2019, variables = housing.cost.vars, geometry = FALSE, 
                                                          state = "PA", county = "Philadelphia", output = "wide") %>%
                      rename(MedSMOCWithMortgage=B25088_002E,
                             MOE_MedSMOCWithMortgage=B25088_002M,
                             MedSMOCWOutMortgage=B25088_003E,
                             MOE_MedSMOCWOutMortgage=B25088_003M,
                             SMOCAPI35to399WithMortgage=B25091_009E,
                             MOE_SMOCAPI35to399WithMortgage=B25091_009M,
                             SMOCAPI40to499WithMortgage=B25091_010E,
                             MOE_SMOCAPI40to499WithMortgage=B25091_010M,
                             SMOCAPI50PlusWithMortgage=B25091_011E,
                             MOE_SMOCAPI50PlusWithMortgage=B25091_011M,
                             SMOCAPI35to399WOutMortgage=B25091_020E,
                             MOE_SMOCAPI35to399WOutMortgage=B25091_020M,
                             SMOCAPI40to499WOutMortgage=B25091_021E,
                             MOE_SMOCAPI40to499WOutMortgage=B25091_021M,
                             SMOCAPI50PlusWOutMortgage=B25091_022E,
                             MOE_SMOCAPI50PlusWOutMortgage=B25091_022M,
                             MedGrossRent=B25064_001E,
                             MOE_MedGrossRent=B25064_001M,
                             GRAPI_Under_10_Perc=B25070_002E,
                             MOE_GRAPI_Under_10_Perc=B25070_002M,
                             GRAPI10to149Perc=B25070_003E,
                             MOE_GRAPI10to149Perc=B25070_003M,
                             GRAPI15to199Perc=B25070_004E,
                             MOE_GRAPI15to199Perc=B25070_004M,
                             GRAPI20to249Perc=B25070_005E,
                             MOE_GRAPI20to249Perc=B25070_005M,
                             GRAPI25to299Perc=B25070_006E,
                             MOE_GRAPI25to299Perc=B25070_006M,
                             GRAPI30to349Perc=B25070_007E,
                             MOE_GRAPI30to349Perc=B25070_007M,
                             GRAPI35to399Perc=B25070_008E,
                             MOE_GRAPI35to399Perc=B25070_008M,
                             GRAPI40to499Perc=B25070_009E,
                             MOE_GRAPI40to499Perc=B25070_009M,
                             GRAPI50PlusPerc=B25070_010E,
                             MOE_GRAPI50PlusPerc=B25070_010M)
                    
                    housing.cost.vars.2019.raw.col <- housing.cost.vars.2019.raw %>%
                      select(-"GEOID", -"NAME")
                    
                    
                    hh.asset.vars.2019.raw <- get_acs(geography = "tract", year = 2019, variables = hh.asset.vars, geometry = FALSE, 
                                                      state = "PA", county = "Philadelphia", output = "wide") %>%
                      rename(NoVehiclesAvailable=B08201_002E,
                             MOE_NoVehiclesAvailable=B08201_002M,
                             OwnerOccNoTele=B25043_007E,
                             MOE_OwnerOccNoTele=B25043_007M,
                             RenterOccNoTele=B25043_016E,
                             MOE_RenterOccNoTele=B25043_016M,
                             NoComputer=B28001_011E,
                             MOE_NoComputer=B28001_011M,
                             NoInternet=B28002_013E,
                             MOE_NoInternet=B28002_013M)
                    
                    hh.asset.vars.2019.raw.col <- hh.asset.vars.2019.raw %>%
                      select(-"GEOID", -"NAME")
                    
                    
                    #Step 5: Workforce & econ vectors----
                    
                    pov.vars.2019.raw <- get_acs(geography = "tract", year = 2019, variables = pov.vars, geometry = FALSE, 
                                                 state = "PA", county = "Philadelphia", output = "wide") %>%
                                                  rename(PovStatDet=B17001_001E,
                                                         MOE_PovStatDet=B17001_001M,
                                                         IncBelPov=B17001_002E,
                                                         MOE_IncBelPov=B17001_002M)
                                   
                    pov.vars.2019.raw.col <- pov.vars.2019.raw %>%
                      select(-"GEOID", -"NAME")
                    
                    
                    
                    empl.vars.2019.raw <- get_acs(geography = "tract", year = 2019, variables = empl.vars, geometry = FALSE, 
                                                  state = "PA", county = "Philadelphia", output = "wide") %>%
                                                  rename(Pop16Plus=B23025_001E,
                                                         MOE_Pop16Plus=B23025_001M,
                                                         InCivLabFor=B23025_003E,
                                                         MOE_InCivLabFor=B23025_003M,
                                                         Employed=B23025_004E,
                                                         MOE_Employed=B23025_004M,
                                                         Unemployed=B23025_005E,
                                                         MOE_Unemployed=B23025_005M,
                                                         Age16to64=B23022_001E,
                                                         MOE_Age16to64=B23022_001M,
                                                         MedAgeWorkers=B23013_001E,
                                                         MOE_MedAgeWorkers=B23013_001M,
                                                         TotFullTimeYrRnd=B24090_001E,
                                                         MOE_TotFullTimeYrRnd=B24090_001M,
                                                         MeanHrsWorked=B23020_001E,
                                                         MOE_MeanHrsWorked=B23020_001M,
                                                         Male_16_to_19_Civ_Empl=B23001_007E,
                                                         MOE_Male_16_to_19_Civ_Empl=B23001_007M,
                                                         Male_20_to_24_Civ_Empl=B23001_014E,
                                                         MOE_Male_20_to_24_Civ_Empl=B23001_014M,
                                                         Fem_16_to_19_Civ_Empl=B23001_053E,
                                                         MOE_Fem_16_to_19_Civ_Empl=B23001_053M,
                                                         Fem_20_to_24_Civ_Empl=B23001_060E,
                                                         MOE_Fem_20_to_24_Civ_Empl=B23001_060M,
                                                         Unempl_16_to_19=B23027_006E,
                                                         MOE_Unempl_16_to_19=B23027_006M,
                                                         Unempl_20_to_24=B23027_011E,
                                                         MOE_Unempl_20_to_24=B23027_011M)
                    
                    empl.vars.2019.raw.col <- empl.vars.2019.raw %>%
                      select(-"GEOID", -"NAME")
                    
                    
                    
                    inc.vars.2019.raw <- get_acs(geography = "tract", year = 2019, variables = inc.vars, geometry = FALSE, 
                                                 state = "PA", county = "Philadelphia", output = "wide") %>%
                                                  rename(MedHHInc=B19013_001E,
                                                         MOE_MedHHInc=B19013_001M,
                                                         WithPubAssistInc=B19057_002E,
                                                         MOE_WithPubAssistInc=B19057_002M,
                                                         AggPubAssistInc=B19067_001E,
                                                         MOE_AggPubAssistInc=B19067_001M,
                                                         SNAP=B22001_002E,
                                                         MOE_SNAP=B22001_002M)
                    
                    inc.vars.2019.raw.col <- inc.vars.2019.raw %>%
                      select(-"GEOID", -"NAME")
                    
                    
                    commute.vars.2019.raw <- get_acs(geography = "tract", year = 2019, variables = commute.vars, geometry = FALSE, 
                                                     state = "PA", county = "Philadelphia", output = "wide") %>%
                                                      rename(Workers16Plus=B08008_001E,
                                                             MOE_Workers16Plus=B08008_001M,
                                                             WorkInPlaceOfResidence=B08008_003E,
                                                             MOE_WorkInPlaceOfResidence=B08008_003M,
                                                             WorkOutOfPlaceOfResidence=B08008_004E,
                                                             MOE_WorkOutOfPlaceOfResidence=B08008_004M,
                                                             TotTravelToWork=B08101_001E,
                                                             MOE_TotTravelToWork=B08101_001M,
                                                             DroveAloneToWork=B08101_009E,
                                                             MOE_DroveAloneToWork=B08101_009M,
                                                             CarpooledToWork=B08101_017E,
                                                             MOE_CarpooledToWork=B08101_017M,
                                                             PublicTransitToWork=B08101_025E,
                                                             MOE_PublicTransitToWork=B08101_025M,
                                                             AggTravTimeWork=B08013_001E,
                                                             MOE_AggTravTimeWork=B08013_001M)
                    
                    commute.vars.2019.raw.col <- commute.vars.2019.raw %>%
                      select(-"GEOID", -"NAME")
                    
                    
                    
                    
                  #2014----
                    
                    #Step 1: Population vectors----
                    
                    pop.vars.2014.raw <- get_acs(geography = "tract", # What is the lowest level of geography are we interested in?
                                                 year = 2014, # What year do we want - this can also be used for 2000 census data
                                                 variables = pop.vars, # let's use our variables we specified above
                                                 geometry = FALSE, # Do we want this as a shapefile? No, not now.
                                                 state = "PA", # What state?
                                                 county = "Philadelphia", # What County?
                                                 output = "wide") %>% # get a "wide" data type
                      rename(TotPop=B01003_001E,
                             MOE_TotPop=B01003_001M,
                             Households=B11001_001E,
                             MOE_Households=B11001_001M,
                             One_Person_Fem_HH=B11001_006E,
                             MOE_One_Person_Fem_HH=B11001_006M)
                    
                    
                    sex.vars.2014.raw <- get_acs(geography = "tract", year = 2014, variables = sex.vars, geometry = FALSE, 
                                                 state = "PA", county = "Philadelphia", output = "wide") %>%
                      rename(Male=B01001_002E,
                             MOE_Male=B01001_002M,
                             Female=B01001_026E,
                             MOE_Female=B01001_026M)
                    
                    sex.vars.2014.raw.col <- sex.vars.2014.raw %>%
                      select(-"GEOID", -"NAME")
                    
                    
                    
                    age.vars.2014.raw <- get_acs(geography = "tract", year = 2014, variables = age.vars, geometry = FALSE, 
                                                 state = "PA", county = "Philadelphia", output = "wide") %>%
                      rename(MedAge=B01002_001E,
                             MOE_MedAge=B01002_001M,
                             Under18=B09001_001E,
                             MOE_Under18=B09001_001M,
                             Male65to66=B01001_020E,
                             MOE_Male65to66=B01001_020M,
                             Male67to69=B01001_021E,
                             MOE_Male67to69=B01001_021M,
                             Male70to74=B01001_022E,
                             MOE_Male70to74=B01001_022M,
                             Fem65to66=B01001_044E,
                             MOE_Fem65to66=B01001_044M,
                             Fem67to69=B01001_045E,
                             MOE_Fem67to69=B01001_045M,
                             Fem70to74=B01001_046E,
                             MOE_Fem70to74=B01001_046M,
                             Male75to79=B01001_023E,
                             MOE_Male75to79=B01001_023M,
                             Male80to84=B01001_024E,
                             MOE_Male80to84=B01001_024M,
                             Male85Plus=B01001_025E,
                             MOE_Male85Plus=B01001_025M,
                             Fem75to79=B01001_047E,
                             MOE_Fem75to79=B01001_047M,
                             Fem80to84=B01001_048E,
                             MOE_Fem80to84=B01001_048M,
                             Fem85Plus=B01001_049E,
                             MOE_Fem85Plus=B01001_049M)
                    
                    age.vars.2014.raw.col <- age.vars.2014.raw %>%
                      select(-"GEOID", -"NAME")
                    
                    
                    race.ethn.vars.2014.raw <- get_acs(geography = "tract", year = 2014, variables = race.ethn.vars, geometry = FALSE, 
                                                       state = "PA", county = "Philadelphia", output = "wide") %>%
                      rename(RaceWh=B02001_002E,
                             MOE_RaceWh=B02001_002M,
                             RaceBl=B02001_003E,
                             MOE_RaceBl=B02001_003M,
                             RaceAIAN=B02001_004E,
                             MOE_RaceAIAN=B02001_004M,
                             RaceAsian=B02001_005E,
                             MOE_RaceAsian=B02001_005M,
                             RaceNHPI=B02001_006E,
                             MOE_RaceNHPI=B02001_006M,
                             RaceOther=B02001_007E,
                             MOE_RaceOther=B02001_007M,
                             RaceTwoPlus=B02001_008E,
                             MOE_RaceTwoPlus=B02001_008M,
                             #Ethnicity
                             EthnHispLat=B01001I_001E,
                             MOE_EthnHispLat=B01001I_001M)
                    
                    race.ethn.vars.2014.raw.col <- race.ethn.vars.2014.raw %>%
                      select(-"GEOID", -"NAME")
                    
                    
                    pov.vars.2014.raw <- get_acs(geography = "tract", year = 2014, variables = pov.vars, geometry = FALSE, 
                                                 state = "PA", county = "Philadelphia", output = "wide") %>%
                      rename(PovStatDet=B17001_001E,
                             MOE_PovStatDet=B17001_001M,
                             IncBelPov=B17001_002E,
                             MOE_IncBelPov=B17001_002M)
                    
                    pov.vars.2014.raw.col <- pov.vars.2014.raw %>%
                      select(-"GEOID", -"NAME")
                    
                    
                    #Step 2: Education vectors----
                    
                    edu.vars.2014.raw <- get_acs(geography = "tract", year = 2014, variables = edu.vars, 
                                                 geometry = FALSE, state = "PA", county = "Philadelphia",
                                                 output = "wide") %>% 
                      rename(Tot25Plus=B15003_001E,
                             MOE_Tot25Plus=B15003_001M,
                             HSDip=B15003_017E,
                             MOE_HSDip=B15003_017M,
                             GED=B15003_018E,
                             MOE_GED=B15003_018M,
                             SomeCollLess1=B15003_019E,
                             MOE_SomeCollLess1=B15003_019M,
                             SomeColl1Plus=B15003_020E,
                             MOE_SomeColl1Plus=B15003_020M,
                             AssocDeg=B15003_021E,
                             MOE_AssocDeg=B15003_021M,
                             BachDeg=B15003_022E,
                             MOE_BachDeg=B15003_022M,
                             MastersDeg=B15003_023E,
                             MOE_MastersDeg=B15003_023M,
                             ProfSchDeg=B15003_024E,
                             MOE_ProfSchDeg=B15003_024M,
                             Doctorate=B15003_025E,
                             MOE_Doctorate=B15003_025M,
                             Tot3PlusEnr=B14001_002E,
                             MOE_Tot3PlusEnr=B14001_002M,
                             EnrPreK=B14001_003E,
                             MOE_EnrPreK=B14001_003M,
                             EnrKinder=B14001_004E,
                             MOE_EnrKinder=B14001_004M,
                             Enr1to4=B14001_005E,
                             MOE_Enr1to4=B14001_005M,
                             Enr5to8=B14001_006E,
                             MOE_Enr5to8=B14001_006M,
                             Enr9to12=B14001_007E,
                             MOE_Enr9to12=B14001_007M,
                             EnrUndergrad=B14001_008E,
                             MOE_EnrUndergrad=B14001_008M,
                             EnrGrad=B14001_009E,
                             MOE_EnrGrad=B14001_009M,
                             Males_PreK_Public=B14002_005E,
                             MOE_Males_PreK_Public=B14002_005M,
                             Males_PreK_Private=B14002_006E,
                             MOE_Males_PreK_Private=B14002_006M,
                             Males_Kinder_Public=B14002_008E,
                             MOE_Males_Kinder_Public=B14002_008M,
                             Males_Kinder_Private=B14002_009E,
                             MOE_Males_Kinder_Private=B14002_009M,
                             Males_1_to_4_Public=B14002_011E,
                             MOE_Males_1_to_4_Public=B14002_011M,
                             Males_1_to_4_Private=B14002_012E,
                             MOE_Males_1_to_4_Private=B14002_012M,
                             Males_5_to_8_Public=B14002_014E,
                             MOE_Males_5_to_8_Public=B14002_014M,
                             Males_5_to_8_Private=B14002_015E,
                             MOE_Males_5_to_8_Private=B14002_015M,
                             Males_9_to_12_Public=B14002_017E,
                             MOE_Males_9_to_12_Public=B14002_017M,
                             Males_9_to_12_Private=B14002_018E,
                             MOE_Males_9_to_12_Private=B14002_018M,
                             Fem_PreK_Public=B14002_029E,
                             MOE_Fem_PreK_Public=B14002_029M,
                             Fem_PreK_Private=B14002_030E,
                             MOE_Fem_PreK_Private=B14002_030M,
                             Fem_Kinder_Public=B14002_032E,
                             MOE_Fem_Kinder_Public=B14002_032M,
                             Fem_Kinder_Private=B14002_033E,
                             MOE_Fem_Kinder_Private=B14002_033M,
                             Fem_1_to_4_Public=B14002_035E,
                             MOE_Fem_1_to_4_Public=B14002_035M,
                             Fem_1_to_4_Private=B14002_036E,
                             MOE_Fem_1_to_4_Private=B14002_036M,
                             Fem_5_to_8_Public=B14002_038E,
                             MOE_Fem_5_to_8_Public=B14002_038M,
                             Fem_5_to_8_Private=B14002_039E,
                             MOE_Fem_5_to_8_Private=B14002_039M,
                             Fem_9_to_12_Public=B14002_041E,
                             MOE_Fem_9_to_12_Public=B14002_041M,
                             Fem_9_to_12_Private=B14002_042E,
                             MOE_Fem_9_to_12_Private=B14002_042M)
                    
                    
                    edu.vars.2014.raw.col <- edu.vars.2014.raw %>%
                      select(-"GEOID", -"NAME")
                    
                    
                    #Step 3: Health vectors----
                    
                    health.ins.vars.2014.raw <- get_acs(geography = "tract", year = 2014, variables = health.ins.vars, geometry = FALSE, 
                                                        state = "PA", county = "Philadelphia", output = "wide") %>%
                      rename(TotInsurance=B27010_001E,
                             MOE_TotInsurance=B27010_001M,
                             Uninsured_Under_19=B27010_006E,
                             MOE_Uninsured_Under_19=B27010_006M,
                             Uninsured_19_to_34=B27010_011E,
                             MOE_Uninsured_19_to_34=B27010_011M,
                             Uninsured_35_to_64=B27010_016E,
                             MOE_Uninsured_35_to_64=B27010_016M,
                             Uninsured_Over_65=B27010_021E,
                             MOE_Uninsured_Over_65=B27010_021M,
                             Medicare_Or_Medicaid_Under_19=B27010_004E,
                             MOE_Medicare_Or_Medicaid_Under_19=B27010_004M,
                             Medicare_Or_Medicaid_19_to_34=B27010_009E,
                             MOE_Medicare_Or_Medicaid_19_to_34=B27010_009M,
                             Medicare_Or_Medicaid_35_to_64=B27010_014E,
                             MOE_Medicare_Or_Medicaid_35_to_64=B27010_014M,
                             Medicare_Or_Medicaid_Over_65=B27010_019E,
                             MOE_Medicare_Or_Medicaid_Over_65=B27010_019M)
                    
                    
                    health.ins.vars.2014.raw.col <- health.ins.vars.2014.raw %>%
                      select(-"GEOID", -"NAME")
                    
                    
                    disability.vars.2014.raw <- get_acs(geography = "tract", year = 2014, variables = disability.vars, 
                                                        geometry = FALSE,state = "PA", county = "Philadelphia", 
                                                        output = "wide") %>%
                      rename(No_Disability_Under_18=C18108_005E,
                             MOE_No_Disability_Under_18=C18108_005M,
                             No_Disability_19_to_64=C18108_009E,
                             MOE_No_Disability_19_to_64=C18108_009M,
                             No_Disability_Over_65=C18108_013E,
                             MOE_No_Disability_Over_65=C18108_013M)
                    
                    disability.vars.2014.raw.col <- disability.vars.2014.raw %>%
                      select(-"GEOID", -"NAME")
                    
                    
                    #Step 4: Housing vectors----
                    
                    
                    housing.basic.vars.2014.raw <- get_acs(geography = "tract", year = 2014, variables = housing.basic.vars, geometry = FALSE, 
                                                           state = "PA", county = "Philadelphia", output = "wide") %>%
                      rename(#Housing occupancy and vacancy
                        TotHousUnits=B25001_001E,
                        MOE_TotHousUnits=B25001_001M,
                        HousUnitsOcc=B25002_002E,
                        MOE_HousUnitsOcc=B25002_002M,
                        HousUnitsVac=B25002_003E,
                        MOE_HousUnitsVac=B25002_003M,
                        VacantForSaleOnly=B25004_004E,
                        MOE_VacantForSaleOnly=B25004_004M,
                        VacantForRent=B25004_002E,
                        MOE_VacantForRent=B25004_002M,
                        OwnerOccUnits=B25003_002E,
                        MOE_OwnerOccUnits=B25003_002M,
                        RenterOccUnits=B25003_003E,
                        MOE_RenterOccUnits=B25003_003M,
                        #Home value, age of home, mortgage status
                        MedOwnOccHomeValue=B25077_001E,
                        MOE_MedOwnOccHomeValue=B25077_001M,
                        UnitsWithMortgage=B25027_002E,
                        MOE_UnitsWithMortgage=B25027_002M,
                        UnitsWOutMortgage=B25027_010E,
                        MOE_UnitsWOutMortgage=B25027_010M,
                        Lives_in_Same_Place_Owns=B07013_005E,
                        MOE_Lives_in_Same_Place_Owns=B07013_005M,
                        Lives_in_Same_Place_Rents=B07013_006E,
                        MOE_Lives_in_Same_Place_Rents=B07013_006M)
                    
                    housing.basic.vars.2014.raw.col <- housing.basic.vars.2014.raw %>%
                      select(-"GEOID", -"NAME")
                    
                    
                    housing.cost.vars.2014.raw <- get_acs(geography = "tract", year = 2014, variables = housing.cost.vars, geometry = FALSE, 
                                                          state = "PA", county = "Philadelphia", output = "wide") %>%
                      rename(MedSMOCWithMortgage=B25088_002E,
                             MOE_MedSMOCWithMortgage=B25088_002M,
                             MedSMOCWOutMortgage=B25088_003E,
                             MOE_MedSMOCWOutMortgage=B25088_003M,
                             SMOCAPI35to399WithMortgage=B25091_009E,
                             MOE_SMOCAPI35to399WithMortgage=B25091_009M,
                             SMOCAPI40to499WithMortgage=B25091_010E,
                             MOE_SMOCAPI40to499WithMortgage=B25091_010M,
                             SMOCAPI50PlusWithMortgage=B25091_011E,
                             MOE_SMOCAPI50PlusWithMortgage=B25091_011M,
                             SMOCAPI35to399WOutMortgage=B25091_020E,
                             MOE_SMOCAPI35to399WOutMortgage=B25091_020M,
                             SMOCAPI40to499WOutMortgage=B25091_021E,
                             MOE_SMOCAPI40to499WOutMortgage=B25091_021M,
                             SMOCAPI50PlusWOutMortgage=B25091_022E,
                             MOE_SMOCAPI50PlusWOutMortgage=B25091_022M,
                             MedGrossRent=B25064_001E,
                             MOE_MedGrossRent=B25064_001M,
                             GRAPI_Under_10_Perc=B25070_002E,
                             MOE_GRAPI_Under_10_Perc=B25070_002M,
                             GRAPI10to149Perc=B25070_003E,
                             MOE_GRAPI10to149Perc=B25070_003M,
                             GRAPI15to199Perc=B25070_004E,
                             MOE_GRAPI15to199Perc=B25070_004M,
                             GRAPI20to249Perc=B25070_005E,
                             MOE_GRAPI20to249Perc=B25070_005M,
                             GRAPI25to299Perc=B25070_006E,
                             MOE_GRAPI25to299Perc=B25070_006M,
                             GRAPI30to349Perc=B25070_007E,
                             MOE_GRAPI30to349Perc=B25070_007M,
                             GRAPI35to399Perc=B25070_008E,
                             MOE_GRAPI35to399Perc=B25070_008M,
                             GRAPI40to499Perc=B25070_009E,
                             MOE_GRAPI40to499Perc=B25070_009M,
                             GRAPI50PlusPerc=B25070_010E,
                             MOE_GRAPI50PlusPerc=B25070_010M)
                    
                    housing.cost.vars.2014.raw.col <- housing.cost.vars.2014.raw %>%
                                                         select(-"GEOID", -"NAME")
                    

                    #In the hh.asset.vars vector, we have two variables (NoComputer and NoInternet)
                    #that were not included in the 2014 ACS. To avoid messing up our code,
                    #I'm using the subset() function to disinclude them from this pull. I'll
                    #do the same for similar situations throughout the rest of the code.
                    hh.asset.vars.2014.raw <- get_acs(geography = "tract", year = 2014, 
                                                      variables = (subset(hh.asset.vars,
                                                                    (hh.asset.vars != "B28001_011E" & 
                                                                     hh.asset.vars !=   "B28002_013E"))),
                                                      geometry = FALSE, state = "PA", county = "Philadelphia", output = "wide") %>%
                      rename(NoVehiclesAvailable=B08201_002E,
                             MOE_NoVehiclesAvailable=B08201_002M,
                             OwnerOccNoTele=B25043_007E,
                             MOE_OwnerOccNoTele=B25043_007M,
                             RenterOccNoTele=B25043_016E,
                             MOE_RenterOccNoTele=B25043_016M)#,
                             #NoComputer=B28001_011E,
                             #MOE_NoComputer=B28001_011M,
                             #NoInternet=B28002_013E,
                            # MOE_NoInternet=B28002_013M)
                    
                    hh.asset.vars.2014.raw.col <- hh.asset.vars.2014.raw %>%
                      select(-"GEOID", -"NAME")
                    
                    
                        
                    #Step 5: Workforce & econ vectors----
                    
                    pov.vars.2014.raw <- get_acs(geography = "tract", year = 2014, variables = pov.vars, geometry = FALSE, 
                                                 state = "PA", county = "Philadelphia", output = "wide") %>%
                      rename(PovStatDet=B17001_001E,
                             MOE_PovStatDet=B17001_001M,
                             IncBelPov=B17001_002E,
                             MOE_IncBelPov=B17001_002M)
                    
                    pov.vars.2014.raw.col <- pov.vars.2014.raw %>%
                      select(-"GEOID", -"NAME")
                    
                    
                    
                    empl.vars.2014.raw <- get_acs(geography = "tract", year = 2014, variables = empl.vars, geometry = FALSE, 
                                                  state = "PA", county = "Philadelphia", output = "wide") %>%
                      rename(Pop16Plus=B23025_001E,
                             MOE_Pop16Plus=B23025_001M,
                             InCivLabFor=B23025_003E,
                             MOE_InCivLabFor=B23025_003M,
                             Employed=B23025_004E,
                             MOE_Employed=B23025_004M,
                             Unemployed=B23025_005E,
                             MOE_Unemployed=B23025_005M,
                             Age16to64=B23022_001E,
                             MOE_Age16to64=B23022_001M,
                             MedAgeWorkers=B23013_001E,
                             MOE_MedAgeWorkers=B23013_001M,
                             TotFullTimeYrRnd=B24090_001E,
                             MOE_TotFullTimeYrRnd=B24090_001M,
                             MeanHrsWorked=B23020_001E,
                             MOE_MeanHrsWorked=B23020_001M,
                             Male_16_to_19_Civ_Empl=B23001_007E,
                             MOE_Male_16_to_19_Civ_Empl=B23001_007M,
                             Male_20_to_24_Civ_Empl=B23001_014E,
                             MOE_Male_20_to_24_Civ_Empl=B23001_014M,
                             Fem_16_to_19_Civ_Empl=B23001_053E,
                             MOE_Fem_16_to_19_Civ_Empl=B23001_053M,
                             Fem_20_to_24_Civ_Empl=B23001_060E,
                             MOE_Fem_20_to_24_Civ_Empl=B23001_060M,
                             Unempl_16_to_19=B23027_006E,
                             MOE_Unempl_16_to_19=B23027_006M,
                             Unempl_20_to_24=B23027_011E,
                             MOE_Unempl_20_to_24=B23027_011M)
                    
                    empl.vars.2014.raw.col <- empl.vars.2014.raw %>%
                      select(-"GEOID", -"NAME")
                    
                    
                    
                    inc.vars.2014.raw <- get_acs(geography = "tract", year = 2014, variables = inc.vars, geometry = FALSE, 
                                                 state = "PA", county = "Philadelphia", output = "wide") %>%
                      rename(MedHHInc=B19013_001E,
                             MOE_MedHHInc=B19013_001M,
                             WithPubAssistInc=B19057_002E,
                             MOE_WithPubAssistInc=B19057_002M,
                             AggPubAssistInc=B19067_001E,
                             MOE_AggPubAssistInc=B19067_001M,
                             SNAP=B22001_002E,
                             MOE_SNAP=B22001_002M)
                    
                    inc.vars.2014.raw.col <- inc.vars.2014.raw %>%
                      select(-"GEOID", -"NAME")
                    
                    
                    commute.vars.2014.raw <- get_acs(geography = "tract", year = 2014, variables = commute.vars, geometry = FALSE, 
                                                     state = "PA", county = "Philadelphia", output = "wide") %>%
                      rename(Workers16Plus=B08008_001E,
                             MOE_Workers16Plus=B08008_001M,
                             WorkInPlaceOfResidence=B08008_003E,
                             MOE_WorkInPlaceOfResidence=B08008_003M,
                             WorkOutOfPlaceOfResidence=B08008_004E,
                             MOE_WorkOutOfPlaceOfResidence=B08008_004M,
                             TotTravelToWork=B08101_001E,
                             MOE_TotTravelToWork=B08101_001M,
                             DroveAloneToWork=B08101_009E,
                             MOE_DroveAloneToWork=B08101_009M,
                             CarpooledToWork=B08101_017E,
                             MOE_CarpooledToWork=B08101_017M,
                             PublicTransitToWork=B08101_025E,
                             MOE_PublicTransitToWork=B08101_025M,
                             AggTravTimeWork=B08013_001E,
                             MOE_AggTravTimeWork=B08013_001M)
                    
                    commute.vars.2014.raw.col <- commute.vars.2014.raw %>%
                      select(-"GEOID", -"NAME")
                    
                    
                    
                    
                    
                  #2009----
                    
                    #Step 1: Population vectors----
                    
                    pop.vars.2009.raw <- get_acs(geography = "tract", # What is the lowest level of geography are we interested in?
                                                 year = 2009, # What year do we want - this can also be used for 2000 census data
                                                 variables = pop.vars, # let's use our variables we specified above
                                                 geometry = FALSE, # Do we want this as a shapefile? No, not now.
                                                 state = "PA", # What state?
                                                 county = "Philadelphia", # What County?
                                                 output = "wide") %>% # get a "wide" data type
                      rename(TotPop=B01003_001E,
                             MOE_TotPop=B01003_001M,
                             Households=B11001_001E,
                             MOE_Households=B11001_001M,
                             One_Person_Fem_HH=B11001_006E,
                             MOE_One_Person_Fem_HH=B11001_006M)
                    
                    
                    sex.vars.2009.raw <- get_acs(geography = "tract", year = 2009, variables = sex.vars, geometry = FALSE, 
                                                 state = "PA", county = "Philadelphia", output = "wide") %>%
                      rename(Male=B01001_002E,
                             MOE_Male=B01001_002M,
                             Female=B01001_026E,
                             MOE_Female=B01001_026M)
                    
                    sex.vars.2009.raw.col <- sex.vars.2009.raw %>%
                      select(-"GEOID", -"NAME")
                    
                    
                    
                    age.vars.2009.raw <- get_acs(geography = "tract", year = 2009, variables = age.vars, geometry = FALSE, 
                                                 state = "PA", county = "Philadelphia", output = "wide") %>%
                      rename(MedAge=B01002_001E,
                             MOE_MedAge=B01002_001M,
                             Under18=B09001_001E,
                             MOE_Under18=B09001_001M,
                             Male65to66=B01001_020E,
                             MOE_Male65to66=B01001_020M,
                             Male67to69=B01001_021E,
                             MOE_Male67to69=B01001_021M,
                             Male70to74=B01001_022E,
                             MOE_Male70to74=B01001_022M,
                             Fem65to66=B01001_044E,
                             MOE_Fem65to66=B01001_044M,
                             Fem67to69=B01001_045E,
                             MOE_Fem67to69=B01001_045M,
                             Fem70to74=B01001_046E,
                             MOE_Fem70to74=B01001_046M,
                             Male75to79=B01001_023E,
                             MOE_Male75to79=B01001_023M,
                             Male80to84=B01001_024E,
                             MOE_Male80to84=B01001_024M,
                             Male85Plus=B01001_025E,
                             MOE_Male85Plus=B01001_025M,
                             Fem75to79=B01001_047E,
                             MOE_Fem75to79=B01001_047M,
                             Fem80to84=B01001_048E,
                             MOE_Fem80to84=B01001_048M,
                             Fem85Plus=B01001_049E,
                             MOE_Fem85Plus=B01001_049M)
                    
                    age.vars.2009.raw.col <- age.vars.2009.raw %>%
                      select(-"GEOID", -"NAME")
                    
                    
                    race.ethn.vars.2009.raw <- get_acs(geography = "tract", year = 2009, variables = race.ethn.vars, geometry = FALSE, 
                                                       state = "PA", county = "Philadelphia", output = "wide") %>%
                      rename(RaceWh=B02001_002E,
                             MOE_RaceWh=B02001_002M,
                             RaceBl=B02001_003E,
                             MOE_RaceBl=B02001_003M,
                             RaceAIAN=B02001_004E,
                             MOE_RaceAIAN=B02001_004M,
                             RaceAsian=B02001_005E,
                             MOE_RaceAsian=B02001_005M,
                             RaceNHPI=B02001_006E,
                             MOE_RaceNHPI=B02001_006M,
                             RaceOther=B02001_007E,
                             MOE_RaceOther=B02001_007M,
                             RaceTwoPlus=B02001_008E,
                             MOE_RaceTwoPlus=B02001_008M,
                             #Ethnicity
                             EthnHispLat=B01001I_001E,
                             MOE_EthnHispLat=B01001I_001M)
                    
                    race.ethn.vars.2009.raw.col <- race.ethn.vars.2009.raw %>%
                      select(-"GEOID", -"NAME")
                    
                    
                    pov.vars.2009.raw <- get_acs(geography = "tract", year = 2009, variables = pov.vars, geometry = FALSE, 
                                                 state = "PA", county = "Philadelphia", output = "wide") %>%
                      rename(PovStatDet=B17001_001E,
                             MOE_PovStatDet=B17001_001M,
                             IncBelPov=B17001_002E,
                             MOE_IncBelPov=B17001_002M)
                    
                    pov.vars.2009.raw.col <- pov.vars.2009.raw %>%
                      select(-"GEOID", -"NAME")
                    
                    
                    #Step 2: Education vectors----
                    
                    #Table B15003 seems to be absent in the 2009 ACS. I'll have to see if
                    #I can track the data down under a different variable name, but for now
                    #I'll leave it blank.
                    edu.vars.2009.raw <- get_acs(geography = "tract", year = 2009, 
                                                 variables = (subset(edu.vars, 
                                                                     edu.vars != "B15003_001E" &
                                                                     edu.vars != "B15003_017E" &
                                                                     edu.vars != "B15003_018E" &
                                                                     edu.vars != "B15003_019E" &
                                                                     edu.vars != "B15003_020E" &
                                                                     edu.vars != "B15003_021E" &
                                                                     edu.vars != "B15003_022E" &
                                                                     edu.vars != "B15003_023E" &
                                                                     edu.vars != "B15003_024E" &
                                                                     edu.vars != "B15003_025E")),
                                                 geometry = FALSE, state = "PA", county = "Philadelphia",
                                                 output = "wide") %>% 
                      rename(#Tot25Plus=B15003_001E,
                             #MOE_Tot25Plus=B15003_001M,
                             #HSDip=B15003_017E,
                             #MOE_HSDip=B15003_017M,
                             #GED=B15003_018E,
                             #MOE_GED=B15003_018M,
                             #SomeCollLess1=B15003_019E,
                             #MOE_SomeCollLess1=B15003_019M,
                             #SomeColl1Plus=B15003_020E,
                             #MOE_SomeColl1Plus=B15003_020M,
                             #AssocDeg=B15003_021E,
                             #MOE_AssocDeg=B15003_021M,
                             #BachDeg=B15003_022E,
                             #MOE_BachDeg=B15003_022M,
                             #MastersDeg=B15003_023E,
                             #MOE_MastersDeg=B15003_023M,
                             #ProfSchDeg=B15003_024E,
                             #MOE_ProfSchDeg=B15003_024M,
                             #Doctorate=B15003_025E,
                             #MOE_Doctorate=B15003_025M,
                             Tot3PlusEnr=B14001_002E,
                             MOE_Tot3PlusEnr=B14001_002M,
                             EnrPreK=B14001_003E,
                             MOE_EnrPreK=B14001_003M,
                             EnrKinder=B14001_004E,
                             MOE_EnrKinder=B14001_004M,
                             Enr1to4=B14001_005E,
                             MOE_Enr1to4=B14001_005M,
                             Enr5to8=B14001_006E,
                             MOE_Enr5to8=B14001_006M,
                             Enr9to12=B14001_007E,
                             MOE_Enr9to12=B14001_007M,
                             EnrUndergrad=B14001_008E,
                             MOE_EnrUndergrad=B14001_008M,
                             EnrGrad=B14001_009E,
                             MOE_EnrGrad=B14001_009M,
                             Males_PreK_Public=B14002_005E,
                             MOE_Males_PreK_Public=B14002_005M,
                             Males_PreK_Private=B14002_006E,
                             MOE_Males_PreK_Private=B14002_006M,
                             Males_Kinder_Public=B14002_008E,
                             MOE_Males_Kinder_Public=B14002_008M,
                             Males_Kinder_Private=B14002_009E,
                             MOE_Males_Kinder_Private=B14002_009M,
                             Males_1_to_4_Public=B14002_011E,
                             MOE_Males_1_to_4_Public=B14002_011M,
                             Males_1_to_4_Private=B14002_012E,
                             MOE_Males_1_to_4_Private=B14002_012M,
                             Males_5_to_8_Public=B14002_014E,
                             MOE_Males_5_to_8_Public=B14002_014M,
                             Males_5_to_8_Private=B14002_015E,
                             MOE_Males_5_to_8_Private=B14002_015M,
                             Males_9_to_12_Public=B14002_017E,
                             MOE_Males_9_to_12_Public=B14002_017M,
                             Males_9_to_12_Private=B14002_018E,
                             MOE_Males_9_to_12_Private=B14002_018M,
                             Fem_PreK_Public=B14002_029E,
                             MOE_Fem_PreK_Public=B14002_029M,
                             Fem_PreK_Private=B14002_030E,
                             MOE_Fem_PreK_Private=B14002_030M,
                             Fem_Kinder_Public=B14002_032E,
                             MOE_Fem_Kinder_Public=B14002_032M,
                             Fem_Kinder_Private=B14002_033E,
                             MOE_Fem_Kinder_Private=B14002_033M,
                             Fem_1_to_4_Public=B14002_035E,
                             MOE_Fem_1_to_4_Public=B14002_035M,
                             Fem_1_to_4_Private=B14002_036E,
                             MOE_Fem_1_to_4_Private=B14002_036M,
                             Fem_5_to_8_Public=B14002_038E,
                             MOE_Fem_5_to_8_Public=B14002_038M,
                             Fem_5_to_8_Private=B14002_039E,
                             MOE_Fem_5_to_8_Private=B14002_039M,
                             Fem_9_to_12_Public=B14002_041E,
                             MOE_Fem_9_to_12_Public=B14002_041M,
                             Fem_9_to_12_Private=B14002_042E,
                             MOE_Fem_9_to_12_Private=B14002_042M)
                    
                    
                    edu.vars.2009.raw.col <- edu.vars.2009.raw %>%
                      select(-"GEOID", -"NAME")
                    
                    
                    #Step 3: Health vectors----
                    
                   # health.ins.vars.2009.raw <- get_acs(geography = "tract", year = 2009, variables = health.ins.vars, geometry = FALSE, 
                   #                                     state = "PA", county = "Philadelphia", output = "wide") %>%
                   #   rename(TotInsurance=B27010_001E,
                    #         MOE_TotInsurance=B27010_001M,
                     #        Uninsured_Under_19=B27010_006E,
                      #       MOE_Uninsured_Under_19=B27010_006M,
                       #      Uninsured_19_to_34=B27010_011E,
                        #     MOE_Uninsured_19_to_34=B27010_011M,
                         #    Uninsured_35_to_64=B27010_016E,
                          #   MOE_Uninsured_35_to_64=B27010_016M,
                          #   Uninsured_Over_65=B27010_021E,
                          #   MOE_Uninsured_Over_65=B27010_021M,
                      #       Medicare_Or_Medicaid_Under_19=B27010_004E,
                      #       MOE_Medicare_Or_Medicaid_Under_19=B27010_004M,
                      #       Medicare_Or_Medicaid_19_to_34=B27010_009E,
                      #       MOE_Medicare_Or_Medicaid_19_to_34=B27010_009M,
                      #       Medicare_Or_Medicaid_35_to_64=B27010_014E,
                      #       MOE_Medicare_Or_Medicaid_35_to_64=B27010_014M,
                      #       Medicare_Or_Medicaid_Over_65=B27010_019E,
                      #       MOE_Medicare_Or_Medicaid_Over_65=B27010_019M)
                    
                    
                  #  health.ins.vars.2009.raw.col <- health.ins.vars.2009.raw %>%
                   #   select(-"GEOID", -"NAME")
                    
                    
                 #   disability.vars.2009.raw <- get_acs(geography = "tract", year = 2009, variables = disability.vars, 
                #                                        geometry = FALSE,state = "PA", county = "Philadelphia", 
                 #                                       output = "wide") %>%
                  #    rename(No_Disability_Under_18=C18108_005E,
                  #           MOE_No_Disability_Under_18=C18108_005M,
                   #          No_Disability_19_to_64=C18108_009E,
                  #           MOE_No_Disability_19_to_64=C18108_009M,
                  #           No_Disability_Over_65=C18108_013E,
                  #           MOE_No_Disability_Over_65=C18108_013M)
                    
                  #  disability.vars.2009.raw.col <- disability.vars.2009.raw %>%
                   #   select(-"GEOID", -"NAME")
                    
                    
                    
                        ##Note: currently having some difficulty pulling health data
                        ##for 2009. Will have to come back to this and work on it.
                    
                        ##Second note: Both these tables don't seem to exist in the 2009
                        ##ACS. I'll have to see if I can find them elsewhere.
                    
                    #Step 4: Housing vectors----
                    
                    housing.basic.vars.2009.raw <- get_acs(geography = "tract", year = 2009, 
                                                           variables = (subset(housing.basic.vars,
                                                                               housing.basic.vars != "B25027_002E" &
                                                                               housing.basic.vars != "B25027_010E" &
                                                                               housing.basic.vars != "B07013_005E" &
                                                                               housing.basic.vars != "B07013_006E")), 
                                                                               geometry = FALSE, 
                                                           state = "PA", county = "Philadelphia", output = "wide") %>%
                      rename(#Housing occupancy and vacancy
                        TotHousUnits=B25001_001E,
                        MOE_TotHousUnits=B25001_001M,
                        HousUnitsOcc=B25002_002E,
                        MOE_HousUnitsOcc=B25002_002M,
                        HousUnitsVac=B25002_003E,
                        MOE_HousUnitsVac=B25002_003M,
                        VacantForSaleOnly=B25004_004E,
                        MOE_VacantForSaleOnly=B25004_004M,
                        VacantForRent=B25004_002E,
                        MOE_VacantForRent=B25004_002M,
                        OwnerOccUnits=B25003_002E,
                        MOE_OwnerOccUnits=B25003_002M,
                        RenterOccUnits=B25003_003E,
                        MOE_RenterOccUnits=B25003_003M,
                        #Home value, age of home, mortgage status
                        MedOwnOccHomeValue=B25077_001E,
                        MOE_MedOwnOccHomeValue=B25077_001M) #,
                        #UnitsWithMortgage=B25027_002E,
                        #MOE_UnitsWithMortgage=B25027_002M,
                        #UnitsWOutMortgage=B25027_010E,
                        #MOE_UnitsWOutMortgage=B25027_010M,
                        #Lives_in_Same_Place_Owns=B07013_005E,
                        #MOE_Lives_in_Same_Place_Owns=B07013_005M,
                        #Lives_in_Same_Place_Rents=B07013_006E,
                        #MOE_Lives_in_Same_Place_Rents=B07013_006M)
                    
                    housing.basic.vars.2009.raw.col <- housing.basic.vars.2009.raw %>%
                      select(-"GEOID", -"NAME")
                    
                    
                    housing.cost.vars.2009.raw <- get_acs(geography = "tract", year = 2009, variables = housing.cost.vars, geometry = FALSE, 
                                                          state = "PA", county = "Philadelphia", output = "wide") %>%
                      rename(MedSMOCWithMortgage=B25088_002E,
                             MOE_MedSMOCWithMortgage=B25088_002M,
                             MedSMOCWOutMortgage=B25088_003E,
                             MOE_MedSMOCWOutMortgage=B25088_003M,
                             SMOCAPI35to399WithMortgage=B25091_009E,
                             MOE_SMOCAPI35to399WithMortgage=B25091_009M,
                             SMOCAPI40to499WithMortgage=B25091_010E,
                             MOE_SMOCAPI40to499WithMortgage=B25091_010M,
                             SMOCAPI50PlusWithMortgage=B25091_011E,
                             MOE_SMOCAPI50PlusWithMortgage=B25091_011M,
                             SMOCAPI35to399WOutMortgage=B25091_020E,
                             MOE_SMOCAPI35to399WOutMortgage=B25091_020M,
                             SMOCAPI40to499WOutMortgage=B25091_021E,
                             MOE_SMOCAPI40to499WOutMortgage=B25091_021M,
                             SMOCAPI50PlusWOutMortgage=B25091_022E,
                             MOE_SMOCAPI50PlusWOutMortgage=B25091_022M,
                             MedGrossRent=B25064_001E,
                             MOE_MedGrossRent=B25064_001M,
                             GRAPI_Under_10_Perc=B25070_002E,
                             MOE_GRAPI_Under_10_Perc=B25070_002M,
                             GRAPI10to149Perc=B25070_003E,
                             MOE_GRAPI10to149Perc=B25070_003M,
                             GRAPI15to199Perc=B25070_004E,
                             MOE_GRAPI15to199Perc=B25070_004M,
                             GRAPI20to249Perc=B25070_005E,
                             MOE_GRAPI20to249Perc=B25070_005M,
                             GRAPI25to299Perc=B25070_006E,
                             MOE_GRAPI25to299Perc=B25070_006M,
                             GRAPI30to349Perc=B25070_007E,
                             MOE_GRAPI30to349Perc=B25070_007M,
                             GRAPI35to399Perc=B25070_008E,
                             MOE_GRAPI35to399Perc=B25070_008M,
                             GRAPI40to499Perc=B25070_009E,
                             MOE_GRAPI40to499Perc=B25070_009M,
                             GRAPI50PlusPerc=B25070_010E,
                             MOE_GRAPI50PlusPerc=B25070_010M)
                    
                    housing.cost.vars.2009.raw.col <- housing.cost.vars.2009.raw %>%
                      select(-"GEOID", -"NAME")
                    
                    
                    hh.asset.vars.2009.raw <- get_acs(geography = "tract", year = 2009, 
                                                      variables = (subset(hh.asset.vars, 
                                                                          hh.asset.vars != "B28001_011E" &
                                                                            hh.asset.vars != "B28002_013E" &
                                                                            hh.asset.vars != "B08201_002E")),
                                                      geometry = FALSE, 
                                                      state = "PA", county = "Philadelphia", output = "wide") %>%
                      rename(#NoVehiclesAvailable=B08201_002E,
                             #MOE_NoVehiclesAvailable=B08201_002M,
                             OwnerOccNoTele=B25043_007E,
                             MOE_OwnerOccNoTele=B25043_007M,
                             RenterOccNoTele=B25043_016E,
                             MOE_RenterOccNoTele=B25043_016M) #,
                             #NoComputer=B28001_011E,
                             #MOE_NoComputer=B28001_011M,
                             #NoInternet=B28002_013E,
                             #MOE_NoInternet=B28002_013M)
                    
                    hh.asset.vars.2009.raw.col <- hh.asset.vars.2009.raw %>%
                      select(-"GEOID", -"NAME")
                    
                    
                    #Step 5: Workforce & econ vectors----
                    
                    pov.vars.2009.raw <- get_acs(geography = "tract", year = 2009, variables = pov.vars, geometry = FALSE, 
                                                 state = "PA", county = "Philadelphia", output = "wide") %>%
                      rename(PovStatDet=B17001_001E,
                             MOE_PovStatDet=B17001_001M,
                             IncBelPov=B17001_002E,
                             MOE_IncBelPov=B17001_002M)
                    
                    pov.vars.2009.raw.col <- pov.vars.2009.raw %>%
                      select(-"GEOID", -"NAME")
                    
                    
                    
                    empl.vars.2009.raw <- get_acs(geography = "tract", year = 2009,
                                                  variables = (subset(empl.vars, 
                                                                      empl.vars != "B23025_001E" &
                                                                        empl.vars != "B23025_003E" &
                                                                        empl.vars != "B23025_004E" &
                                                                        empl.vars != "B23025_005E" &
                                                                        empl.vars != "B23013_001E" &
                                                                        empl.vars != "B24090_001E" &
                                                                        empl.vars != "B23020_001E" &
                                                                        empl.vars != "B23027_006E" &
                                                                        empl.vars != "B23027_011E")), 
                                                  geometry = FALSE, 
                                                  state = "PA", county = "Philadelphia", output = "wide") %>%
                      rename(#Pop16Plus=B23025_001E,
                             #MOE_Pop16Plus=B23025_001M,
                             #InCivLabFor=B23025_003E,
                             #MOE_InCivLabFor=B23025_003M,
                             #Employed=B23025_004E,
                             #MOE_Employed=B23025_004M,
                             #Unemployed=B23025_005E,
                             #MOE_Unemployed=B23025_005M,
                             Age16to64=B23022_001E,
                             MOE_Age16to64=B23022_001M,
                             #MedAgeWorkers=B23013_001E,
                             #MOE_MedAgeWorkers=B23013_001M,
                             #TotFullTimeYrRnd=B24090_001E,
                             #MOE_TotFullTimeYrRnd=B24090_001M,
                             #MeanHrsWorked=B23020_001E,
                             #MOE_MeanHrsWorked=B23020_001M,
                             Male_16_to_19_Civ_Empl=B23001_007E,
                             MOE_Male_16_to_19_Civ_Empl=B23001_007M,
                             Male_20_to_24_Civ_Empl=B23001_014E,
                             MOE_Male_20_to_24_Civ_Empl=B23001_014M,
                             Fem_16_to_19_Civ_Empl=B23001_053E,
                             MOE_Fem_16_to_19_Civ_Empl=B23001_053M,
                             Fem_20_to_24_Civ_Empl=B23001_060E,
                             MOE_Fem_20_to_24_Civ_Empl=B23001_060M,
                             #Unempl_16_to_19=B23027_006E,
                             #MOE_Unempl_16_to_19=B23027_006M,
                             #Unempl_20_to_24=B23027_011E,
                             #MOE_Unempl_20_to_24=B23027_011M
                             )
                    
                    empl.vars.2009.raw.col <- empl.vars.2009.raw %>%
                      select(-"GEOID", -"NAME")
                    
                    
                    
                    inc.vars.2009.raw <- get_acs(geography = "tract", year = 2009, variables = inc.vars, geometry = FALSE, 
                                                 state = "PA", county = "Philadelphia", output = "wide") %>%
                      rename(MedHHInc=B19013_001E,
                             MOE_MedHHInc=B19013_001M,
                             WithPubAssistInc=B19057_002E,
                             MOE_WithPubAssistInc=B19057_002M,
                             AggPubAssistInc=B19067_001E,
                             MOE_AggPubAssistInc=B19067_001M,
                             SNAP=B22001_002E,
                             MOE_SNAP=B22001_002M)
                    
                    inc.vars.2009.raw.col <- inc.vars.2009.raw %>%
                      select(-"GEOID", -"NAME")
                    
                    
                    commute.vars.2009.raw <- get_acs(geography = "tract", year = 2009, 
                                                     variables = (subset(commute.vars, 
                                                                         commute.vars != "B08101_001E" &
                                                                           commute.vars != "B08101_009E" &
                                                                           commute.vars != "B08101_017E" &
                                                                           commute.vars != "B08101_025E")), 
                                                     geometry = FALSE, 
                                                     state = "PA", county = "Philadelphia", output = "wide") %>%
                      rename(Workers16Plus=B08008_001E,
                             MOE_Workers16Plus=B08008_001M,
                             WorkInPlaceOfResidence=B08008_003E,
                             MOE_WorkInPlaceOfResidence=B08008_003M,
                             WorkOutOfPlaceOfResidence=B08008_004E,
                             MOE_WorkOutOfPlaceOfResidence=B08008_004M,
                             #TotTravelToWork=B08101_001E,
                             #MOE_TotTravelToWork=B08101_001M,
                             #DroveAloneToWork=B08101_009E,
                             #MOE_DroveAloneToWork=B08101_009M,
                             #CarpooledToWork=B08101_017E,
                             #MOE_CarpooledToWork=B08101_017M,
                             #PublicTransitToWork=B08101_025E,
                             #MOE_PublicTransitToWork=B08101_025M,
                             AggTravTimeWork=B08013_001E,
                             MOE_AggTravTimeWork=B08013_001M)
                    
                    commute.vars.2009.raw.col <- commute.vars.2009.raw %>%
                      select(-"GEOID", -"NAME")
                
                    
                    
      #Part 4: Mutate to create any new variables----
                    
                    #Step 1: Create dataframe for each year----
                    
                    all.2019.raw <- cbind(pop.vars.2019.raw, sex.vars.2019.raw.col, age.vars.2019.raw.col, race.ethn.vars.2019.raw.col, 
                                          pov.vars.2019.raw.col, empl.vars.2019.raw.col, inc.vars.2019.raw.col, commute.vars.2019.raw.col, 
                                          edu.vars.2019.raw.col, housing.basic.vars.2019.raw.col, 
                                          housing.cost.vars.2019.raw.col, hh.asset.vars.2019.raw.col, health.ins.vars.2019.raw.col, 
                                          disability.vars.2019.raw.col)
                    
                    all.2014.raw <- cbind(pop.vars.2014.raw, sex.vars.2014.raw.col, age.vars.2014.raw.col, race.ethn.vars.2014.raw.col, 
                                          pov.vars.2014.raw.col, empl.vars.2014.raw.col, inc.vars.2014.raw.col, commute.vars.2014.raw.col, 
                                          edu.vars.2014.raw.col, housing.basic.vars.2014.raw.col, 
                                          housing.cost.vars.2014.raw.col, hh.asset.vars.2014.raw.col, health.ins.vars.2014.raw.col, 
                                          disability.vars.2014.raw.col)
                    
                    all.2009.raw <- cbind(pop.vars.2009.raw, sex.vars.2009.raw.col, age.vars.2009.raw.col, race.ethn.vars.2009.raw.col, 
                                          pov.vars.2009.raw.col, empl.vars.2009.raw.col, inc.vars.2009.raw.col, commute.vars.2009.raw.col, 
                                          edu.vars.2009.raw.col, housing.basic.vars.2009.raw.col, 
                                          housing.cost.vars.2009.raw.col, hh.asset.vars.2009.raw.col#, health.ins.vars.2009.raw.col, 
                                         # disability.vars.2009.raw.col
                                          )
                    
                    
                    #Step 2: Filter for just variables in the PZ tracts----
                    
                    #This step filters the tables you just obtained, which contain data 
                    #for all census tracts in Philadelphia, to just PZ census tracts, 
                    #using the list of PZ tracts from the beginning of the code.
                    
                    all.2019.pz <- all.2019.raw %>%
                                    filter(GEOID %in% pzTracts) 
                    
                    all.2014.pz <- all.2014.raw %>%
                                    filter(GEOID %in% pzTracts)
                    
                    all.2009.pz <- all.2009.raw %>%
                                    filter(GEOID %in% pzTracts)
                    
                    
                    #Step 3: Calculate new variables & their MOEs----
                    
                    #This step performs many of the calculations you will need to do on the variables, 
                    #including combining categories and calculating means and some percentages.
                    
                          #2019----
                    
                    all.2019.pz.calc <- all.2019.pz %>%
                      mutate(
                        #Age
                        Over65=(Male65to66+ #I don't think this is correct. Over65 and MOE Over65 need to be split.
                                  Male67to69+
                                  Male70to74+
                                  Fem65to66+
                                  Fem67to69+
                                  Fem70to74+
                                  Male75to79+
                                  Male80to84+
                                  Male85Plus+
                                  Fem75to79+
                                  Fem80to84+
                                  Fem85Plus),
                        
                        MOE_Over65 = (MOE_Male65to66+
                                        MOE_Male67to69+
                                        MOE_Male70to74+
                                        MOE_Fem65to66+
                                        MOE_Fem67to69+
                                        MOE_Fem70to74+
                                        MOE_Male75to79+
                                        MOE_Male80to84+
                                        MOE_Male85Plus+
                                        MOE_Fem75to79+
                                        MOE_Fem80to84+
                                        MOE_Fem85Plus),
                        
                        #Race
                        Race_All_Other=RaceAIAN+RaceNHPI+RaceOther+RaceTwoPlus,
                        MOE_Race_All_Other=(sqrt(MOE_RaceAIAN^2)+(MOE_RaceNHPI^2)
                                            +(MOE_RaceOther^2)+(MOE_RaceTwoPlus^2)),
                        
                        #Disability
                        Disabled=(TotPop-(No_Disability_Under_18+
                                            No_Disability_19_to_64+
                                            No_Disability_Over_65)),
                        
                        #Poverty
                        PovRate=(IncBelPov/PovStatDet*100),
                        MOE_PovRate=(1/PovStatDet)*sqrt((MOE_IncBelPov^2)+
                                                          ((IncBelPov^2)/(PovStatDet^2))*(MOE_PovStatDet^2))*100,
                        
                        #Commute
                        Avg_Trav_Time_Work=(AggTravTimeWork/Employed),
                        
                        #Employment
                        LaboForcPartiRate=InCivLabFor/Pop16Plus*100,
                        MOE_LaboForcPartiRate=(1/Pop16Plus)*sqrt((MOE_InCivLabFor^2)+((InCivLabFor^2)/
                                                                                        (Pop16Plus^2))*(MOE_Pop16Plus^2))*100,
                        UnemplRate=Unemployed/InCivLabFor*100,
                        MOE_UnemplRate=(1/InCivLabFor)*sqrt((MOE_Unemployed^2)+((Unemployed^2)/
                                                                                  (InCivLabFor^2))*(MOE_InCivLabFor^2))*100,
                        
                        Youth_UnemplRate=((Unempl_16_to_19+Unempl_20_to_24)/
                                            (Male_16_to_19_Civ_Empl+
                                               Male_20_to_24_Civ_Empl+
                                               Fem_16_to_19_Civ_Empl+
                                               Fem_20_to_24_Civ_Empl)),
                        
                        #Income and Benefits
                        Avg_CPAI=(AggPubAssistInc/WithPubAssistInc),
                        Uninsured=Uninsured_Under_19+Uninsured_19_to_34+Uninsured_35_to_64+Uninsured_Over_65,
                        MOE_Uninsured=sqrt((MOE_Uninsured_Under_19^2)+(MOE_Uninsured_19_to_34^2)+
                                             (MOE_Uninsured_35_to_64^2)+(MOE_Uninsured_Over_65^2)),
                        Public_Insurance=(Medicare_Or_Medicaid_Under_19+
                                            Medicare_Or_Medicaid_19_to_34+
                                            Medicare_Or_Medicaid_35_to_64+
                                            Medicare_Or_Medicaid_Over_65),
                        
                        
                        #Educational Attainment
                        HSGradOrHigher=(HSDip+GED+SomeCollLess1+SomeColl1Plus+AssocDeg+BachDeg+
                                          MastersDeg+ProfSchDeg+Doctorate),
                        MOE_HSGradOrHigher=sqrt((MOE_HSDip^2)+(MOE_GED^2)+(MOE_SomeCollLess1^2)+
                                                  (MOE_SomeColl1Plus^2)+(MOE_AssocDeg^2)+(MOE_BachDeg^2)+
                                                  (MOE_MastersDeg^2)+(MOE_ProfSchDeg^2)+(MOE_Doctorate^2)),
                        BachDegOrHigher=(BachDeg+MastersDeg+ProfSchDeg+Doctorate),
                        MOE_BachDegOrHigher=sqrt((MOE_BachDeg^2)+(MOE_MastersDeg^2)+
                                                   (MOE_ProfSchDeg^2)+(MOE_Doctorate^2)),
                        
                        
                        #School Enrollment
                        EnrKto12=EnrKinder+Enr1to4+Enr5to8+Enr9to12,
                        MOE_EnrKto12=sqrt((MOE_EnrKinder^2)+(MOE_Enr1to4^2)+
                                            (MOE_Enr5to8^2)+(MOE_Enr9to12^2)),
                        EnrPublic=(Males_PreK_Public+
                                     Males_Kinder_Public+
                                     Males_1_to_4_Public+
                                     Males_5_to_8_Public+
                                     Males_9_to_12_Public+
                                     Fem_PreK_Public+
                                     Fem_Kinder_Public+
                                     Fem_1_to_4_Public+
                                     Fem_5_to_8_Public+
                                     Fem_9_to_12_Public),
                        
                        EnrPrivate=(Males_PreK_Private+
                                      Males_Kinder_Private+
                                      Males_1_to_4_Private+
                                      Males_5_to_8_Private+
                                      Males_9_to_12_Private+
                                      Fem_PreK_Private+
                                      Fem_Kinder_Private+
                                      Fem_1_to_4_Private+
                                      Fem_5_to_8_Private+
                                      Fem_9_to_12_Private),
                        
                        ApproxPerc_Uni_Students = ((EnrUndergrad + EnrGrad)/TotPop),
                        
                        #Housing Occupancy and Vacancy
                        Tot_Occ_Units=(OwnerOccUnits+RenterOccUnits),
                        MOE_Tot_Occ_Units=sqrt((MOE_OwnerOccUnits)^2+(MOE_RenterOccUnits)^2),
                        Lives_in_Same_Place=(Lives_in_Same_Place_Owns+Lives_in_Same_Place_Rents),
                        MOE_Lives_in_Same_Place=sqrt((Lives_in_Same_Place_Owns)^2+(Lives_in_Same_Place_Rents)^2),
                        
                        #Housing Costs and Cost Burdens
                        SMOCAPI35PlusWithMortgage=(SMOCAPI35to399WithMortgage+
                                                     SMOCAPI40to499WithMortgage+SMOCAPI50PlusWithMortgage),
                        MOE_SMOCAPI35PlusWithMortgage=sqrt((MOE_SMOCAPI35to399WithMortgage^2)+
                                                             (MOE_SMOCAPI40to499WithMortgage^2)+
                                                             (MOE_SMOCAPI50PlusWithMortgage^2)),
                        SMOCAPI35PlusWOutMortgage=SMOCAPI35to399WOutMortgage+
                          SMOCAPI40to499WOutMortgage+SMOCAPI50PlusWOutMortgage,
                        MOE_SMOCAPI35PlusWOutMortgage=sqrt((MOE_SMOCAPI35to399WOutMortgage^2)+
                                                             (MOE_SMOCAPI40to499WOutMortgage^2)+
                                                             (MOE_SMOCAPI50PlusWOutMortgage^2)),
                        GRAPI35PlusPerc=GRAPI35to399Perc+GRAPI40to499Perc+GRAPI50PlusPerc,
                        MOE_GRAPI35PlusPerc=sqrt((MOE_GRAPI35to399Perc^2)+
                                                   (MOE_GRAPI40to499Perc^2)+(MOE_GRAPI50PlusPerc^2)),
                        #Household Asset Availability
                        NoTeleInHome=OwnerOccNoTele+RenterOccNoTele,
                        MOE_NoTeleInHome=sqrt((MOE_OwnerOccNoTele^2)+(MOE_RenterOccNoTele^2)),
                        
                      )%>%
                      as.data.frame()
                    
                    
                          #2014----
                    
                    
                    all.2014.pz.calc <- all.2014.pz %>%
                      mutate(
                        #Age
                        Over65=(Male65to66+ #I don't think this is correct. Over65 and MOE Over65 need to be split.
                                  Male67to69+
                                  Male70to74+
                                  Fem65to66+
                                  Fem67to69+
                                  Fem70to74+
                                  Male75to79+
                                  Male80to84+
                                  Male85Plus+
                                  Fem75to79+
                                  Fem80to84+
                                  Fem85Plus),
                        
                        MOE_Over65 = (MOE_Male65to66+
                                        MOE_Male67to69+
                                        MOE_Male70to74+
                                        MOE_Fem65to66+
                                        MOE_Fem67to69+
                                        MOE_Fem70to74+
                                        MOE_Male75to79+
                                        MOE_Male80to84+
                                        MOE_Male85Plus+
                                        MOE_Fem75to79+
                                        MOE_Fem80to84+
                                        MOE_Fem85Plus),
                        
                        #Race
                        Race_All_Other=RaceAIAN+RaceNHPI+RaceOther+RaceTwoPlus,
                        MOE_Race_All_Other=(sqrt(MOE_RaceAIAN^2)+(MOE_RaceNHPI^2)
                                            +(MOE_RaceOther^2)+(MOE_RaceTwoPlus^2)),
                        
                        #Disability
                        Disabled=(TotPop-(No_Disability_Under_18+
                                            No_Disability_19_to_64+
                                            No_Disability_Over_65)),
                        
                        #Poverty
                        PovRate=(IncBelPov/PovStatDet*100),
                        MOE_PovRate=(1/PovStatDet)*sqrt((MOE_IncBelPov^2)+
                                                          ((IncBelPov^2)/(PovStatDet^2))*(MOE_PovStatDet^2))*100,
                        
                        #Commute
                        Avg_Trav_Time_Work=(AggTravTimeWork/Employed),
                        
                        #Employment
                        LaboForcPartiRate=InCivLabFor/Pop16Plus*100,
                        MOE_LaboForcPartiRate=(1/Pop16Plus)*sqrt((MOE_InCivLabFor^2)+((InCivLabFor^2)/
                                                                                        (Pop16Plus^2))*(MOE_Pop16Plus^2))*100,
                        UnemplRate=Unemployed/InCivLabFor*100,
                        MOE_UnemplRate=(1/InCivLabFor)*sqrt((MOE_Unemployed^2)+((Unemployed^2)/
                                                                                  (InCivLabFor^2))*(MOE_InCivLabFor^2))*100,
                        
                        Youth_UnemplRate=((Unempl_16_to_19+Unempl_20_to_24)/
                                            (Male_16_to_19_Civ_Empl+
                                               Male_20_to_24_Civ_Empl+
                                               Fem_16_to_19_Civ_Empl+
                                               Fem_20_to_24_Civ_Empl)),
                        
                        #Income and Benefits
                        Avg_CPAI=(AggPubAssistInc/WithPubAssistInc),
                        Uninsured=Uninsured_Under_19+Uninsured_19_to_34+Uninsured_35_to_64+Uninsured_Over_65,
                        MOE_Uninsured=sqrt((MOE_Uninsured_Under_19^2)+(MOE_Uninsured_19_to_34^2)+
                                             (MOE_Uninsured_35_to_64^2)+(MOE_Uninsured_Over_65^2)),
                        Public_Insurance=(Medicare_Or_Medicaid_Under_19+
                                            Medicare_Or_Medicaid_19_to_34+
                                            Medicare_Or_Medicaid_35_to_64+
                                            Medicare_Or_Medicaid_Over_65),
                        
                        
                        #Educational Attainment
                        HSGradOrHigher=(HSDip+GED+SomeCollLess1+SomeColl1Plus+AssocDeg+BachDeg+
                                          MastersDeg+ProfSchDeg+Doctorate),
                        MOE_HSGradOrHigher=sqrt((MOE_HSDip^2)+(MOE_GED^2)+(MOE_SomeCollLess1^2)+
                                                  (MOE_SomeColl1Plus^2)+(MOE_AssocDeg^2)+(MOE_BachDeg^2)+
                                                  (MOE_MastersDeg^2)+(MOE_ProfSchDeg^2)+(MOE_Doctorate^2)),
                        BachDegOrHigher=(BachDeg+MastersDeg+ProfSchDeg+Doctorate),
                        MOE_BachDegOrHigher=sqrt((MOE_BachDeg^2)+(MOE_MastersDeg^2)+
                                                   (MOE_ProfSchDeg^2)+(MOE_Doctorate^2)),
                        
                        
                        #School Enrollment
                        EnrKto12=EnrKinder+Enr1to4+Enr5to8+Enr9to12,
                        MOE_EnrKto12=sqrt((MOE_EnrKinder^2)+(MOE_Enr1to4^2)+
                                            (MOE_Enr5to8^2)+(MOE_Enr9to12^2)),
                        EnrPublic=(Males_PreK_Public+
                                     Males_Kinder_Public+
                                     Males_1_to_4_Public+
                                     Males_5_to_8_Public+
                                     Males_9_to_12_Public+
                                     Fem_PreK_Public+
                                     Fem_Kinder_Public+
                                     Fem_1_to_4_Public+
                                     Fem_5_to_8_Public+
                                     Fem_9_to_12_Public),
                        
                        EnrPrivate=(Males_PreK_Private+
                                      Males_Kinder_Private+
                                      Males_1_to_4_Private+
                                      Males_5_to_8_Private+
                                      Males_9_to_12_Private+
                                      Fem_PreK_Private+
                                      Fem_Kinder_Private+
                                      Fem_1_to_4_Private+
                                      Fem_5_to_8_Private+
                                      Fem_9_to_12_Private),
                        
                        ApproxPerc_Uni_Students = ((EnrUndergrad + EnrGrad)/TotPop),
                        
                        #Housing Occupancy and Vacancy
                        Tot_Occ_Units=(OwnerOccUnits+RenterOccUnits),
                        MOE_Tot_Occ_Units=sqrt((MOE_OwnerOccUnits)^2+(MOE_RenterOccUnits)^2),
                        Lives_in_Same_Place=(Lives_in_Same_Place_Owns+Lives_in_Same_Place_Rents),
                        MOE_Lives_in_Same_Place=sqrt((Lives_in_Same_Place_Owns)^2+(Lives_in_Same_Place_Rents)^2),
                        
                        #Housing Costs and Cost Burdens
                        SMOCAPI35PlusWithMortgage=(SMOCAPI35to399WithMortgage+
                                                     SMOCAPI40to499WithMortgage+SMOCAPI50PlusWithMortgage),
                        MOE_SMOCAPI35PlusWithMortgage=sqrt((MOE_SMOCAPI35to399WithMortgage^2)+
                                                             (MOE_SMOCAPI40to499WithMortgage^2)+
                                                             (MOE_SMOCAPI50PlusWithMortgage^2)),
                        SMOCAPI35PlusWOutMortgage=SMOCAPI35to399WOutMortgage+
                          SMOCAPI40to499WOutMortgage+SMOCAPI50PlusWOutMortgage,
                        MOE_SMOCAPI35PlusWOutMortgage=sqrt((MOE_SMOCAPI35to399WOutMortgage^2)+
                                                             (MOE_SMOCAPI40to499WOutMortgage^2)+
                                                             (MOE_SMOCAPI50PlusWOutMortgage^2)),
                        GRAPI35PlusPerc=GRAPI35to399Perc+GRAPI40to499Perc+GRAPI50PlusPerc,
                        MOE_GRAPI35PlusPerc=sqrt((MOE_GRAPI35to399Perc^2)+
                                                   (MOE_GRAPI40to499Perc^2)+(MOE_GRAPI50PlusPerc^2)),
                        #Household Asset Availability
                        NoTeleInHome=OwnerOccNoTele+RenterOccNoTele,
                        MOE_NoTeleInHome=sqrt((MOE_OwnerOccNoTele^2)+(MOE_RenterOccNoTele^2)),
                        
                      )%>%
                      as.data.frame()
                    
                    ##Note: THIS STEP IS INCOMPLETE AS OF 12/20/2021. I need to get more MOEs
                    ##from Zach Fusfeld at Drexel.
                    
                          #2009----
                    
                    all.2009.pz.calc <- all.2009.pz %>%
                      mutate(
                        #Age
                        Over65=(Male65to66+ #I don't think this is correct. Over65 and MOE Over65 need to be split.
                                  Male67to69+
                                  Male70to74+
                                  Fem65to66+
                                  Fem67to69+
                                  Fem70to74+
                                  Male75to79+
                                  Male80to84+
                                  Male85Plus+
                                  Fem75to79+
                                  Fem80to84+
                                  Fem85Plus),
                        
                        MOE_Over65 = (MOE_Male65to66+
                                        MOE_Male67to69+
                                        MOE_Male70to74+
                                        MOE_Fem65to66+
                                        MOE_Fem67to69+
                                        MOE_Fem70to74+
                                        MOE_Male75to79+
                                        MOE_Male80to84+
                                        MOE_Male85Plus+
                                        MOE_Fem75to79+
                                        MOE_Fem80to84+
                                        MOE_Fem85Plus),
                        
                        #Race
                        Race_All_Other=RaceAIAN+RaceNHPI+RaceOther+RaceTwoPlus,
                        MOE_Race_All_Other=(sqrt(MOE_RaceAIAN^2)+(MOE_RaceNHPI^2)
                                            +(MOE_RaceOther^2)+(MOE_RaceTwoPlus^2)),
                        
                        #Disability
                  #      Disabled=(TotPop-(No_Disability_Under_18+
                  #                          No_Disability_19_to_64+
                  #                          No_Disability_Over_65)),
                        
                        #Poverty
                        PovRate=(IncBelPov/PovStatDet*100),
                        MOE_PovRate=(1/PovStatDet)*sqrt((MOE_IncBelPov^2)+
                                                          ((IncBelPov^2)/(PovStatDet^2))*(MOE_PovStatDet^2))*100,
                        
                        #Commute
                #        Avg_Trav_Time_Work=(AggTravTimeWork/Employed),
                        
                        #Employment
                #        LaboForcPartiRate=InCivLabFor/Pop16Plus*100,
                #        MOE_LaboForcPartiRate=(1/Pop16Plus)*sqrt((MOE_InCivLabFor^2)+((InCivLabFor^2)/
                #                                                                        (Pop16Plus^2))*(MOE_Pop16Plus^2))*100,
                #        UnemplRate=Unemployed/InCivLabFor*100,
                #        MOE_UnemplRate=(1/InCivLabFor)*sqrt((MOE_Unemployed^2)+((Unemployed^2)/
                 #                                                                 (InCivLabFor^2))*(MOE_InCivLabFor^2))*100,
                        
                #        Youth_UnemplRate=((Unempl_16_to_19+Unempl_20_to_24)/
                #                            (Male_16_to_19_Civ_Empl+
                #                               Male_20_to_24_Civ_Empl+
                #                               Fem_16_to_19_Civ_Empl+
                #                               Fem_20_to_24_Civ_Empl)),
                        
                        #Income and Benefits
                #        Avg_CPAI=(AggPubAssistInc/WithPubAssistInc),
                #        Uninsured=Uninsured_Under_19+Uninsured_19_to_34+Uninsured_35_to_64+Uninsured_Over_65,
                #        MOE_Uninsured=sqrt((MOE_Uninsured_Under_19^2)+(MOE_Uninsured_19_to_34^2)+
                #                             (MOE_Uninsured_35_to_64^2)+(MOE_Uninsured_Over_65^2)),
                #        Public_Insurance=(Medicare_Or_Medicaid_Under_19+
                #                            Medicare_Or_Medicaid_19_to_34+
                #                            Medicare_Or_Medicaid_35_to_64+
                #                            Medicare_Or_Medicaid_Over_65),
                        
                        
                        #Educational Attainment
                 #       HSGradOrHigher=(HSDip+GED+SomeCollLess1+SomeColl1Plus+AssocDeg+BachDeg+
                  #                        MastersDeg+ProfSchDeg+Doctorate),
                   #     MOE_HSGradOrHigher=sqrt((MOE_HSDip^2)+(MOE_GED^2)+(MOE_SomeCollLess1^2)+
                  #                                (MOE_SomeColl1Plus^2)+(MOE_AssocDeg^2)+(MOE_BachDeg^2)+
                  #                                (MOE_MastersDeg^2)+(MOE_ProfSchDeg^2)+(MOE_Doctorate^2)),
                  #      BachDegOrHigher=(BachDeg+MastersDeg+ProfSchDeg+Doctorate),
                  #      MOE_BachDegOrHigher=sqrt((MOE_BachDeg^2)+(MOE_MastersDeg^2)+
                  #                                 (MOE_ProfSchDeg^2)+(MOE_Doctorate^2)),
                        
                        
                        #School Enrollment
                        EnrKto12=EnrKinder+Enr1to4+Enr5to8+Enr9to12,
                        MOE_EnrKto12=sqrt((MOE_EnrKinder^2)+(MOE_Enr1to4^2)+
                                            (MOE_Enr5to8^2)+(MOE_Enr9to12^2)),
                        EnrPublic=(Males_PreK_Public+
                                     Males_Kinder_Public+
                                     Males_1_to_4_Public+
                                     Males_5_to_8_Public+
                                     Males_9_to_12_Public+
                                     Fem_PreK_Public+
                                     Fem_Kinder_Public+
                                     Fem_1_to_4_Public+
                                     Fem_5_to_8_Public+
                                     Fem_9_to_12_Public),
                        
                        EnrPrivate=(Males_PreK_Private+
                                      Males_Kinder_Private+
                                      Males_1_to_4_Private+
                                      Males_5_to_8_Private+
                                      Males_9_to_12_Private+
                                      Fem_PreK_Private+
                                      Fem_Kinder_Private+
                                      Fem_1_to_4_Private+
                                      Fem_5_to_8_Private+
                                      Fem_9_to_12_Private),
                
                        ApproxPerc_Uni_Students = ((EnrUndergrad + EnrGrad)/TotPop),
                        
                        #Housing Occupancy and Vacancy
                        Tot_Occ_Units=(OwnerOccUnits+RenterOccUnits),
                        MOE_Tot_Occ_Units=sqrt((MOE_OwnerOccUnits)^2+(MOE_RenterOccUnits)^2),
                 #       Lives_in_Same_Place=(Lives_in_Same_Place_Owns+Lives_in_Same_Place_Rents),
                #        MOE_Lives_in_Same_Place=sqrt((Lives_in_Same_Place_Owns)^2+(Lives_in_Same_Place_Rents)^2),
                        
                        #Housing Costs and Cost Burdens
                        SMOCAPI35PlusWithMortgage=(SMOCAPI35to399WithMortgage+
                                                     SMOCAPI40to499WithMortgage+SMOCAPI50PlusWithMortgage),
                        MOE_SMOCAPI35PlusWithMortgage=sqrt((MOE_SMOCAPI35to399WithMortgage^2)+
                                                             (MOE_SMOCAPI40to499WithMortgage^2)+
                                                             (MOE_SMOCAPI50PlusWithMortgage^2)),
                        SMOCAPI35PlusWOutMortgage=SMOCAPI35to399WOutMortgage+
                          SMOCAPI40to499WOutMortgage+SMOCAPI50PlusWOutMortgage,
                        MOE_SMOCAPI35PlusWOutMortgage=sqrt((MOE_SMOCAPI35to399WOutMortgage^2)+
                                                             (MOE_SMOCAPI40to499WOutMortgage^2)+
                                                             (MOE_SMOCAPI50PlusWOutMortgage^2)),
                        GRAPI35PlusPerc=GRAPI35to399Perc+GRAPI40to499Perc+GRAPI50PlusPerc,
                        MOE_GRAPI35PlusPerc=sqrt((MOE_GRAPI35to399Perc^2)+
                                                   (MOE_GRAPI40to499Perc^2)+(MOE_GRAPI50PlusPerc^2)),
                        #Household Asset Availability
                        NoTeleInHome=OwnerOccNoTele+RenterOccNoTele,
                        MOE_NoTeleInHome=sqrt((MOE_OwnerOccNoTele^2)+(MOE_RenterOccNoTele^2)),
                        
                      )%>%
                      as.data.frame()
                    
      
      #Part 5: Weight by tract----
                    
                    #Step 1: Read in .csv of weights--make sure the path is correct.
                    
                    weights <- read.csv("./PZ_Pop_Weights.csv")
                    
                    weights$GEOID <- as.character(weights$GEOID)
                    
                    #Step 2: Convert variables according to appropriate weights
                    
                          #2019----
                    
                    all.2019.weights <- all.2019.pz.calc %>%
                      left_join(weights, by = "GEOID") %>%
                      select(
                        
                        #Population
                        TotPop,
                        Households,
                        One_Person_Fem_HH,
                        Male,
                        Female,
                        MedAge,
                        Tot25Plus,
                        Pop16Plus,
                        Disabled,
                        Under18,
                        Over65,
                        
                        #Race
                        Race_All_Other,
                        RaceWh,
                        RaceBl,
                        EthnHispLat,
                        RaceAsian,
                        
                        #Housing Occupancy and Vacancy
                        TotHousUnits,
                        HousUnitsOcc,
                        HousUnitsVac,
                        Tot_Occ_Units,
                        Lives_in_Same_Place,
                        VacantForRent,
                        OwnerOccUnits,
                        RenterOccUnits,
                        MedOwnOccHomeValue,
                        
                        #Housing Costs and Cost Burdens
                        NoComputer,
                        NoInternet,
                        MedGrossRent,
                        SMOCAPI35PlusWithMortgage,
                        SMOCAPI35PlusWOutMortgage,
                        GRAPI35PlusPerc,
                        NoTeleInHome,
                        
                        #Educational Attainment
                        HSGradOrHigher,
                        BachDegOrHigher,
                        
                        #School Enrollment
                        Tot3PlusEnr,
                        EnrPreK,
                        EnrKinder,
                        Enr1to4,
                        Enr5to8,
                        Enr9to12,
                        EnrUndergrad,
                        EnrKto12,
                        EnrGrad,
                        EnrPublic,
                        EnrPrivate,
                        ApproxPerc_Uni_Students,
                        
                        #Commute
                        TotTravelToWork,
                        DroveAloneToWork,
                        CarpooledToWork,
                        PublicTransitToWork,
                        WorkInPlaceOfResidence,
                        WorkOutOfPlaceOfResidence,
                        NoVehiclesAvailable,
                        Avg_Trav_Time_Work,
                        
                        #Employment
                        InCivLabFor,
                        Employed,
                        Unemployed,
                        Age16to64,
                        MedAgeWorkers,
                        TotFullTimeYrRnd,
                        MeanHrsWorked,
                        Workers16Plus,
                        
                        #Income and Benefits
                        Uninsured,
                        Public_Insurance,
                        TotInsurance,
                        MedHHInc,
                        WithPubAssistInc,
                        SNAP,
                        LaboForcPartiRate,
                        UnemplRate,
                        Youth_UnemplRate,
                        Avg_CPAI,
                        PovRate,
                        
                        #Weights
                        PartialTract,
                        PopulationWeight_TotalPop,
                        PopulationWeight_0to17pop,
                        HouseholdWeight_Total,
                        HouseholdWeight_HouseholdsWithChildrenUnder18,
                        
                        #Tracts
                        GEOID
                        ) %>% 
                      mutate(
                        
                        #Population
                        W_TotPop = TotPop * PopulationWeight_TotalPop, 
                        W_Households = Households * HouseholdWeight_Total,
                        W_One_Person_Fem_HH = One_Person_Fem_HH * HouseholdWeight_Total,
                        W_Male = Male * PopulationWeight_TotalPop,
                        W_Female = Female * PopulationWeight_TotalPop,
                        W_Tot25Plus = Tot25Plus * PopulationWeight_TotalPop,
                        W_Pop16Plus = Pop16Plus * PopulationWeight_TotalPop,
                        W_Disabled = Disabled * PopulationWeight_TotalPop,
                        W_Under18 = Under18 * PopulationWeight_0to17pop,
                        W_Over65 = Over65 * PopulationWeight_TotalPop, 
                        
                        #Race
                        W_Race_All_Other = Race_All_Other * PopulationWeight_TotalPop,
                        W_RaceWh = RaceWh * PopulationWeight_TotalPop,
                        W_RaceBl = RaceBl * PopulationWeight_TotalPop,
                        W_EthnHispLat = EthnHispLat * PopulationWeight_TotalPop,
                        W_RaceAsian = RaceAsian * PopulationWeight_TotalPop,
                        
                        #Housing Occupancy and Vacancy
                        W_TotHousUnits = TotHousUnits * HouseholdWeight_Total,
                        W_HousUnitsOcc = HousUnitsOcc * HouseholdWeight_Total,
                        W_HousUnitsVac = HousUnitsVac * HouseholdWeight_Total,
                        W_Tot_Occ_Units = Tot_Occ_Units * HouseholdWeight_Total,
                        W_Lives_in_Same_Place = Lives_in_Same_Place * PopulationWeight_TotalPop,
                        W_VacantForRent = VacantForRent * HouseholdWeight_Total,
                        W_OwnerOccUnits = OwnerOccUnits * HouseholdWeight_Total,
                        W_RenterOccUnits = RenterOccUnits * HouseholdWeight_Total,
                        
                        #Housing Costs and Cost Burdens
                        W_NoComputer = NoComputer * PopulationWeight_TotalPop,
                        W_NoInternet = NoInternet * PopulationWeight_TotalPop,
                        W_SMOCAPI35PlusWithMortgage = SMOCAPI35PlusWithMortgage * HouseholdWeight_Total,
                        W_SMOCAPI35PlusWOutMortgage = SMOCAPI35PlusWOutMortgage * HouseholdWeight_Total,
                        W_GRAPI35PlusPerc = GRAPI35PlusPerc * HouseholdWeight_Total,
                        W_NoTeleInHome = NoTeleInHome * PopulationWeight_TotalPop,
                        
                        #Educational Attainment
                        W_HSGradOrHigher = HSGradOrHigher * PopulationWeight_TotalPop,
                        W_BachDegOrHigher = BachDegOrHigher * PopulationWeight_TotalPop,
                        
                        #School Enrollment
                        W_Tot3PlusEnr = Tot3PlusEnr * PopulationWeight_0to17pop,
                        W_EnrPreK = EnrPreK * PopulationWeight_0to17pop,
                        W_EnrKinder = EnrKinder * PopulationWeight_0to17pop,
                        W_Enr1to4 = Enr1to4 * PopulationWeight_0to17pop,
                        W_Enr5to8 = Enr5to8 * PopulationWeight_0to17pop,
                        W_Enr9to12 = Enr9to12 * PopulationWeight_0to17pop,
                        EnrUndergrad, #Cannot be weighted or aggregated
                        W_EnrKto12 = EnrKto12 * PopulationWeight_0to17pop,
                        EnrGrad = EnrGrad, #Cannot be weighted or aggregated
                        EnrPublic = EnrPublic, #Cannot be weighted or aggregated
                        EnrPrivate, #Cannot be weighted or aggregated
                        
                        #Commute
                        W_TotTravelToWork = TotTravelToWork * PopulationWeight_TotalPop,
                        W_DroveAloneToWork = DroveAloneToWork * PopulationWeight_TotalPop,
                        W_CarpooledToWork = CarpooledToWork * PopulationWeight_TotalPop,
                        W_PublicTransitToWork = PublicTransitToWork * PopulationWeight_TotalPop,
                        W_WorkInPlaceOfResidence = WorkInPlaceOfResidence * PopulationWeight_TotalPop,
                        W_WorkOutOfPlaceOfResidence = WorkOutOfPlaceOfResidence * PopulationWeight_TotalPop,
                        W_NoVehiclesAvailable = NoVehiclesAvailable * PopulationWeight_TotalPop,
                        
                        #Employment
                        W_InCivLabFor = InCivLabFor * PopulationWeight_TotalPop,
                        W_Employed = Employed * PopulationWeight_TotalPop,
                        W_Unemployed = Unemployed * PopulationWeight_TotalPop,
                        W_Age16to64 = Age16to64 * PopulationWeight_TotalPop,
                        W_TotFullTimeYrRnd = TotFullTimeYrRnd * PopulationWeight_TotalPop,
                        W_Workers16Plus = Workers16Plus * PopulationWeight_TotalPop,
                        
                        #Income and Benefits
                        W_Uninsured = Uninsured * PopulationWeight_TotalPop,
                        W_Public_Insurance = Public_Insurance * PopulationWeight_TotalPop,
                        W_TotInsurance = TotInsurance * PopulationWeight_TotalPop,
                        W_WithPubAssistInc = WithPubAssistInc * PopulationWeight_TotalPop,
                        W_SNAP = SNAP * HouseholdWeight_Total)
                    
                    
                          #2014----
                    
                    all.2014.weights <- all.2014.pz.calc %>%
                      left_join(weights, by = "GEOID") %>%
                      select(
                        
                        #Population
                        TotPop,
                        Households,
                        One_Person_Fem_HH,
                        Male,
                        Female,
                        MedAge,
                        Tot25Plus,
                        Pop16Plus,
                        Disabled,
                        Under18,
                        Over65,
                        
                        #Race
                        Race_All_Other,
                        RaceWh,
                        RaceBl,
                        EthnHispLat,
                        RaceAsian,
                        
                        #Housing Occupancy and Vacancy
                        TotHousUnits,
                        HousUnitsOcc,
                        HousUnitsVac,
                        Tot_Occ_Units,
                        Lives_in_Same_Place,
                        VacantForRent,
                        OwnerOccUnits,
                        RenterOccUnits,
                        MedOwnOccHomeValue,
                        
                        #Housing Costs and Cost Burdens
                #        NoComputer,
                #        NoInternet,
                        MedGrossRent,
                        SMOCAPI35PlusWithMortgage,
                        SMOCAPI35PlusWOutMortgage,
                        GRAPI35PlusPerc,
                        NoTeleInHome,
                        
                        #Educational Attainment
                        HSGradOrHigher,
                        BachDegOrHigher,
                        
                        #School Enrollment
                        Tot3PlusEnr,
                        EnrPreK,
                        EnrKinder,
                        Enr1to4,
                        Enr5to8,
                        Enr9to12,
                        EnrUndergrad,
                        EnrKto12,
                        EnrGrad,
                        EnrPublic,
                        EnrPrivate,
                        ApproxPerc_Uni_Students,
                        
                        #Commute
                        TotTravelToWork,
                        DroveAloneToWork,
                        CarpooledToWork,
                        PublicTransitToWork,
                        WorkInPlaceOfResidence,
                        WorkOutOfPlaceOfResidence,
                        NoVehiclesAvailable,
                        Avg_Trav_Time_Work,
                        
                        #Employment
                        InCivLabFor,
                        Employed,
                        Unemployed,
                        Age16to64,
                        MedAgeWorkers,
                        TotFullTimeYrRnd,
                        MeanHrsWorked,
                        Workers16Plus,
                        
                        #Income and Benefits
                  #      Uninsured,
                  #      Public_Insurance,
                  #      TotInsurance,
                        MedHHInc,
                        WithPubAssistInc,
                        SNAP,
                        LaboForcPartiRate,
                        UnemplRate,
                        Youth_UnemplRate,
                        Avg_CPAI,
                        PovRate,
                
                        #Weights
                        PartialTract,
                        PopulationWeight_TotalPop,
                        PopulationWeight_0to17pop,
                        HouseholdWeight_Total,
                        HouseholdWeight_HouseholdsWithChildrenUnder18,
                
                        #Tracts
                        GEOID
                        ) %>% 
                      mutate(
                        
                        #Population
                        W_TotPop = TotPop * PopulationWeight_TotalPop, 
                        W_Households = Households * HouseholdWeight_Total,
                        W_One_Person_Fem_HH = One_Person_Fem_HH * HouseholdWeight_Total,
                        W_Male = Male * PopulationWeight_TotalPop,
                        W_Female = Female * PopulationWeight_TotalPop,
                        W_Tot25Plus = Tot25Plus * PopulationWeight_TotalPop,
                        W_Pop16Plus = Pop16Plus * PopulationWeight_TotalPop,
                        W_Disabled = Disabled * PopulationWeight_TotalPop,
                        W_Under18 = Under18 * PopulationWeight_0to17pop,
                        W_Over65 = Over65 * PopulationWeight_TotalPop, 
                        
                        #Race
                        W_Race_All_Other = Race_All_Other * PopulationWeight_TotalPop,
                        W_RaceWh = RaceWh * PopulationWeight_TotalPop,
                        W_RaceBl = RaceBl * PopulationWeight_TotalPop,
                        W_EthnHispLat = EthnHispLat * PopulationWeight_TotalPop,
                        W_RaceAsian = RaceAsian * PopulationWeight_TotalPop,
                        
                        #Housing Occupancy and Vacancy
                        W_TotHousUnits = TotHousUnits * HouseholdWeight_Total,
                        W_HousUnitsOcc = HousUnitsOcc * HouseholdWeight_Total,
                        W_HousUnitsVac = HousUnitsVac * HouseholdWeight_Total,
                        W_Tot_Occ_Units = Tot_Occ_Units * HouseholdWeight_Total,
                        W_Lives_in_Same_Place = Lives_in_Same_Place * PopulationWeight_TotalPop,
                        W_VacantForRent = VacantForRent * HouseholdWeight_Total,
                        W_OwnerOccUnits = OwnerOccUnits * HouseholdWeight_Total,
                        W_RenterOccUnits = RenterOccUnits * HouseholdWeight_Total,
                        
                        #Housing Costs and Cost Burdens
               #         W_NoComputer = NoComputer * PopulationWeight_TotalPop,
              #        W_NoInternet = NoInternet * PopulationWeight_TotalPop,
                        W_SMOCAPI35PlusWithMortgage = SMOCAPI35PlusWithMortgage * HouseholdWeight_Total,
                        W_SMOCAPI35PlusWOutMortgage = SMOCAPI35PlusWOutMortgage * HouseholdWeight_Total,
                        W_GRAPI35PlusPerc = GRAPI35PlusPerc * HouseholdWeight_Total,
                        W_NoTeleInHome = NoTeleInHome * PopulationWeight_TotalPop,
                        
                        #Educational Attainment
                        W_HSGradOrHigher = HSGradOrHigher * PopulationWeight_TotalPop,
                        W_BachDegOrHigher = BachDegOrHigher * PopulationWeight_TotalPop,
                        
                        #School Enrollment
                        W_Tot3PlusEnr = Tot3PlusEnr * PopulationWeight_0to17pop,
                        W_EnrPreK = EnrPreK * PopulationWeight_0to17pop,
                        W_EnrKinder = EnrKinder * PopulationWeight_0to17pop,
                        W_Enr1to4 = Enr1to4 * PopulationWeight_0to17pop,
                        W_Enr5to8 = Enr5to8 * PopulationWeight_0to17pop,
                        W_Enr9to12 = Enr9to12 * PopulationWeight_0to17pop,
                        EnrUndergrad, #Cannot be weighted or aggregated
                        W_EnrKto12 = EnrKto12 * PopulationWeight_0to17pop,
                        EnrGrad = EnrGrad, #Cannot be weighted or aggregated
                        EnrPublic = EnrPublic, #Cannot be weighted or aggregated
                        EnrPrivate = EnrPrivate, #Cannot be weighted or aggregated
                        
                        #Commute
                        W_TotTravelToWork = TotTravelToWork * PopulationWeight_TotalPop,
                        W_DroveAloneToWork = DroveAloneToWork * PopulationWeight_TotalPop,
                        W_CarpooledToWork = CarpooledToWork * PopulationWeight_TotalPop,
                        W_PublicTransitToWork = PublicTransitToWork * PopulationWeight_TotalPop,
                        W_WorkInPlaceOfResidence = WorkInPlaceOfResidence * PopulationWeight_TotalPop,
                        W_WorkOutOfPlaceOfResidence = WorkOutOfPlaceOfResidence * PopulationWeight_TotalPop,
                        W_NoVehiclesAvailable = NoVehiclesAvailable * PopulationWeight_TotalPop,
                        
                        #Employment
                        W_InCivLabFor = InCivLabFor * PopulationWeight_TotalPop,
                        W_Employed = Employed * PopulationWeight_TotalPop,
                        W_Unemployed = Unemployed * PopulationWeight_TotalPop,
                        W_Age16to64 = Age16to64 * PopulationWeight_TotalPop,
                        W_TotFullTimeYrRnd = TotFullTimeYrRnd * PopulationWeight_TotalPop,
                        W_Workers16Plus = Workers16Plus * PopulationWeight_TotalPop,
                        
                        #Income and Benefits
                   #     W_Uninsured = Uninsured * PopulationWeight_TotalPop,
                    #    W_Public_Insurance = Public_Insurance * PopulationWeight_TotalPop,
                   #     W_TotInsurance = TotInsurance * PopulationWeight_TotalPop,
                        W_WithPubAssistInc = WithPubAssistInc * PopulationWeight_TotalPop,
                        W_SNAP = SNAP * HouseholdWeight_Total)
                    
                    
                          #2009----
                    
                    all.2009.weights <- all.2009.pz.calc %>%
                      left_join(weights, by = "GEOID") %>%
                      select(
                        
                        #Population
                        TotPop,
                        Households,
                        One_Person_Fem_HH,
                        Male,
                        Female,
                        MedAge,
                #        Tot25Plus,
                #        Pop16Plus,
                #        Disabled,
                        Under18,
                        Over65,
                        
                        #Race
                        Race_All_Other,
                        RaceWh,
                        RaceBl,
                        EthnHispLat,
                        RaceAsian,
                        
                        #Housing Occupancy and Vacancy
                        TotHousUnits,
                        HousUnitsOcc,
                        HousUnitsVac,
                        Tot_Occ_Units,
                #        Lives_in_Same_Place,
                        VacantForRent,
                        OwnerOccUnits,
                        RenterOccUnits,
                        MedOwnOccHomeValue,
                        
                        #Housing Costs and Cost Burdens
              #         NoComputer,
              #         NoInternet,
                        MedGrossRent,
                        SMOCAPI35PlusWithMortgage,
                        SMOCAPI35PlusWOutMortgage,
                        GRAPI35PlusPerc,
                        NoTeleInHome,
                        
                        #Educational Attainment
             #           HSGradOrHigher,
             #           BachDegOrHigher,
                        
                        #School Enrollment
                        Tot3PlusEnr,
                        EnrPreK,
                        EnrKinder,
                        Enr1to4,
                        Enr5to8,
                        Enr9to12,
                        EnrUndergrad,
                        EnrKto12,
                        EnrGrad,
                        EnrPublic,
                        EnrPrivate,
                        ApproxPerc_Uni_Students,
                        
                        #Commute
              #          TotTravelToWork,
              #          DroveAloneToWork,
              #          CarpooledToWork,
              #          PublicTransitToWork,
              #          WorkInPlaceOfResidence,
              #          WorkOutOfPlaceOfResidence,
              #          NoVehiclesAvailable,
              #          Avg_Trav_Time_Work,
                        
                        #Employment
              #          InCivLabFor,
              #          Employed,
              #          Unemployed,
                        Age16to64,
              #          MedAgeWorkers,
              #          TotFullTimeYrRnd,
              #          MeanHrsWorked,
                        Workers16Plus,
                        
                        #Income and Benefits
            #            Uninsured,
            #            Public_Insurance,
            #            TotInsurance,
                        MedHHInc,
                        WithPubAssistInc,
                        SNAP,
            #            LaboForcPartiRate,
            #            UnemplRate,
            #            Youth_UnemplRate,
            #            Avg_CPAI,
                        PovRate,
                        
                        #Weights
                        PartialTract,
                        PopulationWeight_TotalPop,
                        PopulationWeight_0to17pop,
                        HouseholdWeight_Total,
                        HouseholdWeight_HouseholdsWithChildrenUnder18,
            
                        #Tracts
                        GEOID
                        ) %>% 
                      mutate(
                        
                        #Population
                        W_TotPop = TotPop * PopulationWeight_TotalPop, 
                        W_Households = Households * HouseholdWeight_Total,
                        W_One_Person_Fem_HH = One_Person_Fem_HH * HouseholdWeight_Total,
                        W_Male = Male * PopulationWeight_TotalPop,
                        W_Female = Female * PopulationWeight_TotalPop,
                        MedAge, #Cannot be weighted or aggregated
                #       W_Tot25Plus = Tot25Plus * PopulationWeight_TotalPop,
                #       W_Pop16Plus = Pop16Plus * PopulationWeight_TotalPop,
                #       W_Disabled = Disabled * PopulationWeight_TotalPop,
                        W_Under18 = Under18 * PopulationWeight_0to17pop,
                        W_Over65 = Over65 * PopulationWeight_TotalPop, 
                        
                        #Race
                        W_Race_All_Other = Race_All_Other * PopulationWeight_TotalPop,
                        W_RaceWh = RaceWh * PopulationWeight_TotalPop,
                        W_RaceBl = RaceBl * PopulationWeight_TotalPop,
                        W_EthnHispLat = EthnHispLat * PopulationWeight_TotalPop,
                        W_RaceAsian = RaceAsian * PopulationWeight_TotalPop,
                        
                        #Housing Occupancy and Vacancy
                        W_TotHousUnits = TotHousUnits * HouseholdWeight_Total,
                        W_HousUnitsOcc = HousUnitsOcc * HouseholdWeight_Total,
                        W_HousUnitsVac = HousUnitsVac * HouseholdWeight_Total,
                        W_Tot_Occ_Units = Tot_Occ_Units * HouseholdWeight_Total,
                #       W_Lives_in_Same_Place = Lives_in_Same_Place * PopulationWeight_TotalPop,
                        W_VacantForRent = VacantForRent * HouseholdWeight_Total,
                        W_OwnerOccUnits = OwnerOccUnits * HouseholdWeight_Total,
                        W_RenterOccUnits = RenterOccUnits * HouseholdWeight_Total,
                        
                        #Housing Costs and Cost Burdens
            #           W_NoComputer = NoComputer * PopulationWeight_TotalPop,
            #           W_NoInternet = NoInternet * PopulationWeight_TotalPop,
                        MedGrossRent, #Cannot be weighted or aggregated
                        W_SMOCAPI35PlusWithMortgage = SMOCAPI35PlusWithMortgage * HouseholdWeight_Total,
                        W_SMOCAPI35PlusWOutMortgage = SMOCAPI35PlusWOutMortgage * HouseholdWeight_Total,
                        W_GRAPI35PlusPerc = GRAPI35PlusPerc * HouseholdWeight_Total,
                        W_NoTeleInHome = NoTeleInHome * PopulationWeight_TotalPop,
                        
                        #Educational Attainment
            #            W_HSGradOrHigher = HSGradOrHigher * PopulationWeight_TotalPop,
            #            W_BachDegOrHigher = BachDegOrHigher * PopulationWeight_TotalPop,
                        
                        #School Enrollment
                        W_Tot3PlusEnr = Tot3PlusEnr * PopulationWeight_0to17pop,
                        W_EnrPreK = EnrPreK * PopulationWeight_0to17pop,
                        W_EnrKinder = EnrKinder * PopulationWeight_0to17pop,
                        W_Enr1to4 = Enr1to4 * PopulationWeight_0to17pop,
                        W_Enr5to8 = Enr5to8 * PopulationWeight_0to17pop,
                        W_Enr9to12 = Enr9to12 * PopulationWeight_0to17pop,
                        EnrUndergrad, #Cannot be weighted or aggregated
                        W_EnrKto12 = EnrKto12 * PopulationWeight_0to17pop,
                        EnrGrad = EnrGrad, #Cannot be weighted or aggregated
                        EnrPublic = EnrPublic, #Cannot be weighted or aggregated
                        EnrPrivate = EnrPrivate, #Cannot be weighted or aggregated
                        
                        #Commute
            #            W_TotTravelToWork = TotTravelToWork * PopulationWeight_TotalPop,
             #           W_DroveAloneToWork = DroveAloneToWork * PopulationWeight_TotalPop,
             #           W_CarpooledToWork = CarpooledToWork * PopulationWeight_TotalPop,
            #            W_PublicTransitToWork = PublicTransitToWork * PopulationWeight_TotalPop,
             #           W_WorkInPlaceOfResidence = WorkInPlaceOfResidence * PopulationWeight_TotalPop,
            #            W_WorkOutOfPlaceOfResidence = WorkOutOfPlaceOfResidence * PopulationWeight_TotalPop,
            #            W_NoVehiclesAvailable = NoVehiclesAvailable * PopulationWeight_TotalPop,
                        
                        #Employment
            #            W_InCivLabFor = InCivLabFor * PopulationWeight_TotalPop,
            #            W_Employed = Employed * PopulationWeight_TotalPop,
            #            W_Unemployed = Unemployed * PopulationWeight_TotalPop,
                        W_Age16to64 = Age16to64 * PopulationWeight_TotalPop,
            #            W_TotFullTimeYrRnd = TotFullTimeYrRnd * PopulationWeight_TotalPop,
                        W_Workers16Plus = Workers16Plus * PopulationWeight_TotalPop,
                        
                        #Income and Benefits
             #           W_Uninsured = Uninsured * PopulationWeight_TotalPop,
             #          W_Public_Insurance = Public_Insurance * PopulationWeight_TotalPop,
             #           W_TotInsurance = TotInsurance * PopulationWeight_TotalPop,
                        W_WithPubAssistInc = WithPubAssistInc * PopulationWeight_TotalPop,
                        W_SNAP = SNAP * HouseholdWeight_Total)
                    
                    
                    
      #Part 6: Export as .csv files----
                    
                    #Step 1: Use write.csv() to export files to the correct folder
                    
                    write.csv(all.2019.weights, 
                              "./Final_Disaggregated_Data/2019_ACS_Data_Final.csv")
                    write.csv(all.2014.weights, 
                              "./Final_Disaggregated_Data/2014_ACS_Data_Final.csv")
                    write.csv(all.2009.weights, 
                              "./Final_Disaggregated_Data/2009_ACS_Data_Final.csv")
                    
      #Part 7: Congratulations! You've finished!---- 
      #You've finished pulling ACS data. Make sure to be attentive
      #to any anomalies in the code. Comparing it to Policy Map and Promise Neighborhoods
      #data will help you make sure that you're on the right track. Next up: exploratory analysis.