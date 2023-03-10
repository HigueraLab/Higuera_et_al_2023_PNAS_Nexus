% ICS209_PLUS_2_Fig_TimeSeries.m
%
% Requires running ICS209_PLUS_1_LoadDataset.m first
%
% P. Higuera
% 23 Feb. 2022
% Updated 10 March, 2022, to separate out "undetermined" and "other"
% ignitions sources explicilty. 
%
% Creates Figure 2 in the main text and identically formatted figures for
% the state, ecoregion, or GACC level in Supporting Information. 
%
%% Plot time series: FIRE and STRUCTURE LOSS, one fig. per region
CData = [0.75 0.75 0.75; 0.8 0.5 0;...
    0.9 0.35 0.35; 0 0.5 0.9961]; % Color for bars:
    % other, undetermined, human, lightning.
fs = 8;
alpha = 0.10; 

for i = 1:nRegions
figure(i); clf; set(gcf,'color','w','Units','Centimeters','Position',...
    [2 2  10 20])

if i < nRegions
	climate = vpdRegion(2:end,i);
else
	climate = WestWideVPD(2:end);
end
aabTot = nansum(areaBurned(:,1:4,i),2) ./ 1000; % [ha x 1000]
aabL = (1+nansum(areaBurned(:,4,i),2)) ./ 1000; % [ha x 1000]
aabH = (1+nansum(areaBurned(:,3,i),2)) ./ 1000; % [ha x 1000]
aabU = (1+nansum(areaBurned(:,1:2,i),2)) ./ 1000; % [ha x 1000]

