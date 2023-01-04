% ICS209_PLUS_2_Fig_ChangeInFireRegimeAttributes.m
%
% Requires running ICS209_PLUS_1_LoadDataset.m first
%
% P. Higuera
% 26 Feb. 2022
% Updated 10 March, 2022, to separate out "undetermined" and "other"
% ignitions sources explicilty. 
%
% Creates Figure 4 and the raw panels for Figure 6 from the main text. 
%
%% Set parmaters
alpha = 0.10; % Alpha. As of 26 Feb. 2022, only used here for fire-climate 
    % relationship plot.

%% Load additional data on strength and nature of fire-climate relationships
% i = region, j = ignition source: H, L, total; k = year-of, year-prior
% climate
fireClimate_r = load('C:\Users\philip.higuera.UM\Box\2_lab_SHARE\4_archivedData\Higuera_et_al_2023_PNAS_Nexus\data\derived\fireClimate_r_STUSPS.mat');
fireClimate_m = load('C:\Users\philip.higuera.UM\Box\2_lab_SHARE\4_archivedData\Higuera_et_al_2023_PNAS_Nexus\data\derived\fireClimate_m_STUSPS.mat');
fireClimate_p = load('C:\Users\philip.higuera.UM\Box\2_lab_SHARE\4_archivedData\Higuera_et_al_2023_PNAS_Nexus\data\derived\fireClimate_p_STUSPS.mat');

% Plot relationship between r (x) and m (y): 
% plot(fireClimate_r.r_aab_vpd(:,3,1),fireClimate_m.m(:,3,1),'ok')

