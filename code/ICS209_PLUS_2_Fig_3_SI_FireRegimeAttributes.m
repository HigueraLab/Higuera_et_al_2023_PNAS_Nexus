% ICS209_PLUS_2_Fig_FireRegimeAttributes.m
%
% Requires running ICS209_PLUS_1_LoadDataset.m first
%
% P. Higuera
% 23 Feb. 2022
% Updated 10 March, 2022, to separate out "undetermined" and "other"
% ignitions sources explicilty. 
%
% Updated 24 Oct., 2022, to set an alpha level of 0.10 for comparing median
% values in pannels a, c, e, and f. Updated "Structure loss rate" panel
% to plot correctly for regions where majority of structure loss is from
% lighting-ign. fires, yet structure loss rate is higher for fires from 
% human-related ignitoins. 
%
% Creates Figure 3 in the main text and identically formatted figures for
% the state, ecoregion, or GACC level in Supporting Information. 
%
%% Perform analyses on one or all regions
rawData = data; % Duplicating variables, which will then be filtered for 
    % region-specific analyses
rawStrucLossDOY = strucLossDOY; % Same as ablve for "data".

colorH = [1 0 0];%[0 0.5 0.9961]; % Human-caused
colorL = [0.1 0.25 1]; % Lightning = red
fs = 8;

for i = 1:nRegions

if i < nRegions
    if strcmp(spatialDomain,'STUSPS')
        idx = strcmp(rawData.POO_STATE,regionID(i));
        idxStrucLossDOY = strcmp(rawStrucLossDOY.STUSPS,regionID(i));
    end
    if strcmp(spatialDomain,'GACCAbbrev')
        idx = strcmp(rawData.GACCAbbrev,regionID(i));
        idxStrucLossDOY = strcmp(rawStrucLossDOY.GACCAbbrev,regionID(i));
    end
    if strcmp(spatialDomain,'NA_L3NAME')
        idx = strcmp(rawData.NA_L3NAME,regionID(i));
        idxStrucLossDOY = strcmp(rawStrucLossDOY.NA_L3NAME,regionID(i));
    end
    if strcmp(spatialDomain,'NA_L2NAME')
        idx = strcmp(rawData.NA_L2NAME,regionID(i));
        idxStrucLossDOY = strcmp(rawStrucLossDOY.NA_L2NAME,regionID(i));
    end
    data = rawData(idx,:);
    strucLossDOY = rawStrucLossDOY(idxStrucLossDOY,:);
else
    data = rawData;
	strucLossDOY = rawStrucLossDOY;
end

