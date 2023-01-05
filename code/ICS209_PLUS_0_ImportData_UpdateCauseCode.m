% ICS209_PLUS_West_ImportData_UpdateCauseCode.m
%
% 1. Import tabular ICS-209-Plus dataset, after modifying and saving in 
% .xlsx format (i.e., see workflow under "Import data" below). 
% 
% 2. Update the CAUSE field using information from FOD_CAUSE field. 
%
% 3. Update the CAUSE field manually, for specific large fires. 
%
% 4. Save dataset in .mat format, for use in "ICS209_PLUS_West_Analysis.m"
% scrip.
%
% P. Higuera
% Created: December 2021
% Updated: ...Feb. 2022

clear all
cd C:\Users\philip.higuera.UM\Box\2_lab_SHARE\4_archivedData\Higuera_et_al_PNAS-Nexus_2023\data\wf-incidents

%% 1. Import data
%
% Workflow for setting up tabular data in 
% ics209plus_wf_incidents_west_1999to2020_qc.csv
% for use in Matlab scripts, as a .xlsx file: 
%
% 1. Open file in Excel :( 
% 2. % Replace "NA" with "NaN" (entire cell content!)
% 3. Save as SAMEFILENAME.xlsx
% 4. Open .xlsx file (below) and proceed.
%
% P. Higuera, December 2021
% Updated: Jan. 2022

data = readtable('ics209plus_wf_incidents_west_1999to2020_qc.xlsx');

%% 1. Create new variable CAUSE_UPDATED **OR** write over CAUSE_UPDATED
%%%% Start by duplicating CAUSE and appending it to the end of the table
% CAUSE_UPDATED = table(data.CAUSE,'VariableNames',{'CAUSE_UPDATED'});
% data = [data CAUSE_UPDATED];

data.CAUSE_UPDATED = data.CAUSE;

%% 2. Update new variable CAUSE_UPDATED with inforamtion from CAUSE and 
% FOD_CAUSE. There may reamine the challenge of fires that combined 
% multiple individual events. 

%%%% Inform 'U' in CAUSE_UPDATED from FOD_CAUSE field:
idx1 = strcmp(data.CAUSE,'U');     % All fires with unknown cuase 
    % assigned in the CAUSE field, AND... 
idx2 = ~contains(data.FOD_CAUSE,'Missing'); % All fires without "Missing..." 
idx3 = ~contains(data.FOD_CAUSE,'NaN');     % All fires without "NaN" 
idx = find(idx1 .* idx2 .* idx3); % All fires labeld 'U' in CAUSE field, 
    % but with a cause assigned in FOD_CAUSE field. 
L_count = 0; % Initalize count for fires newly assigned L
H_count = 0; % Initalize count for fires newly assigned H
L_area = 0; % Initalize count for area burned from fires newly assigned L
H_area = 0; % Initalize count for area burned from fires newly assigned H

for i = 1:length(idx)
    if contains(data.FOD_CAUSE(idx(i)),'Natural') % If FOD_CAUSE is "Natual",
        data.CAUSE_UPDATED(idx(i)) = {'L'};       % update to 'L'
        L_count = L_count + 1;
        L_area = L_area + data.FINAL_ACRES(idx(i));
    else
        data.CAUSE_UPDATED(idx(i)) = {'H'}; % Otherwise, treat code as 
        H_count = H_count + 1;              % human-related and update to 'H'
        H_area = H_area + data.FINAL_ACRES(idx(i));
    end
end

%%%% Inform 'O' in CAUSE_UPDATED field from FOD_CAUSE field:
idx1 = strcmp(data.CAUSE,'O');     % All fires with OTHER cuase 
    % assigned in the CAUSE field, AND... 
idx2 = ~contains(data.FOD_CAUSE,'Missing'); % All fires without "Missing..." 
idx3 = ~contains(data.FOD_CAUSE,'NaN');     % All fires without "NaN" 
idx = find(idx1 .* idx2 .* idx3); % All fires labeld 'O' in CAUSE field, 
    % but with a cause assigned in FOD_CAUSE field. 
L_count = 0; % Initalize count for fires newly assigned L
H_count = 0; % Initalize count for fires newly assigned H
L_area = 0; % Initalize count for area burned from fires newly assigned L
H_area = 0; % Initalize count for area burned from fires newly assigned H

for i = 1:length(idx)
    if contains(data.FOD_CAUSE(idx(i)),'Natural')   % If FOD_CAUSE is "Natual",
        data.CAUSE_UPDATED(idx(i)) = {'L'};         % update to 'L'
        L_count = L_count + 1;
        L_area = L_area + data.FINAL_ACRES(idx(i));
    else
        data.CAUSE_UPDATED(idx(i)) = {'H'}; % Otherwise, treat code as 
        H_count = H_count + 1;              % human-related and update to 'H'
        H_area = H_area + data.FINAL_ACRES(idx(i));
    end
end

%%%% Inform 'NaN' in CAUSE_UPDATED field from FOD_CAUSE field:
idx1 = strcmp(data.CAUSE_UPDATED,'NaN');     % All fires with NaN 
    % assigned in the CAUSE field, AND... 
idx2 = ~contains(data.FOD_CAUSE,'Missing'); % All fires without "Missing..." 
idx3 = ~contains(data.FOD_CAUSE,'NaN');     % All fires without "NaN..." 
idx = find(idx1 .* idx2 .* idx3); % All fires labeld 'NaN' in CAUSE field, 
    % but with a cause assigned in FOD_CAUSE field. 
L_count = 0; % Initalize count for fires newly assigned L
H_count = 0; % Initalize count for fires newly assigned H
for i = 1:length(idx)
    if contains(data.FOD_CAUSE(idx(i)),'Natural')   % If FOD_CAUSE is "Natual",
        data.CAUSE_UPDATED(idx(i)) = {'L'};         % update to 'L'
        L_count = L_count + 1;
    else
        data.CAUSE_UPDATED(idx(i)) = {'H'};     % Otherwise, treat code as 
        H_count = H_count + 1;                  % human-related and update to 'H'
    end
end

%%%% Change any 'NaN' values to 'Undetermined'
idx = find(strcmp(data.CAUSE_UPDATED,'NaN'));
data.CAUSE_UPDATED(idx) = {'U'};

%% 3. Add causes manually for large fire from 2020, based on InciWeb

%% OREGON FIRES (n = 17): 
idx = find(strcmp(data.INCIDENT_NAME,'2020_11934511_ARCHIE CREEK'));
data.CAUSE_UPDATED(idx) = {'H'};
% https://www.nrtoday.com/business/two-more-lawsuits-filed-in-connection-with-archie-creek-fire/article_db9b9ef4-c393-5861-9cab-237db535a488.html
% Labor Day wind storm

idx = find(strcmp(data.INCIDENT_NAME,'HOLIDAY FARM'));
data.CAUSE_UPDATED(idx) = {'H'};
% https://www.oregonlive.com/wildfires/2020/09/explosion-sparks-from-power-line-preceded-oregons-holiday-farm-fire-area-residents-say.html
% Labor Day wind storm

idx = find(strcmp(data.INCIDENT_ID,'2020_11930517_SLATER'));
data.CAUSE_UPDATED(idx) = {'H'};
% https://www.kdrv.com/news/local/slater-fire-lawsuit-expands-in-siskiyou-county/article_29c80954-94e2-11ec-99fb-a3b23e3b0c25.html

idx = find(strcmp(data.INCIDENT_ID,'2019_10719602_163 HK COMPLEX'));
data.CAUSE_UPDATED(idx) = {'L'};
% https://gacc.nifc.gov/nwcc/content/pdfs/archives/2019_NWCC_Annual_Fire_Report_Final.pdf
% Table 2: L ignition

idx = find(strcmp(data.INCIDENT_ID,'2019_10791868_MP 97'));
data.CAUSE_UPDATED(idx) = {'H'};
% https://www.usatoday.com/story/sponsor-story/keep-oregon-green/2020/03/06/3-recent-wildfires-started-people/4967348002/
% Again in 2019, the Milepost 97 Fire south of Canyonville was started by an illegal campfire on July 24.

idx = find(strcmp(data.INCIDENT_ID,'2020_11947327_ALMEDA DRIVE'));
data.CAUSE_UPDATED(idx) = {'H'};
% Labor Day wind storm; suspect charged with arson:
% https://www.oregonlive.com/crime/2020/09/man-arrested-charged-with-arson-in-connection-with-southern-oregon-fire.html

idx = find(strcmp(data.INCIDENT_ID,'2020_11766300_WORTHINGTON'));
data.CAUSE_UPDATED(idx) = {'L'};
% https://gacc.nifc.gov/nwcc/content/pdfs/archives/2020_NWCC_Annual_Fire_Report.pdf
% See Table 3, p. 30: "L" attributed to this fire.

idx = find(strcmp(data.INCIDENT_ID,'2020_11916628_WICKIUP'));
data.CAUSE_UPDATED(idx) = {'H'};
% https://gacc.nifc.gov/nwcc/content/pdfs/archives/2020_NWCC_Annual_Fire_Report.pdf
% See Table 3, p. 30: "H" attributed to this fire.

idx = find(strcmp(data.INCIDENT_ID,'2020_11723368_TELLER FLAT 0281 OD'));
data.CAUSE_UPDATED(idx) = {'H'};
% https://gacc.nifc.gov/nwcc/content/pdfs/archives/2020_NWCC_Annual_Fire_Report.pdf
% See Table 3, p. 30: "H" attributed to this fire.

idx = find(strcmp(data.INCIDENT_ID,'2020_11754053_BEN YOUNG'));
data.CAUSE_UPDATED(idx) = {'H'};
% https://gacc.nifc.gov/nwcc/content/pdfs/archives/2020_NWCC_Annual_Fire_Report.pdf
% See Table 3, p. 30: "H" attributed to this fire.

idx = find(strcmp(data.INCIDENT_ID,'2020_11933376_ECHO MTN. COMPLEX'));
data.CAUSE_UPDATED(idx) = {'H'};
% https://gacc.nifc.gov/nwcc/content/pdfs/archives/2020_NWCC_Annual_Fire_Report.pdf
% See Table 3, p. 30: "H" attributed to this fire.

idx = find(strcmp(data.INCIDENT_ID,'2018_9056853_MEMALOOSE #2'));
data.CAUSE_UPDATED(idx) = {'H'};
% https://gacc.nifc.gov/nwcc/content/pdfs/archives/2018_NWCC_Annual_Fire_Report_FINAL.pdf
% See Table 3, p. 24: "H" attributed to this fire.

idx = find(strcmp(data.INCIDENT_ID,'2018_9071786_WATSON CREEK'));
data.CAUSE_UPDATED(idx) = {'H'};
% https://gacc.nifc.gov/nwcc/content/pdfs/archives/2018_NWCC_Annual_Fire_Report_FINAL.pdf
% See Table 3, p. 24: "H" attributed to this fire. 

idx = find(strcmp(data.INCIDENT_ID,'2018_9025814_SOUTH UMPQUA COMPLEX'));
data.CAUSE_UPDATED(idx) = {'L'};
% https://gacc.nifc.gov/nwcc/content/pdfs/archives/2018_NWCC_Annual_Fire_Report_FINAL.pdf
% See Table 3, p. 24: "L" attributed to this fire. 

idx = find(strcmp(data.INCIDENT_ID,'2018_9041835_SOUTH VALLEY ROAD'));
data.CAUSE_UPDATED(idx) = {'H'};
% https://gacc.nifc.gov/nwcc/content/pdfs/archives/2018_NWCC_Annual_Fire_Report_FINAL.pdf
% See Table 3, p. 24: "H" attributed to this fire. 

idx = find(strcmp(data.INCIDENT_ID,'2015_2720828_LITTLE BASIN'));
data.CAUSE_UPDATED(idx) = {'H'};
% https://gacc.nifc.gov/nwcc/content/pdfs/archives/2015_NWCC_Annual_Fire_Report.pdf
% See Table 1, p. 9: "H" attributed to this fire.

idx = find(strcmp(data.INCIDENT_ID,'2015_2859379_FALLS CREEK'));
data.CAUSE_UPDATED(idx) = {'H'};
% https://gacc.nifc.gov/nwcc/content/pdfs/archives/2015_NWCC_Annual_Fire_Report.pdf
% See Table 4, p. 10: "H" attributed to this fire.

%% COLORADO FIRES (n = 6): 
idx = find(strcmp(data.INCIDENT_ID,'2020_11776240_PINE GULCH'));
data.CAUSE_UPDATED(idx) = {'L'};
% https://inciweb.nwcg.gov/incident/6906/ *Cause listed as "lightning" 

idx = find(strcmp(data.INCIDENT_NAME,'EAST TROUBLESOME'));
data.CAUSE_UPDATED(idx) = {'H'};
% UNDETERMINED, BUT LIKELY HUMAN
% https://www.skyhinews.com/news/us-forest-service-cause-of-east-troublesome-fire-remains-undetermined/

idx = find(strcmp(data.INCIDENT_NAME,'CAMERON PEAK'));
data.CAUSE_UPDATED(idx) = {'H'};
% UNDETERMINED, BUT BELIEVED TO BE HUMAN
% https://www.coloradoan.com/story/news/2020/10/15/what-caused-cameron-peak-fire-largest-wildfire-colorado-mullen-fire/3664902001/ 

idx = find(strcmp(data.INCIDENT_NAME,'CALWOOD'));
data.CAUSE_UPDATED(idx) = {'H'};
% No cause determined, strated on a day with high winds and no lighting:
% https://www.bouldercounty.org/news/investigation-into-the-cause-and-origin-of-the-calwood-fire-is-complete/

idx = find(strcmp(data.INCIDENT_ID,'2013_CO-EPX-000330_BLACK FOREST'));
data.CAUSE_UPDATED(idx) = {'H'};
% https://www.denverpost.com/2014/11/18/report-black-forest-fire-was-human-caused-but-not-necessarily-arson/

idx = find(strcmp(data.INCIDENT_ID,'2012_CO-PSF-000636_WALDO CANYON'));
data.CAUSE_UPDATED(idx) = {'H'};
% https://coloradoencyclopedia.org/article/waldo-canyon-fire#:~:text=The%20cause%20of%20the%20Waldo,controversial%20as%20it%20was%20destructive.
% https://www.denverpost.com/2012/09/12/waldo-canyon-fire-human-caused-but-intent-still-to-be-determined/

%% ARIZONA (n = 2):
idx = find(strcmp(data.INCIDENT_ID,'2011_AZ-COP-001102_MONUMENT'));
data.CAUSE_UPDATED(idx) = {'H'};
% https://tucson.com/news/local/wildfire/human-cause-cited-in-big-2011-wildfires/article_1ec9661b-d4a3-53ab-8906-d6415b2c3fcd.html
% Southern Arizona's costliest fires of 2011 were both human-caused, and both started in border areas known for drug- and human-smuggling.
% The U.S. Forest Service has been unable to affix blame or locate suspects in either fire nearly a year after investigation began on the Horseshoe 2 and Monument fires.

idx = find(strcmp(data.INCIDENT_ID,'2019_10747872_WOODBURY'));
data.CAUSE_UPDATED(idx) = {'H'};
% https://www.nps.gov/tont/learn/historyculture/woodbury-fire.htm#:~:text=On%20June%208%2C%202019%2C%20the,confront%20the%20fire%20on%20land.
% On June 8, 2019, the human-caused Woodbury Fire began in the Superstition Wilderness near the Woodbury Trailhead. This Forest Service land is full of rugged terrain with virtually no access which limited the ability of firefighters to safely confront the fire on land.

%% WYOMING: ALL YEARS (n = 1)
idx = find(strcmp(data.INCIDENT_ID,'2012_WY-BTF-000006_FONTENELLE'));
data.CAUSE_UPDATED(idx) = {'H'};
% "The fire, which was likely started by a downed power line..."
% https://earthobservatory.nasa.gov/images/78400/fontenelle-fire-in-wyoming#:~:text=The%20fire%2C%20which%20was%20likely,fire%20on%20June%2028%2C%202012.

%% MONTANA: (n = 1)
idx = find(strcmp(data.INCIDENT_ID,'2017_7269467_LODGEPOLE COMPLEX'));
data.CAUSE_UPDATED(idx) = {'L'};
% https://www.mtpr.org/montana-news/2017-07-26/major-progress-made-on-containing-lodgepole-complex-fire
% Cause: lightning

%% NEVADA: (n = 2)
idx = find(strcmp(data.INCIDENT_ID,'2018_9206799_MARTIN'));
data.CAUSE_UPDATED(idx) = {'H'};
% https://www.reviewjournal.com/local/local-nevada/2k-reward-offered-in-investigation-of-huge-nevada-wildfire/
% Fire officials have confirmed that humans caused the fire that has charred 680 square miles, or 435,569 acres, of remote rangeland.

idx = find(strcmp(data.INCIDENT_ID,'2019_10742174_CORTA'));
data.CAUSE_UPDATED(idx) = {'L'};
% https://inciweb.nwcg.gov/incident/6501/
% Cause: lightning

%% UTAH: (n = 7)
idx = find(strcmp(data.INCIDENT_ID,'2018_9203911_DOLLAR RIDGE'));
data.CAUSE_UPDATED(idx) = {'H'};
% https://www.kuer.org/public-safety/2018-07-20/investigators-find-no-witnesses-no-evidence-in-human-caused-dollar-ridge-fire
% “We're still fairly certain it was human caused — there wasn't any lightning for almost a month prior,” Curry said.

idx = find(strcmp(data.INCIDENT_ID,'2020_11713776_TABBY CANYON'));
data.CAUSE_UPDATED(idx) = {'H'};
% https://utahfireinfo.gov/2020/06/01/tabby-canyon-fire-update-5-31-2020/
% Cause: Human-caused, exploding target

idx = find(strcmp(data.INCIDENT_ID,'2019_10762549_GOOSE POINT'));
data.CAUSE_UPDATED(idx) = {'H'};
% https://wildfiretoday.com/2019/08/23/goose-point-fire-burns-over-6000-acres-southwest-of-provo-utah/#:~:text=At%2011%3A00%20a.m.%20Thursday,Forestry%2C%20Fire%20and%20State%20Lands.
% The preliminary cause is machinery that was operating in the area, according to Dave Vickers, an area fire management officer with the Utah Division of Forestry, Fire and State Lands.

idx = find(strcmp(data.INCIDENT_ID,'2019_10722575_SHELTER PASS'));
data.CAUSE_UPDATED(idx) = {'L'};
% https://wildfiretoday.com/2019/08/07/shelter-pass-fire-burns-thousands-of-acres-west-of-great-salt-lake/
% The Shelter Pass Fire, believed to have started from lightning on Sunday,

idx = find(strcmp(data.INCIDENT_ID,'2019_10799221_NECK'));
data.CAUSE_UPDATED(idx) = {'H'};
% https://utahfireinfo.gov/2019/09/08/neck-fire-update-9-8-2019/
% Start Date: September 5, 2019 Cause: Lightning

idx = find(strcmp(data.INCIDENT_ID,'2020_11728444_BIG SPRINGS'));
data.CAUSE_UPDATED(idx) = {'H'};
% https://utahfireinfo.gov/2020/06/14/big-springs-fire-in-tooele-county/
% Human cuased, under investigation

idx = find(strcmp(data.INCIDENT_ID,'2020_11724989_MANGUM'));
data.CAUSE_UPDATED(idx) = {'H'};
% https://www.stgeorgeutah.com/news/archive/2020/06/20/rmw-human-caused-mangum-fire-now-4-contained-with-64509-acres-burned/#.YiluVOjMKUk
% "“We know it’s human-caused but fire investigators are working at that and they have not given us any indication of what the cause may be,” Perry said."

%% IDAHO: (n = 1)
idx = find(strcmp(data.INCIDENT_ID,'2020_11820439_WHITETAIL LOOP'));
data.CAUSE_UPDATED(idx) = {'H'};
% https://www.krem.com/article/news/local/wildfire/fire-orofino-clearwater-county-idaho-department-of-lands/293-9ba5bb98-ee1e-43bd-afaf-badc08060794#:~:text=The%20fire%20has%20destroyed%20one%20home%20and%20several%20outbuildings.&text=OROFINO%2C%20Idaho%20%E2%80%94%20Idaho%20Department%20of,called%20the%20Whitetail%20Loop%20Fire.
% "OROFINO, Idaho — Idaho Department of Lands announced Friday that a bird striking powerlines caused a nearly 500 acre fire near Orofino."

%% CALIFORNIA FIRES (n = 46)
idx = find(strcmp(data.INCIDENT_ID,'2017_7192643_WALL')); 
data.CAUSE_UPDATED(idx) = {'H'};
% https://www.mercurynews.com/2019/04/07/cal-fire-butte-county-releases-cause-of-2017s-wall-fire/
% Cal Fire-Butte County fire investigators determined the July 2017 fire was started by a defective electrical panel at a home on Chinese Wall Road north of Bangor.

idx = find(strcmp(data.INCIDENT_ID,'2008_CA-SCU-2548_SUMMIT')); 
data.CAUSE_UPDATED(idx) = {'H'};
% https://www.mercurynews.com/2011/05/19/contractor-to-be-tried-for-2008-summit-fire-in-santa-cruz-mountains/
% https://wildfiretoday.com/2008/05/23/california-summit-fire-south-of-san-jose/

idx = find(strcmp(data.INCIDENT_ID,'2013_CA-SHU-008265_CLOVER')); 
data.CAUSE_UPDATED(idx) = {'H'};
% https://wildfiretoday.com/tag/clover-fire/
% Investigators used GPS tracking devices to gather evidence about a former firefighter who is accused of setting several wildfires in California, including the Clover Fire that killed one resident, burned 8,073 acres, and destroyed 60 homes

idx = find(strcmp(data.INCIDENT_ID,'2007_CA-BDF-10570_SLIDE')); 
data.CAUSE_UPDATED(idx) = {'L'};
% https://www.pe.com/2008/10/19/officials-still-studying-causes-of-2-san-bernardino-mountains-fires-from-2007/
% "A lightning strike ignited the Butler 1 Fire. ... caused embers to sail beyond the fire line and spawn the
% Butler 2 Fire, Dietrich said."
% “The Slide fire was related to the Butler 2,” Dietrich said.
% “Wind was in excess of 60 mph and blew embers from Butler 2 across
% the fire line. And it took off into the Green Valley Lake
% area.”

idx = find(strcmp(data.INCIDENT_ID,'2016_4246487_ERSKINE')); 
data.CAUSE_UPDATED(idx) = {'H'};
% https://bakersfieldnow.com/amp/news/local/erskine-fire-cause
% "This summer's deadly and destructive Erskine Fire was caused by an 
% electrical line in a tree, strung between two buildings. The privately 
% operated electrical line was worn down over time and created a spark in the brush, Kern County Fire Chief Brian Marshall said during a Thursday afternoon news conference.

idx = find(strcmp(data.INCIDENT_ID,'2019_10704544_KIDDER 2')); 
data.CAUSE_UPDATED(idx) = {'L'};
% https://inciweb.nwcg.gov/incident/maps/6576/
% Cause: Lightning

idx = find(strcmp(data.INCIDENT_ID,'2019_10694867_LIME')); 
data.CAUSE_UPDATED(idx) = {'L'};
% https://inciweb.nwcg.gov/incident/6591/
% Cause: Lightning

idx = find(strcmp(data.INCIDENT_ID,'2019_10742502_EASY')); 
data.CAUSE_UPDATED(idx) = {'H'};
% https://www.kclu.org/local-news/2020-10-22/investigators-determine-causes-of-two-major-ventura-county-wildfires-which-forced-thousands-to-flee
% Fire investigators say two major brush fires in Ventura County which caused thousands of evacuations were caused by the combination of extreme wind conditions, and power line problems.  Final reports have just been issued on the investigations of the sources of the 2019 “Easy” and “Maria” wildfires.

idx = find(strcmp(data.INCIDENT_ID,'2019_10757785_MARIA')); 
data.CAUSE_UPDATED(idx) = {'H'};
% https://www.kclu.org/local-news/2020-10-22/investigators-determine-causes-of-two-major-ventura-county-wildfires-which-forced-thousands-to-flee
% Fire investigators say two major brush fires in Ventura County which caused thousands of evacuations were caused by the combination of extreme wind conditions, and power line problems.  Final reports have just been issued on the investigations of the sources of the 2019 “Easy” and “Maria” wildfires.

idx = find(strcmp(data.INCIDENT_ID,'2019_10730150_TUCKER')); 
data.CAUSE_UPDATED(idx) = {'H'};
% https://kobi5.com/news/tucker-fire-reaches-over-14000-acres-107587/
% The U.S. Forest Service said the human-caused Tucker Fire started near Clear Lake Reservoir in Modoc County, California on July 28. The location is about 40 miles southeast of Klamath Falls, Oregon

idx = find(strcmp(data.INCIDENT_ID,'2019_10692026_KINCADE')); 
data.CAUSE_UPDATED(idx) = {'H'};
% https://www.courthousenews.com/pge-slapped-with-125m-penalty-for-sparking-2019-kincade-fire/#:~:text=In%20an%20emailed%20statement%2C%20PG%26E,sparked%20by%20the%20utility's%20equipment.
% In an emailed statement, PG&E spokesman James Noonan said the company accepts Cal Fire’s finding that a PG&E transmission line caused the Kincade Fire. He said the company is working to make its system safe and resolve claims stemming from past fires sparked by the utility’s equipment.

idx = find(strcmp(data.INCIDENT_ID,'2020_11740185_RED SALMON COMPLEX')); 
data.CAUSE_UPDATED(idx) = {'L'};
% https://inciweb.nwcg.gov/incident/6891/
% Attributed to lightning in InciWeb

idx = find(strcmp(data.INCIDENT_ID,'2020_11711537_SODA')); 
data.CAUSE_UPDATED(idx) = {'H'};
% https://keyt.com/news/2020/06/11/firefighters-determine-cause-of-soda-fire-in-california-valley/
% "Investigators have determined that the fire was started when a trailer, after losing a tire, was being pulled on Highway 58 near Soda Lake Road.'

idx = find(strcmp(data.INCIDENT_ID,'2020_11769137_JULY COMPLEX')); 
data.CAUSE_UPDATED(idx) = {'L'};
% https://inciweb.nwcg.gov/incident/article/6881/52815/
% Cause: Lightning.

idx = find(strcmp(data.INCIDENT_ID,'2020_11713494_OCOTILLO')); 
data.CAUSE_UPDATED(idx) = {'H'};
% https://inciweb.nwcg.gov/incident/6728/#:~:text=The%20Ocotillo%20Fire%20started%20Saturday,the%20source%20remains%20under%20investigation.
% "The fire was determined to be human caused and the source remains under
% investigation."

idx = find(strcmp(data.INCIDENT_ID,'2020_11972557_BOND')); 
data.CAUSE_UPDATED(idx) = {'H'};
% https://www.ocregister.com/2020/12/04/firefighters-work-to-get-upper-hand-on-bond-fire-in-silverado/
% Fire strated on Dec. 3rd, at a house; under criminal investigation. 

idx = find(strcmp(data.INCIDENT_ID,'2020_11886793_LOYALTON')); 
data.CAUSE_UPDATED(idx) = {'L'};
% https://inciweb.nwcg.gov/incident/6975/
% Lightning cause assigned in InciWeb.

idx = find(strcmp(data.INCIDENT_ID,'2020_11801418_SQF COMPLEX')); 
data.CAUSE_UPDATED(idx) = {'L'};
% https://inciweb.nwcg.gov/incident/7048/
% Lightning cause assigned in InciWeb.

idx = find(strcmp(data.INCIDENT_ID,'2020_11865970_NORTH COMPLEX')); 
data.CAUSE_UPDATED(idx) = {'L'};
% https://inciweb.nwcg.gov/incident/6997/
% Lightning cause assigned in InciWeb.

idx = find(strcmp(data.INCIDENT_NAME,'AUGUST COMPLEX'));
data.CAUSE_UPDATED(idx) = {'L'};
% https://www.fire.ca.gov/incidents/2020/8/16/august-complex-includes-doe-fire/

idx = find(strcmp(data.INCIDENT_ID,'2020_11874227_RIVER'));
data.CAUSE_UPDATED(idx) = {'L'};
% LIKELY HUMAN-RELATED
% https://www.fire.ca.gov/media/hsviuuv3/cal-fire-2020-fire-siege.pdf 
% The River Fire started within State Responsibility Area (SRA) in the
% CAL FIRE San Benito Monterey Unit (BEU) on August 16, 2020 at 0304 hrs,
% as a predicted lightening event entered the region. p. 44

idx = find(strcmp(data.INCIDENT_ID,'2020_11829313_JONES'));
data.CAUSE_UPDATED(idx) = {'L'};
% https://www.fire.ca.gov/media/hsviuuv3/cal-fire-2020-fire-siege.pdf
% The Jones Fire was a lightning caused fire that started on August 17th, 
% 2020, at 0253 hrs, near the confluence of Rush Creek and the South Yuba 
% River. p. 46

idx = find(strcmp(data.INCIDENT_ID,'2020_11923647_EL DORADO'));
data.CAUSE_UPDATED(idx) = {'H'};
% https://inciweb.nwcg.gov/incident/7148/ 
% Human cause assigned in InciWeb, updated 1/15/2021.

idx = find(strcmp(data.INCIDENT_ID,'2020_11968115_ZOGG'));
data.CAUSE_UPDATED(idx) = {'H'};
% https://wildfiretoday.com/2021/03/23/investigators-determine-tree-contacting-pge-power-line-started-zogg-fire/?hilite=zogg+fire 

%%%% 2020 CA FIRES, UNDETERMINED, BUT LIKELY LIGHTNING:
idx = find(strcmp(data.INCIDENT_ID,'2020_11875780_SCU LIGHTNING COMPLEX'));
data.CAUSE_UPDATED(idx) = {'L'};
% LIKELY LIGHTNING-CUASED
% https://www.fire.ca.gov/media/hsviuuv3/cal-fire-2020-fire-siege.pdf
% As the storm moved through the Unit, at least 18 fire were identified in 
% Contra Costa, Alameda, Santa Clara, Stanislaus, and San Joaquin counties. 
% The Unit enacted a Lightning Control Area Plan (LCA), identifying fires by
% Battalion, numbering each specific fire.
% The weather event that produced the fires in SCU... p. 48

idx = find(strcmp(data.INCIDENT_ID,'2020_11850821_LNU LIGHTNING COMPLEX'));
data.CAUSE_UPDATED(idx) = {'L'};
% LIKELY LIGHTNING-CUASED
% https://www.fire.ca.gov/media/hsviuuv3/cal-fire-2020-fire-siege.pdf
% The LNU Lightning Complex was a result of a two-day lightning event 
% occurring between August 16th and 17th during passage of remnants of 
% tropical storm Fausto. Over two days, the CAL FIRE Sonoma Lake Napa Unit
% (LNU) responded to over 90 reported vegetation fires several developing 
% into major fires. p. 50

idx = find(strcmp(data.INCIDENT_NAME,'CZU AUG LIGHTNING'));
data.CAUSE_UPDATED(idx) = {'L'};
% LIKELY LIGHTNING-CUASED
% https://www.fire.ca.gov/media/hsviuuv3/cal-fire-2020-fire-siege.pdf
% The CZU August Lightning Complex began on the morning of August 16th 
% during a dry lightning event that affected much of Northern California
% p. 54

idx = find(strcmp(data.INCIDENT_ID,'2020_11817132_BUTTE/TEHAMA/GLENN COMPLEX'));
data.CAUSE_UPDATED(idx) = {'L'};
% LIKELY LIGHTNING-CAUSED
% https://www.fire.ca.gov/media/hsviuuv3/cal-fire-2020-fire-siege.pdf
% The fire started from a dry lightning event during the morning and early
% afternoon hours of August 16th. p. 58

idx = find(strcmp(data.INCIDENT_ID,'2020_11908866_CREEK'));
data.CAUSE_UPDATED(idx) = {'L'};
% LIKELY LIGHTNING-CAUSED
% https://www.fs.usda.gov/detail/sierra/news-events/?cid=FSEPRD932048 

%%%% 2020 CA FIRES, UNDETERMINED, BUT LIKELY HUMAN-RELATED:
idx = find(strcmp(data.INCIDENT_ID,'2020_11825368_DOLAN'));
data.CAUSE_UPDATED(idx) = {'H'};
% LIKELY HUMAN-RELATED IGNITION
% https://www.thecalifornian.com/story/news/2020/08/19/california-deputies-arrest-arson-suspect-dolan-fire-big-sur/5609484002/

idx = find(strcmp(data.INCIDENT_ID,'2020_11917302_SNOW'));
data.CAUSE_UPDATED(idx) = {'H'};
% LIKELY HUMAN-RELATED IGNITION
% https://www.fire.ca.gov/media/hsviuuv3/cal-fire-2020-fire-siege.pdf
% On September 17th at 1837 hrs a vehicle fire was reported at Snow
% Creek and Hwy 111. The vehicle fire quickly spread into the grass
% consuming ten acres upon arrival of the first resources with a dangerous
% rate of spread.

idx = find(strcmp(data.INCIDENT_ID,'2017_7293180_CENTRAL LNU COMPLEX'));
data.CAUSE_UPDATED(idx) = {'H'};
% Tubbs and Nunns fire cuase established a H, by CalFire
% Tubbs: https://www.fire.ca.gov/media/5124/tubbscause1v.pdf
% Nuns, Pocket: https://www.fire.ca.gov/media/5100/2017_wildfiresiege_cause.pdf
% Central LNU Complex = 110720 ac: includes Tubbs, Nuns, Pocket fires, all 
% determined to be from human-related ignitions, via the CalFire sources above.

idx = find(strcmp(data.INCIDENT_ID,'2017_7200218_SOUTHERN LNU COMPLEX'));
data.CAUSE_UPDATED(idx) = {'H'};
% Atlas Fire = Southern LNU Complex fires, via CalFire: https://www.fire.ca.gov/incidents/2017/10/8/atlas-fire-southern-lnu-complex/
% Cause of Atals Fire = human-related, per CalFire report: https://www.fire.ca.gov/media/5100/2017_wildfiresiege_cause.pdf

idx = find(strcmp(data.INCIDENT_ID,'2017_7292820_CHEROKEE'));
data.CAUSE_UPDATED(idx) = {'H'};
% Cause of Cherokee Fire = human-related, per CalFire report: https://www.fire.ca.gov/media/5100/2017_wildfiresiege_cause.pdf

idx = find(strcmp(data.INCIDENT_ID,'2017_7220123_MENDOCINO LAKE COMPLEX'));
data.CAUSE_UPDATED(idx) = {'H'};
% Mendocino Lake Complex = Redwood Valley Fire, per CalFire: https://www.fire.ca.gov/incidents/2017/10/8/redwood-valley-fire-mendocino-lake-complex/
% Redwood Valley Fire cuase determined to be human-related: https://mendovoice.com/2018/06/redwood-fire-cause-release/

idx = find(strcmp(data.INCIDENT_ID,'2017_7211316_NEU WIND COMPLEX'));
data.CAUSE_UPDATED(idx) = {'H'};
% NEU Wind Complex: https://www.fire.ca.gov/incidents/2017/10/8/cascade-fire-wind-complex/ 
% Cascade Fire caused by sagging power lines: https://sacramento.cbslocal.com/2018/10/09/cascade-fire-cause-yuba-county/

idx = find(strcmp(data.INCIDENT_NAME,'WOOLSEY'));
data.CAUSE_UPDATED(idx) = {'H'};
% LIKELY HUMAN-RELATED
% https://www.vcstar.com/story/news/local/communities/simi-valley/2020/10/29/redacted-2018-woolsey-fire-report-authorities-blame-edison-equipment/6057616002/

idx = find(strcmp(data.INCIDENT_ID,'2013_CA-STF-002857_RIM'));
data.CAUSE_UPDATED(idx) = {'H'};
% https://www.fire.ca.gov/media/hsviuuv3/cal-fire-2020-fire-siege.pdf

idx = find(strcmp(data.INCIDENT_ID,'2016_4277928_CEDAR'));
data.CAUSE_UPDATED(idx) = {'H'};
% https://www.fire.ca.gov/media/hsviuuv3/cal-fire-2020-fire-siege.pdf p. 67

idx = find(strcmp(data.INCIDENT_ID,'2015_2915082_VALLEY'));
data.CAUSE_UPDATED(idx) = {'H'};
% https://www.fire.ca.gov/incidents/2015/9/12/valley-fire/

idx = find(strcmp(data.INCIDENT_ID,'2017_9258165_THOMAS'));
data.CAUSE_UPDATED(idx) = {'H'};
% https://www.fire.ca.gov/incidents/2017/12/4/thomas-fire/

idx = find(strcmp(data.INCIDENT_ID,'2015_2910134_BUTTE'));
data.CAUSE_UPDATED(idx) = {'H'};
% https://wildfiretoday.com/tag/butte-fire/#:~:text=An%20investigation%20of%20last%20September's,the%20line%2C%20causing%20the%20blaze.

%%%% CA FIRES, UNDETERMINED, BUT POSSIBLY/LIKELY HUMAN-RELATED SOME CHANGE,
%%%% SOME NOT

idx = find(strcmp(data.INCIDENT_ID,'2020_11963496_GLASS'));
data.CAUSE_UPDATED(idx) = {'H'};
% Glass Fire: 
% https://www.pressdemocrat.com/article/news/cal-fire-says-it-does-not-have-enough-evidence-to-determine-cause-of-glass/
% https://napavalleyregister.com/news/local/cal-fire-cannot-determine-cause-of-glass-fire/article_76a21d6d-05e0-55f1-8d07-11c7cc8a3b50.html
% Investigation focused on human-related causes; never mentioned lightning
% as a possibility.

idx = find(strcmp(data.INCIDENT_ID,'2020_11951011_BOBCAT'));
data.CAUSE_UPDATED(idx) = {'H'};
% Bobcat Fire: 
% https://www.nbclosangeles.com/news/local/bobcat-fire-cause-angeles-national-forest-wildfire/2442975/
% "The 115,796-acre Bobcat Fire may have been caused by vegetation coming
% into contact with a Southern California Edison overhead conductor, the company said Monday in a letter to the California Public Utilities Commission."

idx = find(strcmp(data.INCIDENT_ID,'2019_10754067_SADDLERIDGE'));
data.CAUSE_UPDATED(idx) = {'H'};
% Saddle Ridge Fire (2019): Likely human-related
% https://abcnews.go.com/US/saddleridge-fire-began-base-transmission-tower-northern-los/story?id=66282782
% No mention of lightning as possible casue; investigation focusing on
% human-related cause

idx = find(strcmp(data.INCIDENT_ID,'2020_11974190_SILVERADO'));
data.CAUSE_UPDATED(idx) = {'H'};
% Silverado Fire (Oct. 26, 2020): 
% https://www.nbcnews.com/news/us-news/cause-southern-california-fire-forced-thousand-evacuate-may-be-lashing-n1244973
% "However, it appears that a lashing wire that was attached to an underbuilt telecommunication line ... may have resulted in the ignition of the fire,” the letter said.

% Valley Fire (Sep. 15, 2015):
% https://www.sandiegouniontribune.com/news/public-safety/story/2020-09-06/valley-fire-has-charred-4-000-acres-destroyed-10-structures 
% The cause of the Valley fire remains under investigation, although several residents said the blaze may have been ignited by a tractor fire on Saturday afternoon on Carveacre Lane.

%% WASHINGTON FIRES (n = 58)
idx = find(strcmp(data.INCIDENT_ID,'2019_10734804_COLD CREEK'));
data.CAUSE_UPDATED(idx) = {'H'};
% https://wildfiretoday.com/2019/07/20/cold-creek-fire-burns-over-40000-acres-in-washington/
% A human-caused wildfire in south/central Washington has burned 41,920 acres 31 miles east of Yakima (see the map below). 

idx = find(strcmp(data.INCIDENT_ID,'2020_11954509_SUMNER GRADE'));
data.CAUSE_UPDATED(idx) = {'H'};
%  https://www.king5.com/article/news/local/wildfire/gov-inslee-calls-sumner-grade-fire-among-most-catastrophic-in-washington-history/281-132ec1ec-6ee9-4503-bf9e-86cfc3df57c6#:~:text=Investigators%20said%20the%20fire%20has,Tuesday%2C%20forcing%20Level%203%20evacuations.
% "They believe the fire started late Monday after a power transmitter exploded during strong winds. "
% Labor Day wind storm, western WA. 

idx = find(strcmp(data.INCIDENT_ID,'2020_11922031_INCHELIUM COMPLEX'));
data.CAUSE_UPDATED(idx) = {'H'};
% https://inciweb.nwcg.gov/incident/7177/
% "Trained Fire Investigators Have Determined The Inchelium Complex To Be
% Started By Human Activity"

idx = find(strcmp(data.INCIDENT_ID,'2020_11904791_BABB'));
data.CAUSE_UPDATED(idx) = {'H'};
% https://www.krem.com/article/news/local/wildfire/dnr-babb-fire-sparked-by-tree-branch-that-fell-on-avista-powerline/293-212992e2-6e5e-42ae-9113-e20cb46da412

idx = find(strcmp(data.INCIDENT_ID,'2015_2810753_FISH LAKE'));
data.CAUSE_UPDATED(idx) = {'H'};
% https://gacc.nifc.gov/nwcc/content/pdfs/archives/2015_NWCC_Annual_Fire_Report.pdf
% See Table 1, p. 9: "H" attributed to this fire.

idx = find(strcmp(data.INCIDENT_ID,'2015_2862669_RUTTER CANYON'));
data.CAUSE_UPDATED(idx) = {'H'};
% https://gacc.nifc.gov/nwcc/content/pdfs/archives/2015_NWCC_Annual_Fire_Report.pdf
% See Table 1, p. 9: "H" attributed to this fire.

idx = find(strcmp(data.INCIDENT_ID,'2015_2720095_EGYPT LOOP 2'));
data.CAUSE_UPDATED(idx) = {'H'};
% https://gacc.nifc.gov/nwcc/content/pdfs/archives/2015_NWCC_Annual_Fire_Report.pdf
% See Table 1, p. 9: "H" attributed to this fire.

idx = find(strcmp(data.INCIDENT_ID,'2015_2826243_AYERS GULCH'));
data.CAUSE_UPDATED(idx) = {'H'};
% https://gacc.nifc.gov/nwcc/content/pdfs/archives/2015_NWCC_Annual_Fire_Report.pdf
% See Table 1, p. 9: "H" attributed to this fire.

idx = find(strcmp(data.INCIDENT_ID,'2015_2760307_LONG LAKE'));
data.CAUSE_UPDATED(idx) = {'H'};
% https://gacc.nifc.gov/nwcc/content/pdfs/archives/2015_NWCC_Annual_Fire_Report.pdf
% See Table 1, p. 9: "H" attributed to this fire.

idx = find(strcmp(data.INCIDENT_ID,'2015_2761314_MEALS ROAD'));
data.CAUSE_UPDATED(idx) = {'H'};
% https://gacc.nifc.gov/nwcc/content/pdfs/archives/2015_NWCC_Annual_Fire_Report.pdf
% See Table 1, p. 9: "H" attributed to this fire.

idx = find(strcmp(data.INCIDENT_ID,'2015_2823879_HATCH GRADE'));
data.CAUSE_UPDATED(idx) = {'H'};
% https://gacc.nifc.gov/nwcc/content/pdfs/archives/2015_NWCC_Annual_Fire_Report.pdf
% See Table 1, p. 9: "H" attributed to this fire.

idx = find(strcmp(data.INCIDENT_ID,'2015_2914686_MEEKS TABLE'));
data.CAUSE_UPDATED(idx) = {'H'};
% https://gacc.nifc.gov/nwcc/content/pdfs/archives/2015_NWCC_Annual_Fire_Report.pdf
% See Table 1, p. 9: "H" attributed to this fire.

idx = find(strcmp(data.INCIDENT_ID,'2015_2769715_I-90'));
data.CAUSE_UPDATED(idx) = {'H'};
% https://gacc.nifc.gov/nwcc/content/pdfs/archives/2015_NWCC_Annual_Fire_Report.pdf
% See Table 1, p. 9: "H" attributed to this fire.

idx = find(strcmp(data.INCIDENT_ID,'2015_2723470_BEEZLEY HILL'));
data.CAUSE_UPDATED(idx) = {'H'};
% https://gacc.nifc.gov/nwcc/content/pdfs/archives/2015_NWCC_Annual_Fire_Report.pdf
% See Table 1, p. 8: "H" attributed to this fire.

idx = find(strcmp(data.INCIDENT_ID,'2015_2723001_MONUMENT'));
data.CAUSE_UPDATED(idx) = {'H'};
% https://gacc.nifc.gov/nwcc/content/pdfs/archives/2015_NWCC_Annual_Fire_Report.pdf
% See Table 1, p. 8: "H" attributed to this fire.

idx = find(strcmp(data.INCIDENT_ID,'2015_2850684_JUNCTION FIRE'));
data.CAUSE_UPDATED(idx) = {'H'};
% https://gacc.nifc.gov/nwcc/content/pdfs/archives/2015_NWCC_Annual_Fire_Report.pdf
% See Table 1, p. 8: "H" attributed to this fire.

idx = find(strcmp(data.INCIDENT_ID,'2015_2835658_SE BENTON COMPLEX'));
data.CAUSE_UPDATED(idx) = {'H'};
% https://gacc.nifc.gov/nwcc/content/pdfs/archives/2015_NWCC_Annual_Fire_Report.pdf
% See Table 1, p. 8: "H" attributed to this fire.

idx = find(strcmp(data.INCIDENT_ID,'2015_2814691_SLEEPY HOLLOW'));
data.CAUSE_UPDATED(idx) = {'H'};
% https://gacc.nifc.gov/nwcc/content/pdfs/archives/2015_NWCC_Annual_Fire_Report.pdf
% See Table 1, p. 8: "H" attributed to this fire.

idx = find(strcmp(data.INCIDENT_ID,'2015_2884366_9 MILE'));
data.CAUSE_UPDATED(idx) = {'H'};
% https://gacc.nifc.gov/nwcc/content/pdfs/archives/2015_NWCC_Annual_Fire_Report.pdf
% See Table 1, p. 8: "H" attributed to this fire.

idx = find(strcmp(data.INCIDENT_ID,'2015_2837946_BLUE CREEK'));
data.CAUSE_UPDATED(idx) = {'H'};
% https://gacc.nifc.gov/nwcc/content/pdfs/archives/2015_NWCC_Annual_Fire_Report.pdf
% See Table 1, p. 8: "H" attributed to this fire.

idx = find(strcmp(data.INCIDENT_ID,'2015_2908645_HORSETHIEF BUTTE'));
data.CAUSE_UPDATED(idx) = {'H'};
% https://gacc.nifc.gov/nwcc/content/pdfs/archives/2015_NWCC_Annual_Fire_Report.pdf
% See Table 1, p. 8: "H" attributed to this fire.

idx = find(strcmp(data.INCIDENT_ID,'2015_2886109_HWY 8'));
data.CAUSE_UPDATED(idx) = {'H'};
% https://gacc.nifc.gov/nwcc/content/pdfs/archives/2015_NWCC_Annual_Fire_Report.pdf
% See Table 1, p. 8: "H" attributed to this fire.

idx = find(strcmp(data.INCIDENT_ID,'2020_11894715_BADGER LAKE'));
data.CAUSE_UPDATED(idx) = {'H'};
% https://gacc.nifc.gov/nwcc/content/pdfs/archives/2020_NWCC_Annual_Fire_Report.pdf
% See Table 2, p. 29: "H" attributed to this fire.

idx = find(strcmp(data.INCIDENT_ID,'2020_11748242_BERTSCHI ROAD'));
data.CAUSE_UPDATED(idx) = {'H'};
% https://gacc.nifc.gov/nwcc/content/pdfs/archives/2020_NWCC_Annual_Fire_Report.pdf
% See Table 2, p. 29: "H" attributed to this fire.

idx = find(strcmp(data.INCIDENT_ID,'2020_11753967_POTHOLE'));
data.CAUSE_UPDATED(idx) = {'H'};
% https://gacc.nifc.gov/nwcc/content/pdfs/archives/2020_NWCC_Annual_Fire_Report.pdf
% See Table 2, p. 29: "H" attributed to this fire.

idx = find(strcmp(data.INCIDENT_ID,'2020_11760953_BIG HORN'));
data.CAUSE_UPDATED(idx) = {'H'};
% https://gacc.nifc.gov/nwcc/content/pdfs/archives/2020_NWCC_Annual_Fire_Report.pdf
% See Table 2, p. 29: "H" attributed to this fire.

idx = find(strcmp(data.INCIDENT_ID,'2020_11916904_COLD CREEK'));
data.CAUSE_UPDATED(idx) = {'H'};
% https://gacc.nifc.gov/nwcc/content/pdfs/archives/2020_NWCC_Annual_Fire_Report.pdf
% See Table 2, p. 29: "H" attributed to this fire.

idx = find(strcmp(data.INCIDENT_ID,'2020_11865777_JUNGLE CREEK'));
data.CAUSE_UPDATED(idx) = {'L'};
% https://gacc.nifc.gov/nwcc/content/pdfs/archives/2020_NWCC_Annual_Fire_Report.pdf
% See Table 2, p. 29: "L" attributed to this fire.

idx = find(strcmp(data.INCIDENT_ID,'2020_11836658_MOSIER CREEK'));
data.CAUSE_UPDATED(idx) = {'H'};
% https://gacc.nifc.gov/nwcc/content/pdfs/archives/2020_NWCC_Annual_Fire_Report.pdf
% See Table 2, p. 29: "H" attributed to this fire.

idx = find(strcmp(data.INCIDENT_ID,'2020_11719017_GIBBON'));
data.CAUSE_UPDATED(idx) = {'H'};
% https://gacc.nifc.gov/nwcc/content/pdfs/archives/2020_NWCC_Annual_Fire_Report.pdf
% See Table 2, p. 29: "H" attributed to this fire.

idx = find(strcmp(data.INCIDENT_ID,'2020_11905860_BEVERLY BURKE'));
data.CAUSE_UPDATED(idx) = {'H'};
% https://gacc.nifc.gov/nwcc/content/pdfs/archives/2020_NWCC_Annual_Fire_Report.pdf
% See Table 2, p. 29: "H" attributed to this fire.

idx = find(strcmp(data.INCIDENT_ID,'2020_11797133_KONNOWAC'));
data.CAUSE_UPDATED(idx) = {'H'};
% https://gacc.nifc.gov/nwcc/content/pdfs/archives/2020_NWCC_Annual_Fire_Report.pdf
% See Table 2, p. 29: "H" attributed to this fire.

idx = find(strcmp(data.INCIDENT_ID,'2020_11763377_ANGLIN'));
data.CAUSE_UPDATED(idx) = {'H'};
% https://gacc.nifc.gov/nwcc/content/pdfs/archives/2020_NWCC_Annual_Fire_Report.pdf
% See Table 2, p. 29: "H" attributed to this fire.

idx = find(strcmp(data.INCIDENT_ID,'2020_11745720_CHIKAMIN'));
data.CAUSE_UPDATED(idx) = {'L'};
% https://gacc.nifc.gov/nwcc/content/pdfs/archives/2020_NWCC_Annual_Fire_Report.pdf
% See Table 2, p. 29: "L" attributed to this fire.

idx = find(strcmp(data.INCIDENT_ID,'2020_11916675_CUSTOMS ROAD'));
data.CAUSE_UPDATED(idx) = {'H'};
% https://gacc.nifc.gov/nwcc/content/pdfs/archives/2020_NWCC_Annual_Fire_Report.pdf
% See Table 2, p. 29: "H" attributed to this fire.

idx = find(strcmp(data.INCIDENT_ID,'2020_11752265_COLOCKUM'));
data.CAUSE_UPDATED(idx) = {'H'};
% https://gacc.nifc.gov/nwcc/content/pdfs/archives/2020_NWCC_Annual_Fire_Report.pdf
% See Table 2, p. 29: "H" attributed to this fire.

idx = find(strcmp(data.INCIDENT_ID,'2020_11752086_SADDLE MOUNTAIN'));
data.CAUSE_UPDATED(idx) = {'H'};
% https://gacc.nifc.gov/nwcc/content/pdfs/archives/2020_NWCC_Annual_Fire_Report.pdf
% See Table 2, p. 29: "H" attributed to this fire.

idx = find(strcmp(data.INCIDENT_ID,'2020_11956986_KAHLOTUS'));
data.CAUSE_UPDATED(idx) = {'H'};
% https://gacc.nifc.gov/nwcc/content/pdfs/archives/2020_NWCC_Annual_Fire_Report.pdf
% See Table 2, p. 29: "H" attributed to this fire.

idx = find(strcmp(data.INCIDENT_ID,'2017_7388086_EAST CRATER'));
data.CAUSE_UPDATED(idx) = {'H'};
% https://gacc.nifc.gov/nwcc/content/pdfs/archives/2017_NWCC_Annual_Fire_Report_FINAL.pdf
% See Table 1, p. 16: "H" attributed to this fire.

idx = find(strcmp(data.INCIDENT_ID,'2017_7323775_MONITOR'));
data.CAUSE_UPDATED(idx) = {'H'};
% https://gacc.nifc.gov/nwcc/content/pdfs/archives/2017_NWCC_Annual_Fire_Report_FINAL.pdf
% See Table 1, p. 16: "H" attributed to this fire.

idx = find(strcmp(data.INCIDENT_ID,'2018_9257924_SHANNON RIDGE'));
data.CAUSE_UPDATED(idx) = {'L'};
% https://gacc.nifc.gov/nwcc/content/pdfs/archives/2018_NWCC_Annual_Fire_Report_FINAL.pdf
% See Table 3, p. 26: "L" attributed to this fire. 

idx = find(strcmp(data.INCIDENT_ID,'2018_9174544_SONNY BOY CREEK'));
data.CAUSE_UPDATED(idx) = {'L'};
% https://gacc.nifc.gov/nwcc/content/pdfs/archives/2018_NWCC_Annual_Fire_Report_FINAL.pdf
% See Table 3, p. 26: "L" attributed to this fire. 

idx = find(strcmp(data.INCIDENT_ID,'2018_9138457_FERN CREEK'));
data.CAUSE_UPDATED(idx) = {'L'};
% https://gacc.nifc.gov/nwcc/content/pdfs/archives/2018_NWCC_Annual_Fire_Report_FINAL.pdf
% See Table 3, p. 26: "L" attributed to this fire. 

idx = find(strcmp(data.INCIDENT_ID,'2018_9069382_DISHPAN GAP'));
data.CAUSE_UPDATED(idx) = {'L'};
% https://gacc.nifc.gov/nwcc/content/pdfs/archives/2018_NWCC_Annual_Fire_Report_FINAL.pdf
% See Table 3, p. 26: "L" attributed to this fire. 

idx = find(strcmp(data.INCIDENT_ID,'2018_9263362_IRON WEST'));
data.CAUSE_UPDATED(idx) = {'L'};
% https://gacc.nifc.gov/nwcc/content/pdfs/archives/2018_NWCC_Annual_Fire_Report_FINAL.pdf
% See Table 3, p. 26: "L" attributed to this fire. 

idx = find(strcmp(data.INCIDENT_ID,'2018_9065417_TILLMAN SURPRISE'));
data.CAUSE_UPDATED(idx) = {'L'};
% https://gacc.nifc.gov/nwcc/content/pdfs/archives/2018_NWCC_Annual_Fire_Report_FINAL.pdf
% See Table 3, p. 26: "L" attributed to this fire. 

idx = find(strcmp(data.INCIDENT_ID,'2018_9112004_KETTLE RIVER'));
data.CAUSE_UPDATED(idx) = {'L'};
% https://gacc.nifc.gov/nwcc/content/pdfs/archives/2018_NWCC_Annual_Fire_Report_FINAL.pdf
% See Table 3, p. 26: "L" attributed to this fire. 

idx = find(strcmp(data.INCIDENT_ID,'2018_9023999_BUFFALO'));
data.CAUSE_UPDATED(idx) = {'H'};
% https://gacc.nifc.gov/nwcc/content/pdfs/archives/2018_NWCC_Annual_Fire_Report_FINAL.pdf
% See Table 3, p. 25: "H" attributed to this fire.

idx = find(strcmp(data.INCIDENT_ID,'2018_9252928_JOHN BELMONT'));
data.CAUSE_UPDATED(idx) = {'H'};
% https://gacc.nifc.gov/nwcc/content/pdfs/archives/2018_NWCC_Annual_Fire_Report_FINAL.pdf
% See Table 3, p. 25: "H" attributed to this fire.

idx = find(strcmp(data.INCIDENT_ID,'2018_9229217_LAMBDON ROAD'));
data.CAUSE_UPDATED(idx) = {'H'};
% https://gacc.nifc.gov/nwcc/content/pdfs/archives/2018_NWCC_Annual_Fire_Report_FINAL.pdf
% See Table 3, p. 26: "H" attributed to this fire. 

idx = find(strcmp(data.INCIDENT_ID,'2018_9199169_LIME HILL 2'));
data.CAUSE_UPDATED(idx) = {'H'};
% https://gacc.nifc.gov/nwcc/content/pdfs/archives/2018_NWCC_Annual_Fire_Report_FINAL.pdf
% See Table 3, p. 24: "H" attributed to this fire. 

idx = find(strcmp(data.INCIDENT_ID,'2018_9112718_BUCKSHOT'));
data.CAUSE_UPDATED(idx) = {'H'};
% https://gacc.nifc.gov/nwcc/content/pdfs/archives/2018_NWCC_Annual_Fire_Report_FINAL.pdf
% See Table 3, p. 25: "H" attributed to this fire. 

idx = find(strcmp(data.INCIDENT_ID,'2018_9270364_EASTERDAY'));
data.CAUSE_UPDATED(idx) = {'L'};
% https://gacc.nifc.gov/nwcc/content/pdfs/archives/2018_NWCC_Annual_Fire_Report_FINAL.pdf
% See Table 3, p. 25: "L" attributed to this fire. 

idx = find(strcmp(data.INCIDENT_ID,'2018_9253204_BUFFALO'));
data.CAUSE_UPDATED(idx) = {'H'};
% https://gacc.nifc.gov/nwcc/content/pdfs/archives/2018_NWCC_Annual_Fire_Report_FINAL.pdf
% See Table 3, p. 25: "H" attributed to this fire. 

idx = find(strcmp(data.INCIDENT_ID,'2018_9170855_MILEPOST TWENTY TWO'));
data.CAUSE_UPDATED(idx) = {'H'};
% https://gacc.nifc.gov/nwcc/content/pdfs/archives/2018_NWCC_Annual_Fire_Report_FINAL.pdf
% See Table 3, p. 25: "H" attributed to this fire. 

idx = find(strcmp(data.INCIDENT_ID,'2018_9105584_BOYLSTON'));
data.CAUSE_UPDATED(idx) = {'H'};
% https://gacc.nifc.gov/nwcc/content/pdfs/archives/2018_NWCC_Annual_Fire_Report_FINAL.pdf
% See Table 3, p. 25: "H" attributed to this fire. 

idx = find(strcmp(data.INCIDENT_ID,'2020_11903764_WHITNEY'));
data.CAUSE_UPDATED(idx) = {'H'};
% https://inciweb.nwcg.gov/incident/7183/ *Attributed to a powerline

idx = find(strcmp(data.INCIDENT_ID,'2017_7216628_DIAMOND CREEK'));
data.CAUSE_UPDATED(idx) = {'H'};
% https://www.fs.usda.gov/Internet/FSE_DOCUMENTS/fseprd572804.pdf
% The Diamond Creek Fire was reported on July 23, later determined to be caused by an
% unattended campfire. p. 19

%%%% Updated through ICS209 -- FOD process above, so no longer need to manually update:
% idx = find(strcmp(data.INCIDENT_ID,'2018_9220077_CAMP')); % Since there
%     % are multimple fires named "CAMP" this is using full incident ID. 
% data.CAUSE_UPDATED(idx) = {'H'};
% 
% idx = find(strcmp(data.INCIDENT_ID,'2018_9236519_CARR')); % Since there
%     % are multimple fires named "CARR" this is using full incident ID. 
% data.CAUSE_UPDATED(idx) = {'H'};


%% 4. Save updated dataset as .csv and .mat files
%%%% LAST SAVED: 13 MARCH 2022
% 
% writetable(data,'ics209plus_wf_incidents_west_1999to2020_qc_PEH.xlsx')
% save('ics209plus_wf_incidents_west_1999to2020_qc_PEH.mat','data')