%% Extract variables
fireSize = data.FINAL_ACRES .* 0.404686; % [ha]
strucDestroyed = data.STR_DESTROYED_TOTAL;
sturcLossRate = data.STR_DESTROYED_TOTAL ./ fireSize .* 1000; % [#/kha]
    sturcLossRate(sturcLossRate == Inf) = NaN;
costs = data.PROJECTED_FINAL_IM_COST; % [$]
costRate = data.PROJECTED_FINAL_IM_COST ./ fireSize .* 1000; % [$/kha]
peakPersonnel = data.WF_PEAK_PERSONNEL; % [#]
peakPersonnelRate = data.WF_PEAK_PERSONNEL ./ fireSize .* 1000; % [#/kha]
DayOfMaxGrowth = data.WF_MAX_GROWTH_DOY; % [doy]
DiscoveryDate = data.DISCOVERY_DOY; % [doy]
fireDuration = data.FOD_CONTAIN_DOY - data.FOD_DISCOVERY_DOY;
forestAB = fireSize .* data.tree_pct./100; % [ha] Multiply fire size
    % by percent of fire perimiter that was forested.
    
%% Summarize metrics by time slice: 1999-2009, 2010-2020, 1999-2020 
%%%% FIRE ACTIVITY

%%%% 11 March 2022: NEED to integrate O and U fires into this analysis,
%%%% starting with decadalAreaBurned, below. - PEH

decadalAreaBurned = NaN(nRegions,3,3); % [ha] decadal area burned:
    % i = region, j = cuase, k = time slice (early, late, all).
medianFireSize = NaN(nRegions,3,3); % [ha] median fire size:
    % i = region, j = cuase, k = time slice (early, late, all).
fireSeasonLength = NaN(nRegions,3,3); % [# days] Fire season length (central 90th percent): 
    % i = region, j = cuase, k = time slice (early, late, all).
fireSeasonMode = NaN(nRegions,3,3); % [# days] Fire season length (central 90th percent): 
    % i = region, j = cuase, k = time slice (early, late, all).
pForestBurned = NaN(nRegions,3); % [# days] Prop. of total area burned
    % that occurred in forest: i = region, k = time slice (early, late, all).
    % NOTE: not stratified by ignition type. 
decadalClimate = NaN(nRegions,3); % [kpa] decadal VPD:
    % i = region, j = time slice (early, late, all).
    
%%%% FIRE IMPACTS
decadalStrucLoss = NaN(nRegions,3,3); % [#] annual structure loss:
    % i = region, j = cuase, k = time slice (early, late, all).
extremeStrucLossRate = NaN(nRegions,3,3); % [#/ha burned] structure loss:
    % i = region, j = cuase, k = time slice (early, late, all).
annualCosts = NaN(nRegions,3,3); % [$] annual IC costs:
    % i = region, j = cuase, k = time slice (early, late, all).
strucLossSeaonLength = NaN(nRegions,3,3); % [days] structure loss 
    % season length: i = region, j = cuase, k = time slice (early, late, all).
strucLossSeasonMedian = NaN(nRegions,3,3); % [doy] structure loss 
    % season mode: i = region, j = cuase, k = time slice (early, late, all).
    
for k = 1:nRegions
    if k < nRegions % Index for region k
        idx1 = strcmp(data.STUSPS,regionID(k));
        idxStrucLossDOY1 = strcmp(strucLossDOY.regionID,regionID(k));
    else
        idx1 = ones(size(data.STUSPS));
        idxStrucLossDOY1 = ones(height(strucLossDOY),1);
    end
    for j = 1:3 % For each ignitions catagory: 1 = U+O; 2 = H, 3 = L
        if j == 1   % U or O
            idx2 = logical(strcmp(data.CAUSE,'U') + strcmp(data.CAUSE,'O')); % U and O fires
            idxStrucLossDOY2 = isnan(strucLossDOY.NonLightning); % NaN in struLossDOY = human-related
        end
        if j == 2   % H
            idx2 = strcmp(data.CAUSE,'H');  % Lightning ignition
            idxStrucLossDOY2 = strucLossDOY.NonLightning == 1; % 1 in strucLossDOY = human-related
        end
        if j == 3   % L
            idx2 = strcmp(data.CAUSE,'L');  % Lightning ignition
            idxStrucLossDOY2 = strucLossDOY.NonLightning == 0; % 0 in strucLossDOY = lightning-caused
        end
        
        for i = 1:3 % For each time slice
            if i == 1
                idx3 = data.START_YEAR < 2010;
                idxClimate = [2:12]; % Years 1999-2009.
                idxStrucLossDOY3 = strucLossDOY.START_YEAR < 2010;
            else
                idx3 = data.START_YEAR >= 2010;
                idxClimate = [13:23]; % Years 2010-2020
                idxStrucLossDOY3 = strucLossDOY.START_YEAR >= 2010;
            end
            if i == 3 % If covering the entire analysis period
                idx3 = ones(size(data.START_YEAR));
                idxClimate = [2:23]; % Years 2010-2020
                idxStrucLossDOY3 = ones(height(strucLossDOY),1);
            end
            if j == 1
                % Collect climate and pForestBurned here, since they are
                % not stratified by ign. source: 
                if k < nRegions
                    decadalClimate(k,i) = mean(vpdRegion(idxClimate,k));                    
%                     decadalClimate(k,i) = prctile(vpdRegion(idxClimate,k),95);                    
                else
                    decadalClimate(k,i) = mean(WestWideVPD(idxClimate)); 
%                     decadalClimate(k,i) = prctile(WestWideVPD(idxClimate),95
                end
                idxForestAB = find(idx1.*idx3);
                forestAB_jk = forestAB(idxForestAB); % Prep. for pForestburned,
                fireSize_jk = fireSize(idxForestAB); % to use only fires with veg data. 
                pForestBurned(k,i) = nansum(forestAB_jk)./...
                    nansum(fireSize_jk(~isnan(forestAB_jk)));
            end

            % Final index for i,j,k:   
            idx = find(idx1 .* idx2 .* idx3); % Index for all i,j,k.
            idxStucLossDOY = find(idxStrucLossDOY1 .* idxStrucLossDOY2 .* idxStrucLossDOY3); % Index for all i,j,k.

            if idx % For all variables sans structure loss DOY
                decadalAreaBurned(k,j,i) = sum(fireSize(idx));
                medianFireSize(k,j,i) = nanmedian(fireSize(idx));
                decadalStrucLoss(k,j,i) = sum(strucDestroyed(idx));
                extremeStrucLossRate(k,j,i) = prctile(sturcLossRate(idx),95);
                annualCosts(k,j,i) = prctile(sturcLossRate(idx),95);
                fireSeasonLength(k,j,i) = diff(prctile(DiscoveryDate(idx),[25 75]));
                fireSeasonMedian(k,j,i) = nanmedian(DiscoveryDate(idx));             
            end
            if idxStucLossDOY % For structure loss DOY variables
                strucLossSeaonLength(k,j,i) =...
                    diff(prctile(strucLossDOY.DOY(idxStucLossDOY),[25 75]));
                strucLossSeasonMedian(k,j,i) =...
                    nanmedian(strucLossDOY.DOY(idxStucLossDOY));
            end
        end
    end
end

%% Plot RANK AND CHANGES IN FIRE REGIME CHARACTERISTICS
figure(10); clf; set(gcf,'color','w','units','centimeters',...
    'position',[1 2 25 18])
fs = 6;

totalAB = squeeze(sum(decadalAreaBurned(:,:,:),2)); 
    % [ha] Total area burned rate: i = state, j = time period;
    
%%%% Rank & change in AREA BURNED
subplot(341)
x = totalAB(:,1:2)./ burnableArea; % [ha/km2] Total area burned rate: i = state, j = time period;
plotChange(x,nRegions,regionID)
xlim([0.5 30])
ylim([0 13])
xlabel('Burn rate (ha / km^2)')
title('Area burned, total')

%%%% Change in LIGHTNING-CUASED AREA BURNED
subplot(342)
x = squeeze(decadalAreaBurned(:,3,1:2))./burnableArea; 
    % [ha/km2] Lightning area burned rate: i = state, j = time period;
plotChange(x,nRegions,regionID)
xlim([0.5 30])
xlabel('Burn rate (ha / km^2)')
title('Area burned, lightning ign.')
legend off

%%%% Change in HUMAN-RELATED AREA BURNED
subplot(343)
x = squeeze(decadalAreaBurned(:,2,1:2))./burnableArea; 
    % [ha/km2] Non-lightning area burned rate: i = state, j = time period;
plotChange(x,nRegions,regionID)
xlim([0.1 15])
xlabel('Burn rate (ha / km^2)')
title('Area burned, human-related ign.')
legend off

%%%% Change in PROPOTION AREA BURNED IN FOREST
subplot(344)
x = pForestBurned(:,1:2); % [prop.] Prop. of forest burned by 
    % by all ign. souces, for each time period 1 and 2. 
plotChange(x,nRegions,regionID)
xlim([0 1])
set(gca,'xscale','linear','Xtick',[0:0.25:1],'XTicklabel',[0:0.25:1])
xlabel('Prop. area burned, forest')
title('Prop. of area burned forested')
legend off

%%%% Change in CLIMATE
subplot(345)
x = decadalClimate(:,1:2); % [prop.] Prop. of forest burned by 
    % by all ign. souces, for each time period 1 and 2. 
plotChange(x,nRegions,regionID)
xlim([0.5 3.25])
set(gca,'xscale','linear','Xtick',[1:3],'XTicklabel',[1:3])
xlabel('VPD (kpa)')
title('June-Aug. climate')
legend off

%%%% Change in STRENGTH OF FIRE-CLIMATE RELATIONSHIP
subplot(346)
x = fireClimate_m.m(:,3,1); % [log(kha)/kpa] Slope of linear regression 
    % on log aab as function of JJA vpd for: i = all regions, 
    % j = tot. area burned; k = yr-of relationship.
notSigIn = find(fireClimate_p.p(:,3,1) > alpha);
[~, in] = sort(x);
p1 = plot(x(in),[1:nRegions],'sk','MarkerFaceColor',[0.75 0.75 0.75]);
hold on
p2 = plot(x(notSigIn),in(notSigIn),'sk','MarkerFaceColor','w');
set(gca,'ytick',[1:nRegions],'yticklabel',regionID(in),'xscale','linear',...
    'tickdir','out','Box','off','FontSize',fs)
xlim([1 7])
grid on; %axis square
ylim([0 nRegions+1])
xlabel('Exponent, b: ha burned = a*exp(b*VPD)')
% xlabel('Slope (log(kha burned) / \uparrow kpa VPD)')
title('Sensitivity to yr-of climate (JJA VPD)')
legend('p < 0.10','p > 0.10','Location','NorthWest','FontSize',fs)

%%%% Change in DELTA FIRE SEASON LENGTH
subplot(347)
fireSeason_H = squeeze(fireSeasonLength(:,2,1:2));
fireSeason_L = squeeze(fireSeasonLength(:,3,1:2));
x = fireSeason_H-fireSeason_L;
plotChange(x,nRegions,regionID,1)
xlim([-10 120])
text(90,4,{'Human-related' 'season longer'},'FontSize',fs,...
    'HorizontalAlignment','Center','BackgroundColor','w')
set(gca,'xscale','linear','XTick',[0:30:150],'XTickLabel',[0:30:150])
xlabel({'\Delta fire season length (d)'})
title('\Delta fire season length')
legend off

%%%% Change in DELTA FIRE SEASON MEDIAN
subplot(348)
fireSeasonMedian_H = squeeze(fireSeasonMedian(:,2,1:2));
fireSeasonMedian_L = squeeze(fireSeasonMedian(:,3,1:2));
x = fireSeasonMedian_H-fireSeasonMedian_L;
[p1, p2] = plotChange(x,nRegions,regionID,1);
text(-45,11,{'Human-related' 'season earlier'},...
    'HorizontalAlignment','Center','BackgroundColor','w',...
    'FontWeight','Normal','FontSize',fs)
text(22,3.5,{'Human-' 'related' 'season' 'later'},'FontSize',fs,...
    'HorizontalAlignment','Center','BackgroundColor','w')
xlim([-90 30])
set(gca,'xscale','linear','XTick',[-120:30:60],'XTickLabel',[-120:30:60],...
    'ydir','rev')
xlabel({'\Delta fire season median (d)'})
legend([p1, p2],'1999-2009','2009-2020','Location','SouthWest')
title('\Delta fire season peak')
legend off

%%%% Rank & change in STRUCTURE LOSS RATE
subplot(349)
totalAB = squeeze(sum(decadalAreaBurned(:,:,:),2)); 
    % [ha] Total area burned rate: i = state, j = time period;
x = squeeze(sum(decadalStrucLoss(:,:,1:2),2))./...
    totalAB(:,1:2) .* 1000; % [#/kha burned]
[p1, p2] = plotChange(x,nRegions,regionID);
xlim([0.08 25])
xlabel({'Structure loss rate' '(# / km^2 burned)'})
title('Structure loss rate')
legend off

%%%% Rank & change in STRUCTURE ABUNDANCE IN FLAMMABLE VEG.
subplot(3,4,10)
StrucAbundance = exposed'./burnableArea; % [#/km2]
x = StrucAbundance(:,[1 4]);
[p1, p2] = plotChange(x,nRegions,regionID);
xlim([0.1 10])
xlabel({'Structure density' '(# structures / burnable km^2)'})
title('Structure abundance in flammable veg.')
legend off

%%%% Change in DELTA STRUCTURE-LOSS SEASON LENGTH
subplot(3,4,11)
strucLossSeason_H = squeeze(strucLossSeaonLength(:,2,1:2));
strucLossSeason_L = squeeze(strucLossSeaonLength(:,3,1:2));
x = strucLossSeason_H-strucLossSeason_L;
plotChange(x,nRegions,regionID,1)
hold on
text(120,4,{'Human-' 'related' 'season' 'longer'},'FontSize',fs,...
    'HorizontalAlignment','Center','BackgroundColor','w')
xlim([-90 150])
set(gca,'xscale','linear','XTick',[-60:30:150],'XTickLabel',[-60:30:150])
xlabel({'\Delta struc.-loss season length (d)'})
title('\Delta stuc.-loss season length')
legend off

%%%% Change in DELTA STRUC-LOSS FIRE SEASON MEDIAN
subplot(3,4,12)
strucLossSeasonMedian_H = squeeze(strucLossSeasonMedian(:,2,1:2));
strucLossSeasonMedian_L = squeeze(strucLossSeasonMedian(:,3,1:2));
x = strucLossSeasonMedian_H-strucLossSeasonMedian_L;
[p1, p2] = plotChange(x,nRegions,regionID,1);
% text(-45,8,{'Human-related' 'season earlier'},...
%     'HorizontalAlignment','Center','BackgroundColor','w',...
%     'FontWeight','Normal','FontSize',fs)
text(90,4,{'Human-' 'related' 'season' 'later'},'FontSize',fs,...
    'HorizontalAlignment','Center','BackgroundColor','w')
xlim([-90 120])
set(gca,'xscale','linear','XTick',[-60:30:150],'XTickLabel',[-60:30:150])
xlabel({'\Delta struc.-loss season median (d)'})
legend([p1, p2],'1999-2009','2009-2020','Location','SouthWest')
title('\Delta struc.-loss season peak')
legend off

% %%%% Change in PROPORTION AREA BURNED BY LIGHTNING
% subplot(245)
% totalAB = squeeze(sum(areaBurned(:,:,:),2));
% x = squeeze(areaBurned(:,2,:))./totalAB; % [prop.] Propotion ab from lightning
% [p1, p2] = plotChange(x,nRegions,regionID);
% xlim([0 1])
% set(gca,'xscale','linear')
% xlabel('Proportion of area burned from lightning ignition')
% title('Prop. lightning area burned')
% legend([p1 p2],'2000','2015','Location','NorthWest')

if saveFile == 1
    fileName = ['ICS209PLUS_ChangeInFireRegimeMetrics.jpg'];
    saveas(gcf,fileName)
end


%% Plot changes in STRUCTURE LOSS as function of AREA BURNED RATE
figure(11); clf; set(gcf,'color','w','Units','centimeters',...
    'position',[1 2 10 20])
fs = 8;

cMap = jet;
for i = 25:39
    cMap(i,:) = [0.75 0.75 0.75];
end
cMapBin = [-1:2/63:1]; % Bins, for ratios: L:non-L area burned.

X = [(sum(decadalAreaBurned(:,:,1),2)./ burnableArea),...
    (sum(decadalAreaBurned(:,:,2),2)./ burnableArea)]; % [ha/km2] Area burned rate
Y = [(sum(decadalStrucLoss(:,:,1),2)./sum(decadalAreaBurned(:,:,1),2)),...
    (sum(decadalStrucLoss(:,:,2),2)./sum(decadalAreaBurned(:,:,2),2))].*1000; % [#/kha burned]

%%%% Propotion of total area burned by non-lightning ignitions, by period:
pAreaBurned_UH(:,1) = [decadalAreaBurned(:,1,1)+decadalAreaBurned(:,2,1)] ./...
    squeeze(sum(decadalAreaBurned(:,:,1),2));
pAreaBurned_UH(:,2) = [decadalAreaBurned(:,1,2)+decadalAreaBurned(:,2,2)] ./...
    squeeze(sum(decadalAreaBurned(:,:,2),2));

x_lim = [1 25];
y_lim = [0.1 60];

subplot(211)
hold on
% Dummby plots for legend
p1 = plot(-99,-99,'ok','MarkerFaceColor',[0.8 0.8 0.8],'MarkerSize',0.25*25);
p2 = plot(-99,-99,'ok','MarkerFaceColor',[0.5 0.5 0.5],'MarkerSize',0.25*25);
p3 = plot(-99,-99,'ok','MarkerFaceColor','w','MarkerSize',0.12*25);
p4 = plot(-99,-99,'ok','MarkerFaceColor','w','MarkerSize',0.25*25);
p5 = plot(-99,-99,'ok','MarkerFaceColor','w','MarkerSize',0.50*25);
p7 = plot(-99,-99,'.w'); p8 = plot(-99,-99,'.w');
legendText = {'1999-2009', '2010-2020', ' ', '12%','25%','50%'};

plot(x_lim,[Y(12,1) Y(12,1)],'-k')
plot([X(12,1) X(12,1)],0.75*y_lim,'-k')
for i = 1:length(X)
    plot([X(i,1) X(i,2)],[Y(i,1) Y(i,2)],'-','Color',[0.8 0.8 0.8])
end
for i = 1:length(X)
    plot(X(i,1),Y(i,1),'ok','MarkerFaceColor',[0.8 0.8 0.8],...
        'MarkerEdgeColor',[0.8 0.8 0.8],'MarkerSize',pAreaBurned_UH(i,1)*25)
    plot(X(i,2),Y(i,2),'ok','MarkerFaceColor',[0.5 0.5 0.5],...
        'MarkerSize',pAreaBurned_UH(i,2)*25)
    text(X(i,2)*1.15,Y(i,2),regionID(i),'FontSize',fs)
end
set(gca,'xscale','log','yscale','log','tickdir','out','box','off',...
    'FontSize',fs)
xlim(x_lim); ylim(y_lim)
grid on
axis square
xlabel('Area burned rate (ha / km^2)')
ylabel('Structure loss rate (# / kha burned)')
lgd = legend([p1 p2 p7 p3 p4 p5],legendText,'Location','NorthWest');
lgd.NumColumns = 2;
% title('Area burned and structure loss rates')
text(0.6*x_lim(1),1*y_lim(2),'A','FontSize',12,'FontWeight','Bold')

%%%% Radial vector analysis
[m,d,v] = RVA(X,Y);
[~,mRank] = sort(m);

subplot(212)
% pChange_AB_H = pAreaBurned_H(:,2) ./ pAreaBurned_H(:,1) - 1;
pChange_AB_UH = pAreaBurned_UH(:,2) ./ pAreaBurned_UH(:,1) - 1;
x_lim = [-3 8];
y_lim = [-2 6];
hold on
% Dummby plots for legend
p1 = plot(-99,-99,'^k','MarkerFaceColor',[1 1 1],'MarkerSize',(0.25+0.5)*5);
p2 = plot(-99,-99,'^k','MarkerFaceColor',[0.5 0.5 0.5],'MarkerSize',(0.25+0.5)*5);
p3 = plot(-99,-99,'^k','MarkerFaceColor',[0.5 0.5 0.5],'MarkerSize',(0.5+0.5)*5);
p4 = plot(-99,-99,'^k','MarkerFaceColor',[0.5 0.5 0.5],'MarkerSize',(1+0.5)*5);
p5 = plot(-99,-99,'^k','MarkerFaceColor',[0.5 0.5 0.5],'MarkerSize',(2+0.5)*5);
legendText = {'-25%','+25%','+50%','+100%','+200%'};

plot(x_lim,[0 0],'-k')
plot([0 0],[y_lim(1) y_lim(2)*0.8],'-k')
for i = 1:nRegions
    plot([0 v(i,1)],[0 v(i,2)],'k-','Color',[0.75 0.75 0.75])
end
for i = 1:nRegions
    text(v(i,1)+0.25,v(i,2),regionID(i),'FontSize',fs)
    if pChange_AB_UH(i) > 0
        plot(v(i,1),v(i,2),'^k','MarkerFaceColor',[0.5 0.5 0.5],...
        'MarkerSize',(pChange_AB_UH(i)+0.5)*5)
    else
        plot(v(i,1),v(i,2),'^k','MarkerFaceColor',[1 1 1],...
        'MarkerSize',(abs(pChange_AB_UH(i))+0.5)*5)
    end
end
set(gca,'tickdir','out','box','off','FontSize',fs)
grid on
axis square
xlim(x_lim)
ylim(y_lim)
xlabel('Change in area burned rate (ha / km^2)')
ylabel('Change in structure loss rate (# / kha burned)')
% title('Change in area burned and structure loss rates')
legend([p1,p2,p3,p4,p5],legendText,'Location','NorthWest')
text(-3.5,6.5,'B','FontSize',12,'FontWeight','Bold')

if saveFile == 1
    fileName = ['ICS209PLUS_AreaBurned_LossRate_VectorAnalysis.jpg'];
    saveas(gcf,fileName)
end

%% Local function for plotting CHANGE in fire regime attributes

%%%% Radial vector analysis %%%%
% https://math.libretexts.org/Bookshelves/Precalculus/Precalculus_(OpenStax)/08%3A_Further_Applications_of_Trigonometry/8.08%3A_Vectors
function [m,d,v] = RVA(X,Y)
% Position vector, v
v(:,1) = [X(:,2)-X(:,1)];   % Position vector, x values
v(:,2) = [Y(:,2)-Y(:,1)];   % Position vector, y values
% Vector magnitude
m = sqrt(v(:,1).^2 + v(:,2).^2);
% Direction
d = atand(v(:,2)./v(:,1));
end

%%%% Plot rank and change in variable over two decades %%%%
function [p1, p2] = plotChange (x,nRegions,regionID,FireSeason)
fs = 6;
if nargin == 3
    FireSeason = 0;
end

[~, in] = sort(x(:,2));
hold on
for i = 1:nRegions
    plot([x(in(i),1) x(in(i),2)],[i i]','-k','MarkerFaceColor',[0.5 0.5 0.5])
end  
if FireSeason == 1
    plot([0 0],[0 nRegions+1],'k-')
    hold on
end

p1 = plot(x(in,1),[1:nRegions],'ok','MarkerFaceColor',...
    [0.75 0.75 0.75],'MarkerSize',4);
p2 = plot(x(in,2),[1:nRegions],'ok','MarkerFaceColor',...
    [0.5 0.5 0.5],'MarkerSize',4);

%%%% Calculate change in proportion
if FireSeason == 0
delta_x = NaN(nRegions,1); 
    for i = 1:nRegions
       delta_x(i) = (x(i,2) - x(i,1)) ./ x(i,1);
       if delta_x(i) > 0
           text(x(i,2),find(in == i),...
           ['   ' num2str(abs(round(delta_x(i)*100))) '% \uparrow'],...
           'Color',[0.25 0.25 0.25],'FontSize',fs)
       else
           text(x(i,2)*0.9,find(in == i),...
           [num2str(abs(round(delta_x(i)*100))) '% \downarrow'],...
           'HorizontalAlignment','Right',...
           'Color',[0.25 0.25 0.25],'FontSize',fs)
       end
    end
end
if FireSeason == 1
    for i = 1:nRegions
       delta_x(i) = x(i,2) - x(i,1);
       if delta_x(i) > 0
           text(x(i,2)+5,find(in == i),...
           [   '+' num2str(abs(round(delta_x(i)))) ' d'],...
           'Color',[0.25 0.25 0.25],'FontSize',fs)
       else
           text(x(i,2)-5,find(in == i),...
           ['-' num2str(abs(round(delta_x(i)))) ' d'],...
           'HorizontalAlignment','Right',...
           'Color',[0.25 0.25 0.25],'FontSize',fs)
       end
    end
end
set(gca,'ytick',[1:nRegions],'yticklabel',regionID(in),'xscale','linear',...
    'xscale','log','tickdir','out','Box','off','XTick',[0.1 1 10],...
    'XTickLabel',[0.1 1 10],'FontSize',fs)
grid on; %axis square
ylim([0 nRegions+1])
legend([p1 p2],'1999-2009','2010-2020','Location','NorthWest','FontSize',...
    fs)
end