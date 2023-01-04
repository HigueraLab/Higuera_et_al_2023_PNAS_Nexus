% ICS209_PLUS_2_Fig_CorelatesOfSturctureLoss.m
%
% Requires running ICS209_PLUS_1_LoadDataset.m first
%
% P. Higuera
% 23 Feb. 2022
% Updated 11 March, 2022, to separate out "undetermined" and "other"
% ignitions sources explicilty. 
%
% Creates Figure 5 in the main texx and Figure S2 in supporting
% information. 
%
%% Plot primary figure: Correlates of structure loss
fs = 8;

figure(1); clf; set(gcf,'color','w','Units','Centimeters',...
    'Position',[3 5 27 8.25])

mColor = [0.5 0.5 0.5]; % Color for all years combined
mColor1 = [0.75 0.75 0.75]; % Color for first 1/2 of the dataset
mColor2 = [0.25 0.25 0.25]; % Color for secdon 1/2 of the dataset

%%%% ANNUAL STRUCTURE LOSS as a function of NON-LIGHTNING AREA BURNED
subplot(131)
% x = sum(squeeze(areaBurned(:,1:3,end)),2) ./ 1000; % [kha] annual area burned
%     % from non-lightning ignitions. 
x = sum(squeeze(areaBurned(:,3,end)),2) ./ 1000; % [kha] annual area burned
    % from H ignitions. 
