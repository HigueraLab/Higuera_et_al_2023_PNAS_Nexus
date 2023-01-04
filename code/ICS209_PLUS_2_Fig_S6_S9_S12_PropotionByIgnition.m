%% ICS209_PLUS_2_Fig_SI_PropotionByIgnition.m
%
% Requires running ICS209_PLUS_1_LoadDataset.m first
%
% P. Higuera
% 23 Feb. 2022
%
% Creates Figures S6, S9, and S12 in Supporting Information. 
%
%% Plot PROP. AREA BURNED, STRUCTURED DESTROYED, AND PROJECTED IM COSTS
% by ignition type, across space and time
figure(1); clf; set(gcf,'color','w','Units','Centimeters',...
    'Position',[1 1 27 25])
fs = 8;

%%%% Area burned
subplot(331) % 1999-2020
    y = squeeze(nansum(areaBurned(:,:,1:end))); % [ha] i = cause, j = region
    yPlot = [y./nansum(y)]';
    [~, in] = sort(yPlot(:,end));
    h = barh(yPlot(in,:),1,'stacked','FaceColor','Flat','EdgeColor','none');
    h(2).CData = [0.5 0.5 0.5];
    h(1).CData = [0.8 0.5 0];
    h(4).CData = [0.1 0.1 0.8];
    h(3).CData = [0.8 0 0];
    xlim([0 1])
    set(gca,'Ytick',[1:nRegions],'YTicklabel',regionID(in),...
        'TickDir','Out','Box','Off','XTick',[0:0.25:1],'FontSize',fs)
    title({'Prop. area burned: 1999-2020'})
    axis tight
    axis square
    hold on
    for x = [0.25 0.5 0.75]
        plot([x x],[0.5 nRegions+0.5],'k-','Color',[0 0 0])
    end
    legend(fireCauseText,'Location','NorthEast')

subplot(332) % 1999-2020
    y = squeeze(nansum(areaBurned(1:11,:,1:end))); % [ha] i = cause, j = region
    yPlot = [y./nansum(y)]';
    [~, in] = sort(yPlot(:,end));
    h = barh(yPlot(in,:),1,'stacked','FaceColor','Flat','EdgeColor','none');
    h(2).CData = [0.5 0.5 0.5];
    h(1).CData = [0.8 0.5 0];
    h(4).CData = [0.1 0.1 0.8];
    h(3).CData = [0.8 0 0];
    xlim([0 1])
    set(gca,'Ytick',[1:nRegions],'YTicklabel',regionID(in),...
        'TickDir','Out','Box','Off','XTick',[0:0.25:1],...
        'FontSize',fs,'YAxisLocation','Left')
    title({'1999-2009'})
    axis tight
    axis square
    hold on
    for x = [0.25 0.5 0.75]
        plot([x x],[0.5 nRegions+0.5],'k-','Color',[0 0 0])
    end

subplot(333) % 1999-2020
    y = squeeze(nansum(areaBurned(12:end,:,1:end))); % [ha] i = cause, j = region
    yPlot = [y./nansum(y)]';
    [~, in] = sort(yPlot(:,end));
    h = barh(yPlot(in,:),1,'stacked','FaceColor','Flat','EdgeColor','none');
    h(2).CData = [0.5 0.5 0.5];
    h(1).CData = [0.8 0.5 0];
    h(4).CData = [0.1 0.1 0.8];
    h(3).CData = [0.8 0 0];
    xlim([0 1])
    set(gca,'Ytick',[1:nRegions],'YTicklabel',regionID(in),...
        'XTick',[0:0.25:1],'TickDir','Out','Box','Off','FontSize',fs)
    title({'2010-2020'})
    axis tight
    axis square
    hold on
    for x = [0.25 0.5 0.75]
        plot([x x],[0.5 nRegions+0.5],'k-','Color',[0 0 0])
    end
    
%%%%% Structure losss
subplot(334) % 1999-2020
    y = squeeze(nansum(strucLoss(:,:,1:end))); % [ha] i = cause, j = region
    yPlot = [y./nansum(y)]';
    [~, in] = sort(yPlot(:,end));
    h = barh(yPlot(in,:),1,'stacked','FaceColor','Flat','EdgeColor','none');
    h(2).CData = [0.5 0.5 0.5];
    h(1).CData = [0.8 0.5 0];
    h(4).CData = [0.1 0.1 0.8];
    h(3).CData = [0.8 0 0];
    xlim([0 1])
    set(gca,'Ytick',[1:nRegions],'YTicklabel',regionID(in),...
        'TickDir','Out','Box','Off','XTick',[0:0.25:1],'FontSize',fs)
    title({'Prop. structures destroyed: 1999-2020'})
    axis tight
    axis square
    hold on
    for x = [0.25 0.5 0.75]
        plot([x x],[0.5 nRegions+0.5],'k-','Color',[0 0 0])
    end
%     legend(fireCauseText,'Location','NorthEast')

subplot(335) % 1999-2020
    y = squeeze(nansum(strucLoss(1:11,:,1:end))); % [ha] i = cause, j = region
    yPlot = [y./nansum(y)]';
    [~, in] = sort(yPlot(:,end));
    h = barh(yPlot(in,:),1,'stacked','FaceColor','Flat','EdgeColor','none');
    h(2).CData = [0.5 0.5 0.5];
    h(1).CData = [0.8 0.5 0];
    h(4).CData = [0.1 0.1 0.8];
    h(3).CData = [0.8 0 0];
    xlim([0 1])
    set(gca,'Ytick',[1:nRegions],'YTicklabel',regionID(in),...
        'TickDir','Out','Box','Off','XTick',[0:0.25:1],...
        'FontSize',fs,'YAxisLocation','Left')
    title({'1999-2009'})
    axis tight
    axis square
    hold on
    xlabel('Proportion of total')
    for x = [0.25 0.5 0.75]
        plot([x x],[0.5 nRegions+0.5],'k-','Color',[0 0 0])
    end
    