strucLossTot = nansum(strucLoss(:,1:4,i),2); % [#]
strucLossL = (1+nansum(strucLoss(:,4,i),2)); % [#]
strucLossH = (1+nansum(strucLoss(:,3,i),2)); % [#]
strucLossU = (1+nansum(strucLoss(:,1:2,i),2)); % [#]

%%%% ANNUAL AREA BURNED, BY IGNITION SOURCE
subplot(3,5,[1:3])
    
    % Plot annual area burned
    h2 = plot(2020,0,'.w'); % Dummy plot, for legend
    hold on
    h1 = bar(yr,[aabU aabH aabL],1,'stacked','FaceColor','Flat');
    h1(1).CData = CData(1,:); h1(2).CData = CData(3,:); h1(3).CData = CData(4,:);
%     h1 = bar(yr,[aabH aabL],1,'stacked','FaceColor','Flat');
%     h1(1).CData = CData(3,:); h1(2).CData = CData(4,:);
    ylabel('Area burned (kha)')
    x_lim = get(gca,'xlim');
    y_lim = get(gca,'ylim');
    y_lim(2) = y_lim(2)*1.8;
    set(gca,'tickdir','out','box','off','ylim',y_lim,'FontSize',fs)
        
    % Fire-climate correlations
    [rClimateAab(1), pClimateAab(1)] = corr(climate,log(aabH));
    [rClimateAab(2), pClimateAab(2)] = corr(climate,log(aabL));
    [rClimateAab(3), pClimateAab(3)] = corr(climate,log(aabTot));

    % Plot VPD, if it's correlated with at aab (tot, H, or L)
    if sum(rClimateAab) > 0
        yyaxis right
        h3 = plot(yr,climate,'k','linewidth',2);
        set(gca,'ycolor','k')
%         ylabel('VPD (kpa)')
        y_lim = get(gca,'ylim');
        y_lim(2) = y_lim(2)*1.25;
        ylim(y_lim)
        text(2025,y_lim(1)+range(y_lim)/2,'VPD (kpa)','Rotation',270,...
            'HorizontalAlignment','Center','FontSize',fs)
        yyaxis left
    end
       
    % Trend-over-time detection
	[~,~,hAab_U,sig,~,~,~,sen,~,senplot] = ktaub([yr' aabU],alpha,0); % Sens slope estimator
	[~,~,hAab(1),sig,~,~,~,sen,~,senplot] = ktaub([yr' aabH],alpha,0); % Sens slope estimator
	[~,~,hAab(2),sig,~,~,~,sen,~,senplot] = ktaub([yr' aabL],alpha,0); % Sens slope estimator
	[~,~,hAab(3),sig,~,~,~,sen,~,senplot] = ktaub([yr' aabTot],alpha,0); % Sens slope estimator 
	[~,~,hClimate,sig,~,~,~,sen,~,senplot] = ktaub([yr' climate],alpha,0); % Sens slope estimator 
    
    % Legend text
    if hAab_U == 1
       legendText0 = ['U (' int2str(nansum(aabU)/nansum(aabTot)*100) '% of tot.): trend \uparrow']; 
    else
       legendText0 = ['U (' int2str(nansum(aabU)/nansum(aabTot)*100) '% of tot.): no trend'];
    end
    if hAab(1) == 1
        legendText1 = ['H (' int2str(nansum(aabH)/nansum(aabTot)*100) '% of tot.): trend \uparrow'];
    else
        legendText1 = ['H (' int2str(nansum(aabH)/nansum(aabTot)*100) '% of tot.): no trend'];
    end
    if hAab(2) == 1
        legendText2 = ['L (' int2str(nansum(aabL)/nansum(aabTot)*100) '% of tot.): trend \uparrow'];
    else
        legendText2 = ['L (' int2str(nansum(aabL)/nansum(aabTot)*100) '% of tot.): no trend'];
    end
	if hAab(3) == 1
        legendText3 = ['Tot. area burned: trend \uparrow'];
    else
        legendText3 = ['Tot. area burned: no trend'];
    end
    if hClimate == 1
        legendText4 = ['JJA VPD: trend \uparrow | r = ' num2str(round(rClimateAab(3)*100)/100)];
    else
        legendText4 = ['JJA VPD: no trend | r = ' num2str(round(rClimateAab(3)*100)/100)];
    end
    if sum(rClimateAab) > 0
        legend([h2, h1, h3],legendText3,legendText0,legendText1,legendText2,legendText4,...
        'Location','North','FontSize',fs-2)
%         text(x_lim(1),y_lim(2)*1.25,...
%             ['Clim.-fire corr (tot.,H,L): ' num2str(round(rClimateAab([3 1 2]).*100)./100)],...
%             'FontSize',fs-2)
    else
        legend([h2, h1],legendText3,legendText0,legendText1,legendText2,...
        'Location','North','FontSize',fs-2)
    end
    title([regionID(i) ' '])

subplot(3,5,5)
    y1 = nansum([aabU(1:11) aabH(1:11) aabL(1:11)]); % [ha]
    y2 = nansum([aabU(12:end) aabH(12:end) aabL(12:end)]); % [ha]
    [change] = decadalChange(y1,y2,CData);
%     title([regionID(i) ' '])
    pos = get(gca,'position'); pos(1) = 0.7657;
    pos([3 4]) = [0.2064 0.2157];
    set(gca,'position',pos,'FontSize',fs)
    
%%%%%%%% ANNUAL STRUCTURE LOSS
subplot(3,5,[6:8])
    h2 = plot(2020,0,'.w'); % Dummy plot, for legend
    hold on
    h1 = bar(yr,[strucLossU./1000 strucLossH./1000 strucLossL./1000],1,'stacked','FaceColor','Flat');
    h1(1).CData = CData(1,:); h1(2).CData = CData(3,:); h1(3).CData = CData(4,:);
%     h1 = bar(yr,[strucLossH./1000 strucLossL./1000],1,'stacked','FaceColor','Flat');
%     h1(1).CData = CData(3,:); h1(2).CData = CData(4,:);
    ylabel({'Structures destroyed' '(# x 1000)'})
    y_lim = get(gca,'ylim');
    y_lim(2) = y_lim(2)*1.8;
    set(gca,'tickdir','out','box','off','ylim',y_lim,'FontSize',fs)
   
    % Struc loss -- aab correlations
    [rStrucLossAab(1), pStrucLossAab(1)] = corr(log(aabH),log(strucLossH));
    [rStrucLossAab(2), pStrucLossAab(2)] = corr(log(aabH),log(strucLossL));
    [rStrucLossAab(3), pStrucLossAab(3)] = corr(log(aabH),log(strucLossTot));

    % Plot aabH, if it's correlated with total struc. loss
    if pStrucLossAab(3) < alpha
        yyaxis right
        h3 = plot(yr,aabH,'-k','linewidth',2);
        set(gca,'ycolor','k','FontSize',fs)
%         ylabel({'Area burned (kha)'})
        y_lim = get(gca,'ylim');
        y_lim(2) = y_lim(2)*1.8;
        ylim(y_lim)
        text(2027,y_lim(1)+range(y_lim)/2,'Area burned (kha)','Rotation',270,...
            'HorizontalAlignment','Center','FontSize',fs)
        yyaxis left
    end
       
    % Trend-over-time detection
	[~,~,hStrucLoss_U,sig,~,~,~,sen,~,senplot] = ktaub([yr' strucLossU],alpha,0); % Sens slope estimator
    [~,~,hStrucLoss(1),sig,~,~,~,sen,~,senplot] = ktaub([yr' strucLossH],alpha,0); % Sens slope estimator
	[~,~,hStrucLoss(2),sig,~,~,~,sen,~,senplot] = ktaub([yr' strucLossL],alpha,0); % Sens slope estimator
	[~,~,hStrucLoss(3),sig,~,~,~,sen,~,senplot] = ktaub([yr' strucLossTot],alpha,0); % Sens slope estimator 
% 	[~,~,hStrucLoss(4),sig,~,~,~,sen,~,senplot] = ktaub([yr' aabH],alpha,0); % Sens slope estimator 
    
    % Title and label
%     text(1995,1.1*y_lim(2),'B','FontSize',12,'FontWeight','Bold')
    
    % Legend text
    if hStrucLoss_U == 1
       legendText0 = ['From U (' int2str(nansum(strucLossU)/nansum(strucLossTot)*100) '% of tot.): trend \uparrow']; 
    else
       legendText0 = ['From U (' int2str(nansum(strucLossU)/nansum(strucLossTot)*100) '% of tot.): no trend'];
    end
	if hStrucLoss(1) == 1
        legendText1 = ['From H (' int2str(nansum(strucLossH)/nansum(strucLossTot)*100) '% of tot.): trend \uparrow'];
    else
        legendText1 = ['From H (' int2str(nansum(strucLossH)/nansum(strucLossTot)*100) '% of tot.): no trend'];
    end
    if hStrucLoss(2) == 1
        legendText2 = ['From L (' int2str(nansum(strucLossL)/nansum(strucLossTot)*100) '% of tot.): trend \uparrow'];
    else
        legendText2 = ['From L (' int2str(nansum(strucLossL)/nansum(strucLossTot)*100) '% of tot.): no trend'];
    end
	if hStrucLoss(3) == 1
        legendText3 = ['Tot. struc. loss: trend \uparrow'];
    else
        legendText3 = ['Tot. struc. loss: no trend'];
    end
    if pStrucLossAab < alpha
        legendText4 = ['Area burned, H | r = ' num2str(round(rStrucLossAab(3)*100)/100)];
    else
        legendText4 = ['Area burned, H | not correlated'];
    end
    if sum(pStrucLossAab) < alpha
        legend([h2, h1, h3],legendText3,legendText0,legendText1,legendText2,legendText4,...
        'Location','North','FontSize',fs-2)
%         text(x_lim(1)-5,y_lim(1),...
%             ['StrucLoss-aabH corr (tot.,H,L): ' num2str(round(rStrucLossAab([3 1 2]).*100)./100)],...
%             'Rotation',90,'FontSize',fs-2)
    else
        legend([h2, h1],legendText3,legendText0,legendText1,legendText2,...
        'Location','North','FontSize',fs-2)
    end

subplot(3,5,10)
    y1 = nansum([strucLossU(1:11)./1000 strucLossH(1:11)./1000 strucLossL(1:11)./1000]); % [ha]
    y2 = nansum([strucLossU(12:end)./1000 strucLossH(12:end)./1000 strucLossL(12:end)./1000]); % [ha]
    [change] = decadalChange(y1,y2,CData);    
    pos = get(gca,'position'); pos(1) = 0.7657;
    pos([3 4]) = [0.2064 0.2157];
    set(gca,'position',pos,'FontSize',fs)
    
%%%% Structure loss rate
subplot(3,5,[11:13])
    lossRate = nansum(strucLoss(:,:,i),2)./nansum(areaBurned(:,:,i),2).*1000; 
        % [# lost/1000 ha burned]
    hold on
    h1 = bar(yr,lossRate,1,'stacked','FaceColor','Flat');
    h1(1).CData = [0.5 0.5 0.5]; 
    ylabel({'Structure loss rate' '(# / kha burned)'})
    y_lim = get(gca,'ylim');
    y_lim(2) = y_lim(2)*1.25;
    set(gca,'tickdir','out','box','off','ylim',y_lim,'FontSize',fs)
     
    % Struc loss rate -- aab correlations
    [rStrucLossAab, pStrucLossAab] = corr(log(aabH),log(lossRate));

    % Plot aabH, if it's correlated with total struc. loss
    if pStrucLossAab < alpha
        yyaxis right
        h2 = plot(yr,aabH,'-k','linewidth',2);
        set(gca,'ycolor','k','FontSize',fs)
%         ylabel('Area burned (kha)')
        y_lim = get(gca,'ylim');
        y_lim(2) = y_lim(2)*1.25;
        ylim(y_lim)
       text(2027,y_lim(1)+range(y_lim)/2,'Area burned (kha)','Rotation',270,...
            'HorizontalAlignment','Center','FontSize',fs)
        yyaxis left
    end
       
    % Trend-over-time detection
	[~,~,hLossRate,sig,~,~,~,sen,~,senplot] = ktaub([yr' lossRate],alpha,0); % Sens slope estimator
    
    % Title and label
    y_lim = get(gca,'ylim');
%     text(1995,1.1*y_lim(2),'C','FontSize',12,'FontWeight','Bold')
    
    % Legend text
    if hLossRate == 1
        legendText1 = ['Struc. loss rate (all): trend \uparrow'];
    else
        legendText1 = ['Struc. loss rate (all): no trend'];
    end
    if pStrucLossAab < alpha
        legendText2 = ['Area burned, H | r = ' num2str(round(rStrucLossAab*100)/100)];
    else
        legendText2 = ['Area burned, H | not correlated'];
    end
    if sum(pStrucLossAab) < alpha
        legend([h1, h2],legendText1,legendText2,'Location','North',...
            'FontSize',fs-2)
%         text(x_lim(1),-1*0.4*y_lim(2),...
%             ['StrucLossRate-aabH corr (tot.,H,L): ' num2str(round(rStrucLossAab*100)/100)],...
%             'FontSize',fs-2)
    else
        legend([h1],legendText1,legendText2,'Location','North',...
            'FontSize',fs-2)
    end
    xlabel('Year')
   
subplot(3,5,15)
    y = nansum(strucLoss(:,:,i),2); % [#] Total structures lost per year
    y1 = nansum(y(1:11)) / nansum(aabTot(1:11)); % [# / kha burned] 
    y2 = nansum(y(12:end)) / nansum(aabTot(12:end)); % [# / kha burned] 
    change = round((nansum(y2)-nansum(y1))/nansum(y1)*100);
    h = bar([1 2],[y1; y2],'FaceColor',[0.5 0.5 0.5]);
    xlim([0.5 2.5])
    y_lim = get(gca,'ylim');
    set(gca,'xticklabel',' ','TickDir','Out','Box','off','FontSize',fs)
    text(1,0,{'1999-' '2009'},'VerticalAlignment','Top',...
        'HorizontalAlignment','Center','FontSize',fs)
    text(2,0,{'2010-' '2020'},'VerticalAlignment','Top',...
        'HorizontalAlignment','Center','FontSize',fs)
	if nansum(y2) > nansum(y1)
        text(2,sum(y2),[num2str(abs(change)) '% \uparrow'],...
            'HorizontalAlignment','Center','FontSize',fs-2,...
            'VerticalAlignment','Bottom')
    else
        text(2,sum(y2),[num2str(abs(change)) '% \downarrow'],...
            'HorizontalAlignment','Center','FontSize',fs-2,...
            'VerticalAlignment','Bottom')
    end
    pos = get(gca,'position'); pos(1) = 0.7657;
    pos([3 4]) = [0.2064 0.2157];
    set(gca,'position',pos,'FontSize',fs)
    
 %%%% End plotting
     if saveFile == 1
        cd C:\Users\philip.higuera.UM\Box\1_phiguera\1_working\Projects\2021_CIRES_VisitingFellow_Program\ChangingHumanCausesAndCostsOfWesternWildfires\figures
%         fileName = ['ICS209_AAB_StrucLoss_TimeSeries_COMPACT_' char(spatialDomain) '_' char(regionID(i)) '.jpg'];
%         fileName = ['Fig_S4_AAB_StrucLoss_TimeSeries_State_' char(spatialDomain) '_' char(regionID(i)) '.fig'];
        fileName = ['Fig_S7_AAB_StrucLoss_TimeSeries_Ecoregion_' char(spatialDomain) '_' char(regionID(i)) '.fig'];
%         fileName = ['Fig_S10_AAB_StrucLoss_TimeSeries_GACC_' char(spatialDomain) '_' char(regionID(i)) '.fig'];
        saveas(gcf,fileName)
%         exportgraphics(gcf,fileName,'Resolution',300)

        cd C:\Users\philip.higuera.UM\Box\1_phiguera\1_working\Projects\2021_CIRES_VisitingFellow_Program\ChangingHumanCausesAndCostsOfWesternWildfires\code
    end 
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% LOCAL FUNCTIONS

function [r, m, p] = fireClimateCorr(x,y)
    plot(x,y,'ok')
    hold on
    plot(x(1:11),y(1:11),'ok','MarkerFaceColor',[0.75 0.75 0.75])
    plot(x(12:end),y(12:end),'ok','MarkerFaceColor',[0.25 0.25 0.25])
    set(gca,'yscale','log','tickdir','out','box','off')
    xlabel('VPD (kpa)'); ylabel('Burned area (kha)')
    axis square
    [r,p] = corr(x,log(y));
    title(['r = ' num2str(round(r*100)/100)])
	mdl = fitlm(x,log(y));
	xpred = sort(x);
    [yhat, ci] = predict(mdl,xpred);
    m = mdl.Coefficients.Estimate(2);
    if p <= 0.10
        plot(xpred,exp(yhat),'-k','Color','k','Linewidth',2)
        plot(xpred,exp(ci(:,1)),'--k','Linewidth',1)
        plot(xpred,exp(ci(:,2)),'--k','Linewidth',1)
    end        
    title(['r = ' num2str(round(r*100)/100)])
end

function [r,p] = fireClimateTimeSeries(yr,aab,climate,params)
%%%% Trend and slope, area burned
alpha = 0.10;
[taub tau h1 sig1 Z S sigma sen1 n senplot1 CIlower CIupper D Dall C3] =...
    ktaub([yr' aab],alpha,1); % Sens slope estimator
%%%% Trend and slope, climate
[taub tau h2 sig2 Z S sigma sen2 n senplot2 CIlower CIupper D Dall C3] =...
    ktaub([yr' climate],alpha,1); % Sens slope estimator

[r,p] = corr(climate,log(aab+1)); % Add 1 for correlation

%%%% Plot time series
hold off
plot1 = bar(yr,aab,1,'FaceColor',params.faceColor);
if h1 == 1
    hold on; plot(yr,senplot1(:,2),'--k')
end
ylabel(params.ylabel1)
set(gca,'tickdir','out','box','off')

% if contains(params.legend(1),'Tot')
    yyaxis right
    plot2 = plot(yr,climate,'-k','linewidth',2);
    if h2 == 1
        hold on; plot(yr,senplot2(:,2),'--k')
    end
    set(gca,'ycolor','k','box','off','FontSize',10)
    ylabel(params.ylabel2)
    legend([plot1,plot2],params.legend,'Location','NorthWest')
% else
%     legend([plot1],params.legend,'Location','NorthWest')
% end

xlabel(params.xlabel)
x_lim = get(gca,'xlim'); y_lim = get(gca,'ylim');
if p < alpha
    text(x_lim(1)+0.5*range(x_lim),y_lim(2),...
    ['r = ' num2str(round(r*100)/100)],'FontSize',8,...
    'HorizontalAlignment','Center')
end
title(params.region)
end

function [r,p] = fireAB_Num_TimeSeries(yr,aab,climate,params)
%%%% Trend and slope, area burned
alpha = 0.10;
[taub tau h1 sig1 Z S sigma sen1 n senplot1 CIlower CIupper D Dall C3] =...
    ktaub([yr' aab],alpha,1); % Sens slope estimator
%%%% Trend and slope, climate
[taub tau h2 sig2 Z S sigma sen2 n senplot2 CIlower CIupper D Dall C3] =...
    ktaub([yr' climate],alpha,1); % Sens slope estimator

[r,p] = corr(climate,log(aab+1)); % Add 1 for correlation

%%%% Plot time series
hold off
plot1 = bar(yr,aab,1,'FaceColor',params.faceColor);
if h1 == 1
    hold on; plot(yr,senplot1(:,2),'--k')
end
ylabel(params.ylabel1)
set(gca,'tickdir','out','box','off')

% if contains(params.legend(1),'Tot')
    yyaxis right
    plot2 = plot(yr,climate,'-k','linewidth',2);
    if h2 == 1
        hold on; plot(yr,senplot2(:,2),'--k')
    end
    set(gca,'ycolor','k','box','off','FontSize',10)
    ylabel(params.ylabel2)
    legend([plot1,plot2],params.legend,'Location','NorthWest')
% else
%     legend([plot1],params.legend,'Location','NorthWest')
% end

xlabel(params.xlabel)
x_lim = get(gca,'xlim'); y_lim = get(gca,'ylim');
if p < alpha
    text(x_lim(1)+0.5*range(x_lim),y_lim(2),...
    ['r = ' num2str(round(r*100)/100)],'FontSize',8,...
    'HorizontalAlignment','Center')
end
title(params.region)
end

function [change] = decadalChange2(y1,y2,CData)
fs = 8;
h1 = bar([1 2],[y1; y2],'stacked','FaceColor','Flat');
h1(1).CData = CData(3,:); h1(2).CData = CData(4,:);

xlim([0.25 3])
y_lim = get(gca,'ylim');
set(gca,'xticklabel',' ','tickdir','out','box','off','FontSize',fs+2)
    text(1,0,{'1999-' '2009'},'VerticalAlignment','Top',...
        'HorizontalAlignment','Center','FontSize',fs)
    text(2,0,{'2010-' '2020'},'VerticalAlignment','Top',...
        'HorizontalAlignment','Center','FontSize',fs)

% Calculate change between time periods
change(1) = [y2(1)-y1(1)]/y1(1)*100; % H
change(2) = [y2(2)-y1(2)]/y1(2)*100; % L
change(3) = [sum(y2)-sum(y1)] ./ sum(y1) * 100; % Tot
change = round(change);
    
if change(3) > 0 % Change in total 
    text(2,sum(y2),[num2str(abs(change(3))) '% \uparrow'],...
    'HorizontalAlignment','Center','FontSize',fs,...
    'VerticalAlignment','Bottom')
else
	text(2,sum(y2),[num2str(abs(change(3))) '% \downarrow'],...
    	'HorizontalAlignment','Center','FontSize',fs,...
        	'VerticalAlignment','Bottom')
end
if change(1) > 0    % Change in y1
    text(3,y2(1)*0.5,[num2str(abs(change(1))) '% \uparrow'],...
    'HorizontalAlignment','Center','FontSize',fs)
else
	text(3,y2(1)*0.5,[num2str(abs(change(1))) '% \downarrow'],...
    	'HorizontalAlignment','Center','FontSize',fs)
end
if change(2) > 0    % Change in y2
    text(3,y2(1)+0.5*y2(2),[num2str(abs(change(2))) '% \uparrow'],...
    'HorizontalAlignment','Center','FontSize',fs)
else
	text(3,y2(1)+0.5*y2(2),[num2str(abs(change(2))) '% \downarrow'],...
    	'HorizontalAlignment','Center','FontSize',fs)
end

end

function [change] = decadalChange(y1,y2,CData)
fs = 8;
h1 = bar([1 2],[y1; y2],'stacked','FaceColor','Flat');
h1(1).CData = CData(1,:); h1(2).CData = CData(3,:); h1(3).CData = CData(4,:);

xlim([0.5 2.5])
y_lim = get(gca,'ylim');
set(gca,'xticklabel',' ','tickdir','out','box','off','FontSize',fs+2)
    text(1,0,{'1999-' '2009'},'VerticalAlignment','Top',...
        'HorizontalAlignment','Center','FontSize',fs)
    text(2,0,{'2010-' '2020'},'VerticalAlignment','Top',...
        'HorizontalAlignment','Center','FontSize',fs)
    
% Calculate change between time periods
change(1) = [y2(1)-y1(1)]/y1(1)*100; % U
change(2) = [y2(2)-y1(2)]/y1(2)*100; % H
change(3) = [y2(3)-y1(3)]/y1(3)*100; % L
change(4) = [sum(y2)-sum(y1)] ./ sum(y1) * 100; % Tot
change = round(change);
    
if change(4) > 0 % Change in total 
    text(2,sum(y2),[num2str(abs(change(4))) '% \uparrow'],...
    'HorizontalAlignment','Center','FontSize',fs-2,...
    'VerticalAlignment','Bottom')
else
	text(2,sum(y2),[num2str(abs(change(4))) '% \downarrow'],...
    	'HorizontalAlignment','Center','FontSize',fs-2,...
        	'VerticalAlignment','Bottom')
end
if change(1) > 0    % Change in y1
    text(2,y2(1)*0.5,[num2str(abs(change(1))) '% \uparrow'],...
    'HorizontalAlignment','Center','FontSize',fs-2)
else
	text(2,y2(1)*0.5,[num2str(abs(change(1))) '% \downarrow'],...
    	'HorizontalAlignment','Center','FontSize',fs-2)
end
if change(2) > 0    % Change in y2
    text(2,y2(1)+0.5*y2(2),[num2str(abs(change(2))) '% \uparrow'],...
    'HorizontalAlignment','Center','FontSize',fs-2)
else
	text(2,y2(1)+0.5*y2(2),[num2str(abs(change(2))) '% \downarrow'],...
    	'HorizontalAlignment','Center','FontSize',fs-2)
end
if change(3) > 0    % Change in y3
    text(2,sum(y2(1:2))+0.5*y2(3),[num2str(abs(change(3))) '% \uparrow'],...
    'HorizontalAlignment','Center','FontSize',fs-2)
else
	text(2,sum(y2(1:2))+0.5*y2(3),[num2str(abs(change(3))) '% \downarrow'],...
    	'HorizontalAlignment','Center','FontSize',fs-2)
end

end

