# Higuera_et_al_2023_PNAS-Nexus
Data, code, and figures from "Shifting social-ecological fire regimes explain increasing structure loss from Western wildfires," PNAS-Nexus

## Overview

This archive includes data and scripts needed to reproduce the analyses in Higuera et al. (2023). After extracting the .zip archive, there are three directories: code, data, and figures. Contents in each directory are describe below.

**Contact:** Philip Higuera, University of Montana PaleoEcology and Fire Ecology Lab, www.umt.edu/paleo-fire-ecology-lab, philip.higuera@umontana.edu

### Citation Information

#### DATA and CODE - *please cite if you use data, code, or figures in your own work*
TBD (1/3/23)- Dryad citation 

#### Reference to paper 
Higuera, P.E., M.C. Cook, J.K. Balch, E.N. Stavros, A.L. Mahood, and L.A. St. Denis. 2023. Shifting social-ecological fire regimes explain increasing structure loss from Western wildfires. PNAS Nexus 2: In Press (1/3/2023).

#### Contents

## 1. CODE

Code includes 12 files, all written for MATLAB software (*.m file type; www.mathworks.com) and  generally fully commented. 

#### Files: ICS209_PLUS_*.m are script files 

The number included after ICS209_PLUS_ (0, 1, or 2) indicates the order in which the scripts should be run: "0" imports raw data and creates datasets used in subsequent analyses; this does not need to be run to recreate the figures in the paper, only if the input data changed; "1" loads the datasets used in the analyses, from the "data" directory; and "2" does the analyses and creates the related figures from the paper. File names indicate the figure(s) from the main text or supporting information which are created. 

#### Files: ktaub.m and Theil_Sen_Regression.m are MATLAB functions

These are called upon in some of the .m scripts noted above, to calculate the Theil-Sen slope and subsequent statistics. These files were accessed via www.mathworks.com and are fully commented, including authors and citations. 


## 2. DATA

Data includes seven directories, describe below. 

###  burnable_area: 

Directory with .csv files for total area classified as burnable and unburnable, based on methods described in main text of the associated publication. Units are in km2, as indicated in the column title (e.g., "Burnable_Km2"); other columns identify the region. For example, for ecoregion level 1: "OID_" is an arbitrary id; "NA_L1CODE" is the ecoregion level 1 code; and "NA_L1NAME" is the ecoregion level 1 name. Each file summarizes this for different spatial units:
#####  1. burnable_area_ecoLevel1.csv -- Level 1 ecoregions
#####  2. burnable_area_ecoLevel3.csv -- Level 3 ecoregions (not used in analyses) 
#####  3. burnable_area_gacc.csv -- Geographic area coordination centers
#####  4. burnable_area_states.csv -- Each of the 11 western states

###  derived: 

Directory with .mat files (MATLAB data file) with summary statistics for fire-climate relationships at the state level, based on regression between log(annual area burned) and VPD, as described in the methods section in the main text of the associated paper. For each variable, rows (i) = states, from top to bottom, with the last row the entire West; columns (j)= area burned based on ignition source: non-lightning, lightning, total; and pages (k) = for correlations with year-of climate (1) and prior-year climate (2). This is also described in the comments in the MATLAB script "ICS209_PLUS_2_SaveData_FireClimateRelationships.m" on line 16-17. 
##### 1. fireClimate_m_STUSPS -- slope 
##### 2. fireClimate_p_STUSPS -- p-value for slope
##### 3. fireClimate_r_STUSPS -- correlation coefficient

### gridmet: 

Climate data from Gridmet, as described in the methods section of the associated publication. 

##### 1. Raw data from gridmet are in .csv format, with spatial domain, months averaged over, and climate variable indicated in the file name. These data are for each  month (May-Sep., 5-9) of each year, 1979 through 2021 (columns); this is longer than the period of analyses used in the associated publication. File names include the spatial area summarized over (rows), and the climate metric (numeric values). For example, "gridmet_natl_states_may_sept_avg_vpd_.csv" includes Average May-September vapor pressure deficit, averaged over each western state. Note that columns are ordered FIRST by month, and THEN by year, so they are not in chronological order from left to right. 
##### 2. extractClimateData.m is a MATLAB script that accesses and summarizes the data in the .csv files, and saves the summaries in .mat files (MATLAB data format files). These summaries are averages for June-August only, from 1999-2020, the analyses used in the associated publication. Details are described below. 
##### 3. *.mat files are the resulting data files (after running extract ClimateData.m), which are used in the analyses and figure scripts for the associated publication. The .mat files call on the raw .csv data to summarize average June-August (JJA) metrics, for only the period . The file name for each .mat file indicates the climate metric (e.g., 1000-hr fuel moisture = "fm1000", vapor pressure deficit = "vpd") and region (e.g., entire West = "West", states = "WestStates", etc.). 

### MTBS: 

