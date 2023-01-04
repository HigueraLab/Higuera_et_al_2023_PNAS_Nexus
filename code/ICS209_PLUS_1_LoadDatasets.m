% ICS209_PLUS_1_LoadDatasets.m
% 
% Load datasets used in following analyses, run with additional scripts. 
%
% P. Higuera
% Feb. 2022
%
clear all
close all

%% Set up input parameters for ISC209_FireActivity.m function
spatialDomain = {'STUSPS'}; % n = 11
% spatialDomain = {'GACCAbbrev'}; % n = 7
% spatialDomain = {'NA_L3NAME'}; % n = 35
% spatialDomain = {'NA_L2NAME'}; % n = 9
saveFile = 0; 

%% Load datasets
data = open('C:\Users\philip.higuera.UM\Box\2_lab_SHARE\4_archivedData\Higuera_et_al_2023_PNAS_Nexus\data\wf-incidents\ics209plus_wf_incidents_west_1999to2020_qc_PEH.mat');
data = data.data;
data.CAUSE = data.CAUSE_UPDATED;

% Structure loss doy, derrived from the main dataset
load C:\Users\philip.higuera.UM\Box\2_lab_SHARE\4_archivedData\Higuera_et_al_2023_PNAS_Nexus\data\wf-incidents\strucLossDOY
    % i = each structure lost; j = doy  of struct loss, 1 = H cause; 0 = L;
    % year.
    
%% Define regions, based on input variable regions, and load supporting 
    % datasets: region size, burnable area, and VPD.  
if strcmp(spatialDomain,'STUSPS')
    regionID = unique(data.STUSPS);
    REGION = data.STUSPS;  
    regionArea = readtable('C:\Users\philip.higuera.UM\Box\2_lab_SHARE\4_archivedData\Higuera_et_al_2023_PNAS_Nexus\data\burnable_area\burnable_area_states.csv');
    [~, in] = sort(regionArea.STUSPS);
    burnableArea = regionArea.Burnable_Km2(in); % [km2] burnable area
    burnableArea(end+1) = sum(burnableArea); % [km2]
    load('C:\Users\philip.higuera.UM\Box\2_lab_SHARE\4_archivedData\Higuera_et_al_2023_PNAS_Nexus\data\gridmet\vpd_JJA_WestStates.mat')
    vpdRegion = vpd;
    strucLossDOY.regionID = strucLossDOY.STUSPS;
end
if strcmp(spatialDomain,'GACCAbbrev')
    regionID = unique(data.GACCAbbrev);
    REGION = data.GACCAbbrev;
    load('C:\Users\philip.higuera.UM\Box\2_lab_SHARE\4_archivedData\Higuera_et_al_2023_PNAS_Nexus\data\gridmet\vpd_JJA_WestGACC.mat')
    vpdRegion = vpd;
    strucLossDOY.regionID = strucLossDOY.GACCAbbrev;
end
if strcmp(spatialDomain,'NA_L2NAME')
    regionID = unique(data.NA_L2NAME);
    regionID(strcmp(regionID,'NaN')) = [];
    REGION = data.NA_L2NAME;
    load('C:\Users\philip.higuera.UM\Box\2_lab_SHARE\4_archivedData\Higuera_et_al_2023_PNAS_Nexus\data\gridmet\vpd_JJA_WestEcoL2.mat')
    vpdRegion = vpd;
    strucLossDOY.regionID = strucLossDOY.NA_L2NAME;
end
if strcmp(spatialDomain,'NA_L3NAME')
    regionID = unique(data.NA_L3NAME);
    REGION = data.NA_L3NAME;
    strucLossDOY.regionID = strucLossDOY.NA_L3NAME;
end

load('C:\Users\philip.higuera.UM\Box\2_lab_SHARE\4_archivedData\Higuera_et_al_2023_PNAS_Nexus\data\gridmet\vpd_JJA_WEST.mat')
WestWideVPD = vpd; % [kpa] May-Sep. VPD, 1998-2020.

regionID(end+1) = {'WEST'};
nRegions = length(regionID);

%% Derive variables
yr = [min(data.START_YEAR):max(data.START_YEAR)]; % [yr CE]
nYrs = length(yr); 

fireCause = {'O','U','H','L'}; %unique(data.CAUSE);
fireCauseText = {'Other','Undetermined','Human','Lightning'};
nCauses = length(fireCause);

%% Create time series of each metric
%%%% FIRE ACTIVITY
areaBurned = NaN(nYrs,nCauses,nRegions); % [ha] annual area burned:
    % i = yr, j = cuase, k = region.
