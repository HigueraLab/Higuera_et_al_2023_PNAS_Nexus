% ICS209_PLUS_2_Fig_StrucLossAsFunctionOfFireSize.m
%
% Requires running ICS209_PLUS_1_LoadDataset.m first
%
% P. Higuera
% 26 Feb. 2022
%
% Creates Fig. 1B from the main text.
%
%% Structrue loss as a function of fire size: extremes 

figure(1); clf; set(gcf,'color','w','Units','Centimeters',...
    'Position',[1 1 15 14]); % OLD SIZE, AS OF APRIL 2022: [1 1 20 10])
fs = 8;
markerCol = [0.6 0.6 0.8; 0 0.4 1; 0.8 0.6 0.6; 0.8 0 0;...
    0.5 0.5 0.5; 0.1 0.1 0.1];
x_lim = [1 1000000];
y_lim = [1 30000];

% idx0 = strcmp(data.STUSPS,'MT'); % Modify this to select a single state.
idx0 = ones(size(data.START_YEAR)); % Modify this to select a single state.
idx1 = data.START_YEAR < 2010;
idx2 = data.START_YEAR >= 2010;
idxL = strcmp(data.CAUSE_UPDATED,'L');  % Lightning ign. 
idxH = strcmp(data.CAUSE_UPDATED,'H'); % Human-related
idxU = logical(strcmp(data.CAUSE_UPDATED,'U') +...
    strcmp(data.CAUSE_UPDATED,'O')); % Undetermined

