# Higuera_et_al_PNAS-Nexus_2023
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

Directory with .csv files for total area classified as burnable and unburnable, based on methods described in main text of the associated publication. Each file summarizes this for different spatial units:
#####  1. burnable_area_ecoLevel1.csv -- Level 1 ecoregions
#####  2. burnable_area_ecoLevel3.csv -- Level 3 ecoregions (not used in analyses) 
#####  3. burnable_area_gacc.csv -- Geographic area coordination centers
#####  4. burnable_area_states.csv -- Each of the 11 western states

###  derived: 

Directory with .mat files (MATLAB data file) with summary statistics for fire-climate relationships at the state level, based on regression between log(annual area burned) and VPD, as described in the methods section in the main text of the associated paper:
##### 1. fireClimate_m_STUSPS -- slope 
##### 2. fireClimate_p_STUSPS -- p-value for slope
##### 3. fireClimate_r_STUSPS -- correlation coefficient

### gridmet: 

Climate data from Gridmet, as described in the methods section of the associated publication. 

##### 1. Raw data from gridmet are in .csv format, with spatial domain, months averaged over, and climate variable indicated in the file name. For example, "gridmet_natl_states_may_sept_avg_vpd_.csv" includes Average May-September vapor pressure deficit, averaged over each western state. 
##### 2. extractClimateData.m is a MATLAB script that accesses and summarizes the data in the .csv files, and saves the summaries in .mat files (MATLAB data format files). 
##### 3. *.mat files are the resulting data files, some of which are used in figure scripts. 

### MTBS: 

Monitoring trends in burn severity data, used for Figure S1 in the associated publication. 

##### 1. mtbs_western_wildfire_events_1999to2020.csv -- MTBS data associated with 7268 individual fires from the 11 western states, from 1999 to 2020. 

### qualitative_supportingInfo: 

Seven PDF files of agency reports used to update the cause of ignition for fires in the past c. 5 years of the dataset. 

### structure_abundance: 

Structure abundance in flammable vegetation, calculated as described in the methods section of the associated publication. File names reference "exposure" but we refer to this as abundance here and in the text of the associated publication. 
#####  1. StrucExposureToFire_ecoLevel1.csv -- Level 1 ecoregions
#####  2. StrucExposureToFire_ecoLevel3.csv -- Level 3 ecoregions (not used in analyses) 
#####  3. StrucExposureToFire_area_gacc.csv -- Geographic area coordination centers
#####  4. StrucExposureToFire_states.csv -- Each of the 11 western states
##### 5. StructureAbundance_WesternStates.mat -- Data summarized and saved in MATLAB format, called upon from scripts used in analysis and figure creation. 

### wf-incidents: 

Wildfire incidents included in the ICS209-PLUS dataset, described in the methods section of the associated publication. These are the foundational data used for the publication, called upon in the script "ICS209_PLUS_0_ImportData_UpdateCauseCode.m" described above. This script created the files "ics209plus_wf_incidents_west_1999to2020_qc_PEH.xlsx" and the two *.mat data files in this directory. The relationship among these files is described in the included "ReadMe.txt" file within this directory. 

##### 1. ics209plus_wf_incidents_west_1999to2020_qc.xlsx -- raw input data, without the updated cause codes. 
##### 2. ics209plus_wf_incidents_west_1999to2020_qc_PEH.xlsx -- fire incidents, with the updated cause codes.
##### 3. ics209plus_wf_incidents_west_1999to2020_qc_PEH.mat -- same data saved in .mat format, for efficiency
##### 4. strucLossDOY.mat -- day-of-year (0-366) associated with each wildfire event, in MATLAB data format. This is derived in included scripts, described above. 


## 3. FIGURES

Figures in .jpg, .png, .ppt, and .fig (MATLAB figure) formats. Fire names indicate figure number from the main text or supporting information. Three .pdf files group figures from the supporting information by state, ecoregion (level 1), and GACCs. The .pptx file include figures from the main text, in Power Point format. There is one subdirectory, describe below. 

### Figures_TIFF_mat_format: 

Main publication figures in .tiff format, at 600 dpi, and selected figures from supporting information in .fig format (MATLAB figure format).