nFires = NaN(nYrs,nCauses,nRegions); % [#] annual number of fires:
    % i = yr, j = cuase, k = region.
discDOY = NaN(nYrs,nRegions); % [DOY] discover day of year: 
    % i = yr, j = region.
maxFireGrowth = NaN(nYrs,nRegions); % [DOY] day of max. growth:
    % i = yr, j = region.
    
%%%% FIRE IMPACTS
strucLoss = NaN(nYrs,nCauses,nRegions); % [#] annual structure loss:
    % i = yr, j = cuase, k = region.
fatalities = NaN(nYrs,nCauses,nRegions); % [#] annual # fatalities:
    % i = yr, j = cuase, k = region.
injuries = NaN(nYrs,nCauses,nRegions); % [#] annual # injuries:
    % i = yr, j = cuase, k = region.
IMCosts = NaN(nYrs,nCauses,nRegions); % [millions of US $] annual structure loss:
    % i = yr, j = cuase, k = region.
   
for k = 1:nRegions
    idx1 = strcmp(REGION,regionID(k));
    for j = 1:nCauses
        idx2 = strcmp(data.CAUSE,fireCause(j));
        for i = 1:nYrs
            idx3 = [data.START_YEAR == yr(i)];
            idx = find([idx1.*idx2.*idx3]);
            if idx
            areaBurned(i,j,k) = nansum(data.FINAL_ACRES(idx)) .* 0.404686; % [ha]
            nFires(i,j,k) = length(idx);
            strucLoss(i,j,k) = nansum(data.STR_DESTROYED_TOTAL(idx)); % [#]
            fatalities(i,j,k) = nansum(data.FATALITIES(idx)); % [#]
            injuries(i,j,k) = nansum(data.INJURIES_TOTAL(idx)); % [#]            
            IMCosts(i,j,k) = nansum(data.PROJECTED_FINAL_IM_COST(idx))./...
                1000000; % [$]
%             strucExposure(i,j,k) = nansum(data.BUPR_SUM(idx)); % [#]
            if j == 1
                idx4 = find([idx1.*idx3]);
                discDOY(i,k) = nanmedian(data.DISCOVERY_DOY(idx4)); 
                maxFireGrowth(i,k) = nanmedian(data.WF_MAX_GROWTH_DOY(idx4));
            end
            end
        end
        if k == nRegions
            areaBurned(:,j,k) = nansum(squeeze(areaBurned(:,j,1:nRegions-1)),2);
            nFires(:,j,k) = nansum(squeeze(nFires(:,j,1:nRegions-1)),2);
            strucLoss(:,j,k) = nansum(squeeze(strucLoss(:,j,1:nRegions-1)),2); 
            fatalities(:,j,k) = nansum(squeeze(fatalities(:,j,1:nRegions-1)),2); 
            injuries(:,j,k) = nansum(squeeze(injuries(:,j,1:nRegions-1)),2); 
            IMCosts(:,j,k) = nansum(squeeze(IMCosts(:,j,1:nRegions-1)),2);
%             strucExposure(:,j,k) = nansum(squeeze(strucExposure(:,j,1:nRegions-1)),2);
        end    
    end
end

%% Calculate structure growth rate for each region
strucExposureData = readtable('C:\Users\philip.higuera.UM\Box\2_lab_SHARE\4_archivedData\Higuera_et_al_2023_PNAS_Nexus\data\structure_abundance\StrucExposureToFire_states.csv');
exposed = strucExposureData{:,2:end}'; % I
exposed(:,end+1) = sum(exposed(:,1:nRegions-1),2); % Sum for WEST

strucGrowthRate = NaN(2,nRegions); % i = time period (2000-2005, 20010-2015)
for i = 1:nRegions
    strucGrowthRate(1,i) = diff(exposed(1:2,i)) ./ exposed(1,i) .* 100;
	strucGrowthRate(2,i) = diff(exposed(3:4,i)) ./ exposed(3,i) .* 100;
end
strucInBurnableCover = exposed(3,1:end-1)'; % [NEED UNITS] Data from variable 
            % 'exposed' but for 2010 only (1/2 through analysis period),
            % and excluding the sum for the West (i.e., "end-1"). 

%% Calculate structure loss seasonality
%
%%%% LAST CALCULATED AND SAVED 13 MARCH 2022 %%%%

% strucDestroyed = data.STR_DESTROYED_TOTAL;
% DiscoveryDate = data.DISCOVERY_DOY;
% nStrucLoss = nansum(strucDestroyed);
% strucLossDOY = NaN(nStrucLoss,3); % i = 1 struc lost; j = doy, cause...
%     % 0 = L, 1 = H; start year.
% strucLossDOY_region = string(NaN(nStrucLoss,4)); % region ID for each 
%     % structure destroyed: state, GACC, EcoL3, EcoL2
% in = 1; % Index to fill in DOY x # strucs lost
% for j = 1:height(data) % For each record
%     if strucDestroyed(j) > 0
%         doy_j = DiscoveryDate(j);
%         idx = [in:in+strucDestroyed(j)-1];
%         strucLossDOY(idx,1) = doy_j;
%         if strcmp(data.CAUSE_UPDATED(j),'L')
%             strucLossDOY(idx,2) = 0;
%         end
%         if strcmp(data.CAUSE_UPDATED(j),'H')
%             strucLossDOY(idx,2) = 1;
%         end
%         strucLossDOY(idx,3) = data.START_YEAR(j);
%         strucLossDOY_region(idx,1) = data.STUSPS(j);
%         strucLossDOY_region(idx,2) = data.GACCAbbrev(j);
%         strucLossDOY_region(idx,3) = data.NA_L3NAME(j);
%         strucLossDOY_region(idx,4) = data.NA_L2NAME(j);
%         in = in+strucDestroyed(j);
%     end
% end
% varNames = {'DOY','NonLightning','START_YEAR','STUSPS','GACCAbbrev','NA_L3NAME','NA_L2NAME'};
% strucLossDOY = table(strucLossDOY(:,1),strucLossDOY(:,2),strucLossDOY(:,3),...
%     strucLossDOY_region(:,1),strucLossDOY_region(:,2),strucLossDOY_region(:,3),...
%     strucLossDOY_region(:,4),'VariableName',{'DOY','NonLightning','START_YEAR',...
%     'STUSPS','GACCAbbrev','NA_L3NAME','NA_L2NAME'});
% cd C:\Users\philip.higuera.UM\Box\2_lab_SHARE\4_archivedData\Higuera_et_al_2023_PNAS_Nexus\data\wf-incidents
% fileName = 'strucLossDOY.mat';
% save(fileName,'strucLossDOY') 
% cd C:\Users\philip.higuera.UM\Box\2_lab_SHARE\4_archivedData\Higuera_et_al_2023_PNAS_Nexus\code