y = sum(squeeze(strucLoss(:,:,end)),2); % [#] annual strcuture loss
[r p] = corr(log(x),log(y));
mdl = fitlm(log(x),log(y));
	xpred = sort(log(x));
    m = mdl.Coefficients.Estimate(2);
    b = mdl.Coefficients.Estimate(1);
	[yhat, ci] = predict(mdl,xpred);
hold on
plot(exp(xpred),exp(yhat),'-k','Linewidth',2)
plot(exp(xpred),exp(ci(:,1)),'--k','Linewidth',1,'Color',mColor)
plot(exp(xpred),exp(ci(:,2)),'--k','Linewidth',1,'Color',mColor)     
h1 = plot(x(1:11),y(1:11),'ok','MarkerSize',4,'MarkerFaceColor',mColor1);
h2 = plot(x(12:end),y(12:end),'ok','MarkerSize',4,'MarkerFaceColor',mColor2);
set(gca,'xscale','log','yscale','log','tickdir','out','FontSize',fs,...
    'xtick',[100 200 400 800 1600])
x_lim = get(gca,'xlim'); y_lim = get(gca,'ylim');
text(x_lim(1)*1.5,y_lim(2)*1,['r^2 = ' num2str(round(r^2*100)/100)],...
    'FontSize',fs)
% text(x_lim(1)*1.5,y_lim(2)*0.15,['m = ' num2str(round(m*10)/10)],...
%     'FontSize',fs)
% text(x_lim(1)*1.5,y_lim(2)*0.4,['y = ' num2str(round(exp(b)*100)/100) 'x exp(' num2str(round(exp(m)*100)/100) ')'],...
%     'FontSize',fs)
for i = [2017 2018 2020]
    idx = find(yr == i);
    if i < 2020
        text(x(idx)*0.9,y(idx),num2str(i),'FontSize',fs-2,...
            'HorizontalAlignment','Right')
    else
        text(x(idx)*1.1,y(idx),num2str(i),'FontSize',fs-2)
    end
end
% xlabel({'Annual area burned, human-related' '& undetermined ign. (kha)'})   
xlabel({'Annual area burned,' 'human-related ign. (kha)'})   
ylabel('Annual structure loss (#)')
xlim([100 1800])
ylim([100 50000])
grid on
axis square
legend([h1 h2],'1999-2009','2010-2020','Location','SouthEast','FontSize',...
    fs-2)
title('A                                                  ','FontSize',12)

%%%% TOTAL 21st CENTURY STRUCTURE LOSS as a func. of STRUCTURE ABUNDANCE
subplot(132)
% Correlation and regression:
x = strucInBurnableCover ./ 1000; % [Structures in burnable land cover (# x 1000)]
y = squeeze(sum(nansum(strucLoss(:,:,1:end-1)))); % [# x 1000] Stuctures destroyed
[r p] = corr(log(x),log(y));
mdl = fitlm(log(x),log(y));
    m = mdl.Coefficients.Estimate(2);
	b = mdl.Coefficients.Estimate(1);
	xpred = sort(log(x));
    [yhat, ci] = predict(mdl,xpred);
% Plot
x_lim = [50 2000];
y_lim = [100 100000];
hold on
set(gca,'xscale','log','yscale','log','FontSize',fs)
plot(exp(xpred),exp(yhat),'-k','Color',[0 0 0],'Linewidth',2)
plot(exp(xpred),exp(ci(:,1)),'--k','Linewidth',1,'Color',mColor)
plot(exp(xpred),exp(ci(:,2)),'--k','Linewidth',1,'Color',mColor)
plot(x,y,'ok','MarkerFaceColor',mColor,'MarkerSize',4)
text(x_lim(1)*1.5,y_lim(2)*0.25,['r^2 = ' num2str(round(r^2*100)/100)],...
    'FontSize',fs)
% text(x_lim(1)*1.5,y_lim(2)*0.15,['m = ' num2str(round((m)*10)/10)],...
%     'FontSize',fs)
% text(x_lim(1)*1.5,y_lim(2)*0.4,['y = ' num2str(round(b*100)/100) 'x exp(' num2str(round(m*100)/100) ')'],...
%     'FontSize',fs)
for i = 1:nRegions-1
    text(x(i).*1.08,y(i),regionID(i),'FontSize',fs-2)
end
set(gca,'xscale','log','yscale','log','tickdir','out','FontSize',fs,...
    'xtick',[50 100 200 400 800 1600])
box off; grid on; axis square
xlim(x_lim); ylim(y_lim)
xlabel({'Structures in flammable veg.' '(# x 1000)'})
ylabel({'Total structures destroyed (#)'})
title('B                                                  ','FontSize',12)

%%%%% AREA BURNED FROM HUMAN-RELATED IGN. as a function of STRUCTURE ABUNDANCE
% y, for area burned from lightning ignition, to compare to human-related
% ignitions. Correlation with lightning ignition is not signifciant: r =
% 0.134, p = 0.6949. *11 March, 2022* 
%  y = squeeze(nansum(areaBurned(:,4,1:end-1)))...
%       ./ burnableArea(1:end-1); % Lightning ab
% [r p] = corr(log(x),log(y));
%
% Correlation and linear regression:
x = strucInBurnableCover ./ 1000; % [# structures x 1000]
% y = squeeze(sum(nansum(areaBurned(:,1:3,1:end-1)))) ./ 1000; % [kha] O, U, and H 
y = squeeze(nansum(areaBurned(:,3,1:end-1))) ./ 1000; % [kha] H only
% y = squeeze(nansum(areaBurned(:,4,1:end-1))) ./ 1000; % [kha] L only

% Area burned from all non-lightning-caused ignitions.
[r p] = corr(log(x),log(y));
mdl = fitlm(log(x),log(y));
	xpred = sort(log(x));
    [yhat, ci] = predict(mdl,xpred);
% Plot:
subplot(133)
hold on
plot(exp(xpred),exp(yhat),'-k','Color',[0 0 0],'Linewidth',2)
plot(exp(xpred),exp(ci(:,1)),'--k','Linewidth',1,'Color',mColor)
plot(exp(xpred),exp(ci(:,2)),'--k','Linewidth',1,'Color',mColor)
plot(x,y,'ok','MarkerFaceColor',mColor,'MarkerSize',4)
set(gca,'xscale','log','yscale','log','tickdir','out','FontSize',fs,...
    'xtick',[50 100 200 400 800 1600],...
    'ytick',[250 500 1000 2000 4000])
xlim([50 2000]); ylim([150 4000])
x_lim = get(gca,'xlim'); y_lim = get(gca,'ylim');
text(x_lim(1)*1.5,y_lim(2)*0.5,['r = ' num2str(round(r*100)/100)],...
    'FontSize',fs)
for i = 1:nRegions-1
	text(x(i).*1.1,y(i),regionID(i),'FontSize',fs-2)
end
box off; grid on; axis square
% ylabel({'Tot. area burned, human-related' '& undetermined ign. (kha)'})
ylabel({'Tot. area burned,' 'human-related ign. (kha)'})
xlabel({'Structures in flammable veg.' '(# x 1000)'})
title('C                                                  ','FontSize',12)

%% Plot appendix figure: Correlates of projected IM costs
fs = 8;

figure(2); clf; set(gcf,'color','w','Units','Centimeters',...
    'Position',[3 5 10 7.25])

mColor = [0.5 0.5 0.5]; % Color for all years combined
mColor1 = [0.75 0.75 0.75]; % Color for first 1/2 of the dataset
mColor2 = [0.25 0.25 0.25]; % Color for secdon 1/2 of the dataset

%%%% POJECTED IM COSTS as a function of ANNUAL STRUCTURE LOSS
x = sum(squeeze(strucLoss(:,:,end)),2); % [#] annual strcuture loss
y = sum(squeeze(IMCosts(:,1:3,end)),2); % [US$] annual projected IM costs. 
[r p] = corr(log(x),log(y));
mdl = fitlm(log(x),log(y));
	xpred = sort(log(x));
    m = mdl.Coefficients.Estimate(2);
    b = mdl.Coefficients.Estimate(1);
	[yhat, ci] = predict(mdl,xpred);
hold on
plot(exp(xpred),exp(yhat),'-k','Linewidth',2)
plot(exp(xpred),exp(ci(:,1)),'--k','Linewidth',1,'Color',mColor)
plot(exp(xpred),exp(ci(:,2)),'--k','Linewidth',1,'Color',mColor)     
h1 = plot(x(1:11),y(1:11),'ok','MarkerSize',4,'MarkerFaceColor',mColor1);
h2 = plot(x(12:end),y(12:end),'ok','MarkerSize',4,'MarkerFaceColor',mColor2);
set(gca,'xscale','log','yscale','log','tickdir','out','FontSize',fs)
x_lim = get(gca,'xlim'); y_lim = get(gca,'ylim');
text(x_lim(1)*1.5,y_lim(2)*0.25,['r^2 = ' num2str(round(r^2*100)/100)],...
    'FontSize',fs)
% text(x_lim(1)*1.5,y_lim(2)*0.15,['m = ' num2str(round(m*10)/10)],...
%     'FontSize',fs)

for i = [2017 2018 2020]
    idx = find(yr == i);
    if i < 2018
        text(x(idx)*0.9,y(idx),num2str(i),'FontSize',fs-2,...
            'HorizontalAlignment','Right')
    else
        text(x(idx)*1.1,y(idx),num2str(i),'FontSize',fs-2)
    end
end
xlabel('Annual structure loss (#)')   
ylabel('Annual projected IM costs (US $)')
xlim([100 35000])
ylim([100 2500])
grid on
axis square
legend([h1 h2],'1999-2009','2010-2020','Location','SouthEast','FontSize',...
    fs-2)

%%  Save file
if saveFile == 1
    cd C:\Users\philip.higuera.UM\Box\2_lab_SHARE\4_archivedData\Higuera_et_al_2023_PNAS_Nexus\figures
    fileName = ['Fig_PredictorsOfStrucureLoss_WEST.jpg'];
    saveas(gcf,fileName)
    cd C:\Users\philip.higuera.UM\Box\2_lab_SHARE\4_archivedData\Higuera_et_al_2023_PNAS_Nexus\code
end