%% Extract variables
fireSize = data.FINAL_ACRES .* 0.404686; % [ha]
strucDestroyed = data.STR_DESTROYED_TOTAL;
sturcLossRate = data.STR_DESTROYED_TOTAL ./ fireSize .* 1000; % [#/kha]
    sturcLossRate(sturcLossRate == Inf) = NaN;
costs = data.PROJECTED_FINAL_IM_COST; % [$]
costsRate = data.PROJECTED_FINAL_IM_COST ./ fireSize .* 1000; % [$/kha]
peakPersonnel = data.WF_PEAK_PERSONNEL; % [#]
peakPersonnelRate = data.WF_PEAK_PERSONNEL ./ fireSize .* 1000; % [#/kha]
DayOfMaxGrowth = data.WF_MAX_GROWTH_DOY; % [doy]
DiscoveryDate = data.DISCOVERY_DOY; % [doy]
fireDuration = data.FOD_CONTAIN_DOY-data.FOD_DISCOVERY_DOY;
forestAB = fireSize .* data.tree_pct./100; % [ha] Multiplies fire size
    % by percent of fire perimiter that was forested.
herbAB = fireSize .* data.herb_pct./100; % [ha] Multiplies fire size
    % by percent of fire perimiter that was herb-dominated.
shrubAB = fireSize .* data.shrub_pct./100; % [ha] Multiplies fire size
    % by percent of fire perimiter that was shrub-dominated.
otherAB = fireSize -[forestAB + shrubAB + herbAB]; % [ha] Other land cover
    % burned, calculated by taking the difference between all forest,
    % shrub, and herb veg. burned, and total area burned from eacah fire.

nonForestAB = fireSize .* (100-data.tree_pct)./100; % [ha] Multiplies fire size
    % by percent of fire perimiter that was forested.
forestNonForestAB = [forestAB - nonForestAB] ./ fireSize;
forestGrassAB = [forestAB - herbAB] ./ [forestAB + herbAB];
forestShrubAB = [forestAB - shrubAB] ./ [forestAB + shrubAB];

%% FIRE CHARACTERISTICS AND IMPACTS, STRATIFIED BY IGNITION TYPE
figure(i); clf; set(gcf,'color','w','Units','Centimeters',...
    'Position',[1 1 20 12])%36 22])
fs = 8;

%%%% Fire size
subplot(231)
var = fireSize+1;
edges = exp(0:range(log(var+1))/25:max(log(var))); 
compare(var,edges,data,'Fire size (ha)')
ylabel('Count')
title([regionID(i) 'Fire size'])

%%%% Veg. type burned
subplot(232)
idxL = strcmp(data.CAUSE_UPDATED,'L');
idxH = strcmp(data.CAUSE_UPDATED,'H');
idxU = logical(strcmp(data.CAUSE_UPDATED,'U') + strcmp(data.CAUSE_UPDATED,'O'));
yH = [nansum(forestAB(idxH)); nansum(shrubAB(idxH)); nansum(herbAB(idxH)); nansum(otherAB(idxH))];
yL = [nansum(forestAB(idxL)); nansum(shrubAB(idxL)); nansum(herbAB(idxL)); nansum(otherAB(idxL))];
yU = [nansum(forestAB(idxU)); nansum(shrubAB(idxU)); nansum(herbAB(idxU)); nansum(otherAB(idxU))];

pTotal = round((yH+yL)./sum(yH+yL).*100);
ySum = sum(sum([yH(1:3) yL(1:3) yU(1:3)]))./1000;
if sum(yH)>sum(yL)
    y = [yH(1:3) yL(1:3)]./1000;
    b = bar(y,'FaceColor','flat');
    b(1).FaceColor = [0.9 0.5 0.5]; b(1).EdgeColor = colorH;
    b(2).FaceColor = [0 0.5 0.9961]; b(2).EdgeColor = colorL;
	legendText1 = ['Human-related: ' num2str(round(nansum(y(:,1))/ySum*100)) '% of tot.'];
    legendText2 = ['Lightning: ' num2str(round(nansum(y(:,2))/ySum*100)) '% of tot.'];
else
    y = [yL(1:3) yH(1:3)]./1000;
    b = bar(y,'FaceColor','flat');
    b = bar([yL(1:3) yH(1:3) ]./1000,'FaceColor','flat');
    b(2).FaceColor = [0.9 0.5 0.5]; b(1).EdgeColor = colorL;
    b(1).FaceColor = [0 0.5 0.9961]; b(2).EdgeColor = colorH;
	legendText1 = ['Lightning: ' num2str(round(nansum(y(:,1))/ySum*100)) '% of tot.'];
    legendText2 = ['Human-related: ' num2str(round(nansum(y(:,2))/ySum*100)) '% of tot.'];
end
    legendText3 = ['Undetermined: ' num2str(round((nansum(yU)./1000)/ySum*100)) '% of tot.'];

for in = 1:3
    if diff(y(in,:)) < 0
        perDiff = round(abs(diff(y(in,:)))./y(in,2)*100); % Percent difference
    else
        perDiff = round(abs(diff(y(in,:)))./y(in,1)*100); % Percent difference
    end
    text(in,max(y(in,:)),['+' num2str(perDiff) '%'],'HorizontalAlignment',...
        'Center','VerticalAlignment','Bottom','FontSize',fs)
end
y_lim = [0 1.7*max(max(y))];
xTickLabel = ({'Forest','Shrub','Grass'});
ylabel('Total area burned (kha)')
set(gca,'tickdir','out','box','off','yscale','linear','xticklabel',...
    xTickLabel,'FontSize',fs)
ylim(y_lim)
for in = 1:3
    text(in,-0.15*range(y_lim),['(' num2str(pTotal(in)) '%)'],...
        'HorizontalAlignment','Center','FontSize',fs)
end
hold on
plot(1,1,'.w')
legend(legendText1, legendText2,legendText3,'Location','NorthWest',...
    'FontSize',fs-2)
title('Vegetation type burned')

%%%% Discovery DOY
subplot(233)
var = DiscoveryDate;
edgesFS = [0 31 59 90 120 151 181 212 243 273 304 334 366]; % [day of yr]
compare(var,edgesFS,data,'Fire discovery date (month)')
set(gca,'xscale','linear','xtick',edgesFS+15,'XTickLabel',...
        {'J','F','M','A','M','J','J','A','S','O','N','D' ''})
ylabel('Count')
title('Fire seasonality')

%%%% Structure loss
subplot(234)
var = strucDestroyed;
edges = exp(0:range(log(var+1))/25:max(log(var))); 
compare(var,edges,data,'Structures destroyed (#)')
if i == nRegions; set(gca,'xtick',[1 10 100 1000 10000]); end
h = get(gca); legendText = h.Legend.String;
ylabel('Count')
title('Structure loss')

%%%% Structure loss rate (#/area burned)
subplot(235)
var = sturcLossRate;
var(var == 0) = NaN;
edges = exp(min(log(var)):range(log(var))/25:max(log(var))); 
idx = find(var<= 0);
var(idx) = NaN;
compare(var,edges,data,'Structure loss rate (# / kha)');
if i < nRegions
    legend off
else
    legend(legendText,'Location','NorthWest')
end
ylabel('Count')
title('Structure loss rate')

%%%% Structure loss season
subplot(236)
var = strucLossDOY{:,1:3};
compare(var,edgesFS,data,'Fire discovery date (month)')
set(gca,'xscale','linear','xtick',edgesFS+15,'XTickLabel',...
        {'J','F','M','A','M','J','J','A','S','O','N','D' ''})
y_lim = get(gca,'ylim');
if max(y_lim) > 1000
    y_tick = get(gca,'ytick');
    set(gca,'yticklabel',y_tick./1000)
    ylabel('Count (x 1000)')
else
    ylabel('Count')
end
if i < nRegions
    legend off
else
    legend(legendText,'Location','NorthWest')
end
title('Structure loss seasonality')

if saveFile == 1
	cd C:\Users\philip.higuera.UM\Box\2_lab_SHARE\4_archivedData\Higuera_et_al_2023_PNAS_Nexus\figures
%     fileName = ['ICS209PLUS_FireRegimesSimple_ByIgnSource_' char(spatialDomain) '_' char(regionID(i)) '.jpg'];
%    fileName = ['ICS209PLUS_FireRegimes_ByDecade_' char(spatialDomain) '_' char(regionID(i)) '.jpg'];
%    fileName = ['ICS209PLUS_FireRegimes_ByLightning_' char(spatialDomain) '_' char(regionID(i)) '.jpg'];
%    fileName = ['ICS209PLUS_FireRegimes_ByNonLightning_' char(spatialDomain) '_' char(regionID(i)) '.jpg'];  

%      fileName = ['Fig_S5_FireRegimesAttributes_State_' char(spatialDomain) '_' char(regionID(i)) '.jpg'];
     fileName = ['Fig_S8_FireRegimesAttributes_Ecoregion_' char(spatialDomain) '_' char(regionID(i)) '.jpg'];
%       fileName = ['Fig_S11_FireRegimesAttributes_GACC_' char(spatialDomain) '_' char(regionID(i)) '.jpg'];
      saveas(gcf,fileName)
%         exportgraphics(gcf,fileName,'Resolution',300)
	cd C:\Users\philip.higuera.UM\Box\2_lab_SHARE\4_archivedData\Higuera_et_al_2023_PNAS_Nexus\code
end
end
%% Local functions
%%%% Compare lightning to non-lightning ignited fires: histograms
function compare(x,edges,data,varName)
    colorH = [0.8 0 0]; % Human-caused
    colorL = [0 0.2 1]; % Lightning = blue
    fs = 8;
    alpha = 0.10; % Alpha level for rank-sum test 
    
    L = strcmp(data.CAUSE_UPDATED,'L');
    H = strcmp(data.CAUSE_UPDATED,'H');
    U = strcmp(data.CAUSE_UPDATED,'U') + strcmp(data.CAUSE_UPDATED,'O');
    idx1 = find(L);
    idx2 = find(H);    % This will be overwritten for structure- 
    idx3 = find(U);    % loss seasonality 
        
    if strcmp(varName,'Fire discovery date (month)')
        DOY_metric = 1;
        [m,n] = size(x);
        if n > 1    % This screens for structure-loss seasonality
           idx1 = find(x(:,2) == 0); % Lightning ignition
           idx2 = find(x(:,2) == 1); % Human-related ign.
           idx3 = find(isnan(x(:,2))); % Undetermined
           x = x(:,1);
        end
    else
        DOY_metric = 0;
    end
     
    if nansum(x(idx1)) > nansum(x(idx2)) % If lightning account for more of x...
        x1 = x(idx1);   % Plot L fires first
        x2 = x(idx2);   % H
        x3 = x(idx3);   % U
        color1 = colorL; % Lightning = blue
        color2 = colorH;
        legendText1 = ['Lightning: ' num2str(round(nansum(x1)/nansum([x1;x2;x3])*100)) '% of tot.'];
        legendText2 = ['Human-related: ' num2str(round(nansum(x2)/nansum([x1;x2;x3])*100)) '% of tot.'];
    else                % Otherwise...
        x1 = x(idx2);   % Plot H fires first
        x2 = x(idx1);   % L
        x3 = x(idx3);   % U
        color2 = colorL; % Lightning = blue
        color1 = colorH;
        legendText2 = ['Lightning: ' num2str(round(nansum(x2)/nansum([x1;x2;x3])*100)) '% of tot.'];
        legendText1 = ['Human-related: ' num2str(round(nansum(x1)/nansum([x1;x2;x3])*100)) '% of tot.'];
    end
        legendText3 = ['Undetermined: ' num2str(round(nansum(x3)/nansum([x1;x2;x3])*100)) '% of tot.'];
	if DOY_metric == 1
    	if length(x(idx1)) > length(x(idx2)) % If more lightning fires
            legendText1 = ['Lightning: ' num2str(round(length(x1)/length(x)*100)) '% of fires'];
            legendText2 = ['Human-related: ' num2str(round(length(x2)/length(x)*100)) '% of fires'];
        else
            legendText2 = ['Lightning: ' num2str(round(length(x2)/length(x)*100)) '% of fires'];
            legendText1 = ['Human-related: ' num2str(round(length(x1)/length(x)*100)) '% of fires'];
        end
        fs1 = prctile(x1,[25 75]); % [days] Fire season start - end
        fs2 = prctile(x2,[25 75]); % [days] Fire season start - end
        legendText3 = ['Undetermined: ' num2str(round(length(x3)/length(x)*100)) '% of fires'];
    end
    hold on
    h1 = histogram(x1,edges,'Normalization','count','FaceColor',color1,...
        'EdgeColor',color1);
    h2 = histogram(x2,edges,'Normalization','count','FaceColor',color2,...
        'EdgeColor',color2);
	plot(-99,-99,'.w'); % Dummy plot for legend
    set(gca,'xscale','log','tickdir','out','FontSize',fs)
    xlabel(varName)
    maxY = max([max(h1.BinCounts) max(h2.BinCounts)]);
    y_lim = [0 1.7*maxY];
	x_lim = [min(edges) max(edges)];
    xlim(x_lim)
	ylim(y_lim)
    if median(x1) ~= 0 % Flag to not do this for struc. destroyed
        median1 = prctile(x1,50);
        median2 = prctile(x2,50);
        plot([median1 median2],[maxY maxY].*1.1,'-k')
        plot(median1,maxY*1.1,'ok','MarkerFaceColor',color1,'Color',color1)
        plot(median2,maxY*1.1,'ok','MarkerFaceColor',color2,'Color',color2)
        [p,h] = ranksum(x(idx1),x(idx2));
    else
        p = 999;
    end  
    grid off
    box off
    if p <= alpha 
        if DOY_metric == 0
            delta = max(median1,median2)/min(median1,median2);  
            text(max(median1,median2),maxY*1.1,...
            ['  ' num2str(round(delta*100)/100) ' x more'],'FontSize',fs)
        else
            delta = max(median1,median2)-min(median1,median2);  
            text(max(median1,median2),maxY*1.1,...
            ['  ' num2str(round(delta*100)/100) ' days later'],'FontSize',fs)
        end
    else
        text(max(prctile(x1,50),prctile(x2,50)),maxY*1.1,...
            ['  Medians not sig. diff.'],'FontSize',fs)
    end
	if DOY_metric == 1
        if nansum(x(idx1)) > nansum(x(idx2)) % If lightning account for more of x...
            plot(fs1,[y_lim(2)*0.5 y_lim(2)*0.5],'r-','Color',[colorL],...
                'LineWidth',2)
            text(fs1(2),y_lim(2)*0.5,['  ' num2str(round(diff(fs1))) ' days'],'FontSize',fs)
            plot(fs2,[y_lim(2)*0.4 y_lim(2)*0.4],'k-','Color',[colorH],...
                'LineWidth',2)
            text(fs2(2),y_lim(2)*0.4,['  ' num2str(round(diff(fs2))) ' days'],'FontSize',fs)
        else
            plot(fs1,[y_lim(2)*0.5 y_lim(2)*0.5],'k-','Color',[colorH],...
                'LineWidth',2)
            text(fs1(2),y_lim(2)*0.5,['  ' num2str(round(diff(fs1))) ' days'],'FontSize',fs)
            plot(fs2,[y_lim(2)*0.4 y_lim(2)*0.4],'r-','Color',[colorL],...
                'LineWidth',2)
            text(fs2(2),y_lim(2)*0.4,['  ' num2str(round(diff(fs2))) ' days'],'FontSize',fs)
        end
        text(1,y_lim(2)*0.45,...
        	['    * ' num2str(abs(round(diff(fs1) - diff(fs2)))) '-day diff.'],'FontSize',fs)
    end
	if strcmp(varName,'Structures destroyed (#)')
        perNonDestrucFire = round(sum([x1; x2; x3] == 0)...
            ./length([x1; x2; x3])*100); % [%] percent of 
                % fires that do not destroy any structures. 
        text(x_lim(1)*5,y_lim(2)*0.5,...
        ['*' num2str(perNonDestrucFire) '% of fires had 0 struc. loss'],'FontSize',fs)
    end
	legend(legendText1,legendText2,legendText3,'Location','NorthWest',...
        'NumColumns',1,'FontSize',fs-2)
end