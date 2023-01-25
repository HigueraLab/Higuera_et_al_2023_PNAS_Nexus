Data file with “_PEH” appended to the end was created as follows: 

1. Run script ICS209_PLUS_0_ImportData_UpdateCauseCode.m to open data in 
ics209plus_wf_incidents_west_1999to2020_qc.xls. This script will update
the CAUSE_UPDATED field based on information in FOD_CAUSE, and then 
manually based on checking media, CalFire, and other reports. All manual 
updates are described in annotation text in the .m script referenced above. 
Information supporting these updates is also included in the 
"qualitative_supportingInfo" directory found within the "data" directory.  

2. Save new files (.xlsx and .mat format) with “_PEH” appended to the file name.
These are the final data used in the analyses included in the manuscript.

P. Higuera, December 2021
Updated: Jan. 2023 for publication.