subplot(336) % 1999-2020
    y = squeeze(nansum(strucLoss(12:end,:,1:end))); % [ha] i = cause, j = region
    yPlot = [y./nansum(y)]';
    [~, in] = sort(yPlot(:,end));
    h = barh(yPlot(in,:),1,'stacked','FaceColor','Flat','EdgeColor','none');
    h(2).CData = [0.5 0.5 0.5];
    h(1).CData = [0.8 0.5 0];
    h(4).CData = [0.1 0.1 0.8];
    h(3).CData = [0.8 0 0];
    xlim([0 1])
    set(gca,'Ytick',[1:nRegions],'YTicklabel',regionID(in),...
        'XTick',[0:0.25:1],'TickDir','Out','Box','Off','FontSize',fs)
    title({'2010-2020'})
    axis tight
    axis square
    hold on
    for x = [0.25 0.5 0.75]
        plot([x x],[0.5 nRegions+0.5],'k-','Color',[0 0 0])
    end

%%%% IM Costs
subplot(337) % 1999-2020
    y = squeeze(nansum(IMCosts(:,:,1:end))); % [ha] i = cause, j = region
    yPlot = [y./nansum(y)]';
    [~, in] = sort(yPlot(:,end));
    h = barh(yPlot(in,:),1,'stacked','FaceColor','Flat','EdgeColor','none');
    h(2).CData = [0.5 0.5 0.5];
    h(1).CData = [0.8 0.5 0];
    h(4).CData = [0.1 0.1 0.8];
    h(3).CData = [0.8 0 0];
    xlim([0 1])
    set(gca,'Ytick',[1:nRegions],'YTicklabel',regionID(in),...
        'TickDir','Out','Box','Off','XTick',[0:0.25:1],'FontSize',fs)
    title({'Prop. of projected IM costs: 1999-2020'})
    axis tight
    axis square
    hold on
    for x = [0.25 0.5 0.75]
        plot([x x],[0.5 nRegions+0.5],'k-','Color',[0 0 0])
    end
%     legend(fireCauseText,'Location','NorthEast')

subplot(338) % 1999-2020
    y = squeeze(nansum(IMCosts(1:11,:,1:end))); % [ha] i = cause, j = region
    yPlot = [y./nansum(y)]';
    [~, in] = sort(yPlot(:,end));
    h = barh(yPlot(in,:),1,'stacked','FaceColor','Flat','EdgeColor','none');
    h(2).CData = [0.5 0.5 0.5];
    h(1).CData = [0.8 0.5 0];
    h(4).CData = [0.1 0.1 0.8];
    h(3).CData = [0.8 0 0];
    xlim([0 1])
    set(gca,'Ytick',[1:nRegions],'YTicklabel',regionID(in),...
        'TickDir','Out','Box','Off','XTick',[0:0.25:1],...
        'FontSize',fs,'YAxisLocation','Left')
    title({'1999-2009'})
    axis tight
    axis square
    hold on
    xlabel('Proportion of total')
    for x = [0.25 0.5 0.75]
        plot([x x],[0.5 nRegions+0.5],'k-','Color',[0 0 0])
    end

subplot(339) % 1999-2020
    y = squeeze(nansum(IMCosts(12:end,:,1:end))); % [ha] i = cause, j = region
    yPlot = [y./nansum(y)]';
    [trash, in] = sort(yPlot(:,end));
    h = barh(yPlot(in,:),1,'stacked','FaceColor','Flat','EdgeColor','none');
    h(2).CData = [0.5 0.5 0.5];
    h(1).CData = [0.8 0.5 0];
    h(4).CData = [0.1 0.1 0.8];
    h(3).CData = [0.8 0 0];
    xlim([0 1])
    set(gca,'Ytick',[1:nRegions],'YTicklabel',regionID(in),...
        'XTick',[0:0.25:1],'TickDir','Out','Box','Off','FontSize',fs)
    title({'2010-2020'})
    axis tight
    axis square
    hold on
    for x = [0.25 0.5 0.75]
        plot([x x],[0.5 nRegions+0.5],'k-','Color',[0 0 0])
    end
    
if saveFile == 1
    cd C:\Users\philip.higuera\Box\1_phiguera\1_working\Projects\2021_CIRES_VisitingFellow_Program\ChangingHumanCausesAndCostsOfWesternWildfires\figures
%     fileName = ['ICS209PLUS_Prop_AB_Exposure_Loss_Cost_ByIgnition_' char(spatialDomain) '.jpg'];
    fileName = ['Fig_S6_Prop_AB_Exposure_Loss_Cost_ByIgnition_' char(spatialDomain) '.jpg'];
%     fileName = ['Fig_S9_Prop_AB_Exposure_Loss_Cost_ByIgnition_' char(spatialDomain) '.jpg'];
%     fileName = ['Fig_S12_Prop_AB_Exposure_Loss_Cost_ByIgnition_' char(spatialDomain) '.jpg'];
%     saveas(gcf,fileName)
    exportgraphics(gcf,fileName,'Resolution',300)
    cd C:\Users\philip.higuera\Box\1_phiguera\1_working\Projects\2021_CIRES_VisitingFellow_Program\ChangingHumanCausesAndCostsOfWesternWildfires\code
end