x1 = data.FINAL_ACRES(find(idx0.*idx1.*idxL)) .*  0.404686; % [ha] L, < 2010
y1 = data.STR_DESTROYED_TOTAL(find(idx0.*idx1.*idxL)); % [#] L, < 2010
x2 = data.FINAL_ACRES(find(idx0.*idx2.*idxL)) .*  0.404686; % [ha] L, >= 2010
y2 = data.STR_DESTROYED_TOTAL(find(idx0.*idx2.*idxL)); % [#] L, >= 2010

x3 = data.FINAL_ACRES(find(idx0.*idx1.*idxH)) .*  0.404686; % [ha] H, < 2010
y3 = data.STR_DESTROYED_TOTAL(find(idx0.*idx1.*idxH)); % [#] H, < 2010
x4 = data.FINAL_ACRES(find(idx0.*idx2.*idxH)) .*  0.404686; % [ha] H, >= 2010
y4 = data.STR_DESTROYED_TOTAL(find(idx0.*idx2.*idxH)); % [#] H, >= 2010

x5 = data.FINAL_ACRES(find(idx0.*idx1.*idxU)) .*  0.404686; % [ha] U, < 2010
y5 = data.STR_DESTROYED_TOTAL(find(idx0.*idx1.*idxU)); % [#] U, < 2010
x6 = data.FINAL_ACRES(find(idx0.*idx2.*idxU)) .*  0.404686; % [ha] U, >= 2010
y6 = data.STR_DESTROYED_TOTAL(find(idx0.*idx2.*idxU)); % [#] U, >= 2010

x7 = data.FINAL_ACRES(find(idx0.*idx1)) .*  0.404686; % [ha] ALL, < 2010
y7 = data.STR_DESTROYED_TOTAL(find(idx0.*idx1)); % [#] ALL, < 2010
x8 = data.FINAL_ACRES(find(idx0.*idx2)) .*  0.404686; % [ha] ALL, >= 2010
y8 = data.STR_DESTROYED_TOTAL(find(idx0.*idx2)); % [#] ALL, >= 2010
y9 = data.STR_DESTROYED_TOTAL; % [#] ALL, ALL

% Plot 99th percentiles:
hold on
plot(x_lim,[prctile(y1,99) prctile(y1,99)],'-k','Color',markerCol(1,:))
plot(x_lim,[prctile(y2,99) prctile(y2,99)],'-k','Color',markerCol(2,:))
plot(x_lim,[prctile(y3,99) prctile(y3,99)],'-k','Color',markerCol(3,:))
plot(x_lim,[prctile(y4,99) prctile(y4,99)],'-k','Color',markerCol(4,:))
% plot(x_lim,[prctile(y9,99.9) prctile(y9,99.9)],'-k','LineWidth',2)
plot(x_lim,[prctile(y7,99.9) prctile(y7,99.9)],'-k','LineWidth',2)
plot(x_lim,[prctile(y8,99.9) prctile(y8,99.9)],'-k','LineWidth',2)

% Plot individual fires:
p1 = loglog(x1+1,y1,'ok','MarkerFaceColor',markerCol(1,:),...
    'MarkerEdgeColor',markerCol(1,:));
hold on
p2 = loglog(x2+1,y2,'ok','MarkerFaceColor',markerCol(2,:),...
    'MarkerEdgeColor',markerCol(2,:));
p3 = loglog(x3+1,y3,'sk','MarkerFaceColor',markerCol(3,:),...
    'MarkerEdgeColor',markerCol(3,:));
p4 = loglog(x4+1,y4,'sk','MarkerFaceColor',markerCol(4,:),...
    'MarkerEdgeColor',markerCol(4,:));

p5 = loglog(x5+1,y5,'.k','MarkerFaceColor',markerCol(5,:),...
    'MarkerEdgeColor',markerCol(5,:));
p6 = loglog(x6+1,y6,'.k','MarkerFaceColor',markerCol(6,:),...
    'MarkerEdgeColor',markerCol(6,:));

% 99th percentile text:
text(x_lim(1),prctile(y9,99.9),'  99.9^t^h percentile, all fires',...
	'VerticalAlignment','Bottom','FontSize',fs)
text(x_lim(1),prctile(y2,99),'  99^t^h percentile, lightning',...
	'VerticalAlignment','Bottom','FontSize',fs)
text(x_lim(1),prctile(y4,99),'  99^t^h percentile, human-related',...
	'VerticalAlignment','Bottom','FontSize',fs)

% Plot Marshall Fire
text(15000,1200,'2021 Marshall Fire, CO  ','HorizontalAlignment','Right',...
    'VerticalAlignment','Bottom','FontSize',fs-2)
plot(6000,1000,'^k','MarkerFaceColor',markerCol(4,:),'MarkerEdgeColor',...
    markerCol(4,:))

% Label top 10 fires
[temp idx] = sort(data.STR_DESTROYED_TOTAL,'descend');
text(data.FINAL_ACRES(idx(1:10))*0.5,data.STR_DESTROYED_TOTAL(idx(1:10)),...
    data.INCIDENT_NAME(idx(1:10)),'FontSize',fs-2)

%%%% Full info. on the top five fires: 
% data(idx(1:5),:)


% Legend text
legTxt_L1 = ['Lightning, 1999-2009: ' num2str(round(nansum(y1)/nansum(y7)*100)) '% of fires w/ struc loss'];
legTxt_L2 = ['Lightning, 2010-2020: ' num2str(round(nansum(y2)/nansum(y8)*100)) '% of fires w/ struc loss'];
legTxt_H1 = ['Human-related, 1999-2009: ' num2str(round(nansum(y3)/nansum(y7)*100)) '% of fires w/ struc loss'];
legTxt_H2 = ['Human-related, 2010-2020: ' num2str(round(nansum(y4)/nansum(y8)*100)) '% of fires w/ struc loss'];
legTxt_U1 = ['Undetermined, 1999-2009: ' num2str(round(nansum(y5)/nansum(y7)*100)) '% of fires w/ struc loss'];
legTxt_U2 = ['Undetermined, 2010-2020: ' num2str(round(nansum(y6)/nansum(y8)*100)) '% of fires w/ struc loss'];

% Axis properties
legendText = {legTxt_L1, legTxt_L2, legTxt_H1, legTxt_H2, legTxt_U1,...
    legTxt_U2};

legend([p1 p2 p3 p4 p5 p6],legendText,'Location','NorthWest',...
    'FontSize',fs)
xlim(x_lim)
ylim(y_lim)
xlabel('Fire size (ha)')
ylabel('Structures destroyed (#)')
title('Structure loss as a function of individual fire size, and changing extremes')
grid off
set(gca,'tickdir','out','box','off','xscale','log','yscale','log',...
    'FontSize',fs)
% axis square

if saveFile == 1
	cd C:\Users\philip.higuera.UM\Box\2_lab_SHARE\4_archivedData\Higuera_et_al_2023_PNAS_Nexus\figures
    fileName = ['ICS209_FireSizeAndStrucLossChangingExtremes.jpg'];
    saveas(gcf,fileName)
	cd C:\Users\philip.higuera.UM\Box\2_lab_SHARE\4_archivedData\Higuera_et_al_2023_PNAS_Nexus\code
end 
