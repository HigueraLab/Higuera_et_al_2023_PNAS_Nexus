% extractClimateData.m
%
% Requires running ICS209_PLUS_1_LoadDataset.m first
%
% P. Higuera
% Feb. 2022
%
% Annotated Jan. 2023: Creates climate datasets used in final analysis, but
% does not save this automatically. This extracts cliamte data from the
% referenced .csv files; these were then saved as .mat files (provided in
% the "data" directory). 
%
%% Load REGION data
cd C:\Users\philip.higuera.UM\Box\2_lab_SHARE\4_archivedData\Higuera_et_al_2023_PNAS_Nexus\data\gridmet

% vpd_data = importdata('gridmet_west_west_may_sept_avg_vpd.csv');
% fm1000_data = importdata('gridmet_west_west_may_sept_avg_fm1000.csv');
% fm1000min_data = importdata('gridmet_west_west_may_sept_min_fm1000.csv');
% regionIdx = 1;

vpd_data = importdata('gridmet_west_states_may_sept_avg_vpd_.csv');
fm1000_data = importdata('gridmet_west_states_may_sept_avg_fm1000_.csv');
fm1000min_data = importdata('gridmet_west_states_may_sept_min_fm1000_.csv');
regionIdx = 3;

% vpd_data = importdata('gridmet_natl_gaccs_may_sept_avg_vpd_.csv');
% fm1000_data = importdata('gridmet_natl_gaccs_may_sept_avg_fm1000_.csv');
% fm1000min_data = importdata('gridmet_natl_gaccs_may_sept_min_fm1000_.csv');
% regionIdx = 4;


% vpd_data = importdata('gridmet_west_ecol2_may_sept_avg_vpd_.csv');
% fm1000_data = importdata('gridmet_west_ecol2_may_sept_avg_fm1000_.csv');
% fm1000min_data = importdata('gridmet_west_ecol2_may_sept_min_fm1000_.csv');
% regionIdx = 2;


%% Setup parameters
if regionIdx > 1
    regionID = unique(vpd_data.textdata(2:end,regionIdx));
    nRegions = length(regionID);
    offset = length(vpd_data.textdata) - length(vpd_data.data); % Offset between
    % number of columns in text data vs. data, to extract correct months. 
else
    offset = 0;
    nRegions = 1;
end
yr = 1998:2020;
nYrs = length(yr);

%% Extract data for each region and year
vpd = NaN(nYrs,nRegions);
fm1000 = NaN(nYrs,nRegions);
min_fm1000 = NaN(nYrs,nRegions);

for j = 1:nRegions
    if regionIdx > 1
        idx1 = find(strcmp(vpd_data.textdata(2:end,regionIdx),regionID(j)));
    else
        idx1 = 1; % For all West, row 1.
    end
    for i = 1:nYrs
        idx2 = find(contains(vpd_data.textdata(1,:),num2str(yr(i))))-offset;
        % Minus 3, b/c numerica data does have 3 fewer columns.
        
        vpd(i,j) = mean(vpd_data.data(idx1,idx2(2:4)));
        fm1000(i,j) = mean(fm1000_data.data(idx1,idx2(2:4)));
        min_fm1000(i,j) = mean(fm1000min_data.data(idx1,idx2(2:4)));
    end
end

%% Plot data
subplot(311)
plot(yr,vpd)
legend(regionID,'Location','Best')
ylabel('VPD')
axis square

subplot(312)
plot(yr,fm1000)
legend(regionID,'Location','Best')
ylabel('FM1000')
axis square

subplot(313)
plot(yr,min_fm1000)
legend(regionID,'Location','Best')
ylabel('Min. FM1000')
axis square