Monitoring trends in burn severity data, used for Figure S1 in the associated publication. These data are as downloaded from the publically accessible MTBS web site: www.mtbs.gov. 

##### 1. mtbs_western_wildfire_events_1999to2020.csv -- MTBS data associated with 7268 individual fires from the 11 western states, from 1999 to 2020. Each row in the dataset is an individual fire event. Columns are as follows: Event_ID = MTBS event identification; "irwinID" = additional identification from MTBS; "Incid_Name" = incident name; "Incid_Type" = incident type: wildfire, prescribed fire, or unknown; "BurnBndAc" = are burned, in acres; "Ig_Date" = ignition date; "Ig_Year" = ignition year; "Ig_Month" = ignition month; "STUSPS" = state in which the  majority of the fire burned.

### qualitative_supportingInfo: 

Seven PDF files of agency reports used to update the cause of ignition for fires in the past c. 5 years of the dataset. 

### structure_abundance: 

Structure abundance in flammable vegetation, calculated as described in the methods section of the associated publication. File names reference "exposure" but we refer to this as abundance here and in the text of the associated publication. Each file summarizes structure abundance for different spatial levels within the 11 western states: states, ecoregion level 1 or 3 (not used in the associated paper), or geographic coordination centers (GACC). Rows = spatial level (e.g., states, indicated by column 1); columns 2-5 includes values for the years 2000, 2005 2010, and 2015, as indicated in the column header (e.g., "BURP2000").  
#####  1. StrucExposureToFire_ecoLevel1.csv -- Level 1 ecoregions
#####  2. StrucExposureToFire_ecoLevel3.csv -- Level 3 ecoregions (not used in analyses) 
#####  3. StrucExposureToFire_area_gacc.csv -- Geographic area coordination centers
#####  4. StrucExposureToFire_states.csv -- Each of the 11 western states
##### 5. StructureAbundance_WesternStates.mat -- Data summarized and saved in MATLAB format, called upon from scripts used in analysis and figure creation. 

### wf-incidents: 

Wildfire incidents included in the ICS209-PLUS dataset, described in the methods section of the associated publication, and as previously published by St. Denise et al. (2020), for incidents through 2017, and updated here through 2020. These are the foundational data used for the publication, called upon in the script "ICS209_PLUS_0_ImportData_UpdateCauseCode.m" described above. This script created the files "ics209plus_wf_incidents_west_1999to2020_qc_PEH.xlsx" and the two *.mat data files in this directory. The relationship among these files is described in the included "ReadMe.txt" file within this directory. These files includes numerous fields not used in this analysis.  

We used the following fields in the current work: INCIDENT_NAME (incident name); FINAL_ACRES (finale fire size, in acres); DISCOVERY_DOY (day of year the fire was discovered); POO_LATITUDE and POO_LONGITUDE (latitude and longitude of the point of origion of each fire); POJECTED_FINAL_IM_COSTS (final projected incident managment costs, in US dollors); STR_DESTROYED_TOTAL (total structures destroyed in the fire event); CAUSE (cause of ignition, from ICS-209 report); FOD_CAUSE (cause of ignition, from FOD reports); CAUSE_UPDATED (cause of ignition, after merging information from ICS-209, FOD, and supplementary information, as described in the associated publication: H = human-related, L = lightning, U = undetermined); tree_pct, shrub_pct, and herb_pct = percent tree, shrub, or herb cover around the point of origin of the fire, as described in the methods section of the associated publication. 

##### 1. ics209plus_wf_incidents_west_1999to2020_qc.xlsx -- raw input data, without the updated cause codes. 
##### 2. ics209plus_wf_incidents_west_1999to2020_qc_PEH.xlsx -- fire incidents, with the updated cause codes.
##### 3. ics209plus_wf_incidents_west_1999to2020_qc_PEH.mat -- same data saved in .mat format, for efficiency
##### 4. strucLossDOY.mat -- day-of-year (0-366) associated with each structure destroyed in wildfire event (rows, n = 85,014), in MATLAB data format. This is derived from the from the dataset describe above, with code included and described above. Column headings: "DOY" = day of year; "NonLightning" = 1 if the structure was destroyed in a fire with an ignition source not attributed to lightning, otherwsie NaN; "START_YEAR" = year of ignition; "STUSPS" = state; "GACCAbbrew" = abbreviation for geographic coordination center, GACC; "NA_L3NAME" and "NA_L3NAME" are the associated ecoregion/section names. 


## 3. FIGURES

Figures in .jpg, .png, .ppt, and .fig (MATLAB figure) formats. Fire names indicate figure number from the main text or supporting information. Three .pdf files group figures from the supporting information by state, ecoregion (level 1), and GACCs. The .pptx file include figures from the main text, in Power Point format. There is one subdirectory, describe below. 

### Figures_TIFF_mat_format: 

Main publication figures in .tiff format, at 600 dpi, and selected figures from supporting information in .fig format (MATLAB figure format).
