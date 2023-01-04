%% ICS209_PLUS_2_Fig_SI_FireClimateRelationships.m
%
% Requires running ICS209_PLUS_1_LoadDataset.m first
%
% P. Higuera
% 26 Feb. 2022
%
% Annotated, Jan. 2023: Figures created here are not used in the
% manuscript, but the slope of the relationship between log(aab) and
% annual climate (m) can be saved as "fireClimate_m_STUSPS.mat" (see line 
% 242). This value is used in Fig. 4F in the main text (sensitivity to 
% year-of climate).

%% Plot FIRE-CLIMATE RELATIONSHIPS by ignition type
fs = 8;
r_aab_vpd = NaN(nRegions,3,2); % i = region, j = non-lighting, lighning, total
    % k = year of, antecedent cliamte
m = NaN(nRegions,3,2); % Slope estimate from regression 
mSE = NaN(nRegions,3,2); % Standard error for slope estimate from regression 
p = NaN(nRegions,3,2); % P-value from correlation
for i = 1:nRegions
figure(100+i); clf; set(gcf,'color','w','Units','Centimeters','Position',...
    [2 -8 36 22])

%%%% Total area burned
subplot(3,7,[3:5])
aab = nansum(areaBurned(:,1:4,i),2) ./ 1000; % [ha x 1000]
if i < nRegions
    climate = vpdRegion(:,i);
else
    climate = WestWideVPD;
end
params.faceColor = [0.5 0.5 0.5];
params.xlabel = {''};
params.ylabel1 = {'Area burned (kha)'};
params.ylabel2 = {'VPD (kpa)'};
params.legend = {'Tot. area burned','June-Aug. VPD'};
params.region = regionID(i);
[h1] = fireClimateTimeSeries(yr,aab,climate(2:end),params);

subplot(3,7,1)
[r_aab_vpd(i,3,2), m(i,3,2), mSE(i,3,2), p(i,3,2)] = fireClimateCorr(climate(1:end-1),aab);

subplot(3,7,7)
[r_aab_vpd(i,3,1), m(i,3,1), mSE(i,3,1), p(i,3,1)] = fireClimateCorr(climate(2:end),aab);

%%%%% Lightning area burned only
subplot(3,7,[10:12])
aab = (1+nansum(areaBurned(:,4,i),2)) ./ 1000; % [ha x 1000]
params.faceColor = [0.8 0 0];
params.legend = {'Lightning area burned','June-Aug. VPD'};
params.region = {' '};
[h1] = fireClimateTimeSeries(yr,aab,climate(2:end),params);

subplot(3,7,8)
[r_aab_vpd(i,2,2), m(i,2,2), mSE(i,2,2), p(i,2,2)] = fireClimateCorr(climate(1:end-1),aab);

subplot(3,7,14)
[r_aab_vpd(i,2,1), m(i,2,1), mSE(i,2,1), p(i,2,1)] = fireClimateCorr(climate(2:end),aab);

%%%%% Non-lightning area burned only
subplot(3,7,[17:19])
aab = (1+nansum(areaBurned(:,1:3,i),2)) ./ 1000; % [ha x 1000]
params.faceColor = [0 0 0.8];
params.legend = {'Human-casued area burned','June-Aug. VPD'};
params.region = {' '};
params.xlabel = {'Year'};
[h1] = fireClimateTimeSeries(yr,aab,climate(2:end),params);

subplot(3,7,15)
[r_aab_vpd(i,1,2), m(i,1,2), mSE(i,1,2), p(i,1,2)] = fireClimateCorr(climate(1:end-1),aab);

subplot(3,7,21)
[r_aab_vpd(i,1,1), m(i,1,1), mSE(i,1,1), p(i,1,1)] = fireClimateCorr(climate(2:end),aab);


if saveFile == 1
	cd C:\Users\philip.higuera.UM\Box\2_lab_SHARE\4_archivedData\Higuera_et_al_2023_PNAS_Nexus\figures
    fileName = ['ICS209_FireClimateRelationships_' char(spatialDomain) '_' char(regionID(i)) '.jpg'];
    saveas(gcf,fileName)
	cd C:\Users\philip.higuera.UM\Box\2_lab_SHARE\4_archivedData\Higuera_et_al_2023_PNAS_Nexus\code
end 

end

%% PLOT FIRE-CLIMATE CORRELATION BY REGION
figure(150); clf; set(gcf,'color','w','position',[52 0 1020 730])

subplot(221)
[~,in] = sort(r_aab_vpd(:,3,1));
patch([0 0.35 0.35 0],[0.5 0.5 nRegions+0.5 nRegions+0.5],'w',...
    'FaceColor',[0.9 0.9 0.9],'EdgeColor','none')
hold on
h1 = plot(r_aab_vpd(in,3,1),[1:nRegions],'ok','MarkerFaceColor',[0.5 0.5 0.5]);
h2 = plot(r_aab_vpd(in,2,1),[1:nRegions],'ok','MarkerFaceColor',...
    [0.8 0 0],'MarkerSize',4);
h3 = plot(r_aab_vpd(in,1,1),[1:nRegions],'ok','MarkerFaceColor',...
    [0 0 0.8],'MarkerSize',4);
legend([h1,h2,h3],'Tot.','Light.-caused','Human-caused','Location','SouthEast')
ylim([0 nRegions+1])
xlim([0 1])
set(gca,'ytick',[1:nRegions],'yticklabel',regionID(in))
axis square; grid on
xlabel('Correlation (r)')
title('Tot. annual area burned -- VPD correlation')

subplot(222)
plot(r_aab_vpd(:,2,1),r_aab_vpd(:,1,1),'ok','MarkerFaceColor',[0.5 0.5 0.5])
hold on
plot([0 1],[0 1],'k')
for i = 1:nRegions
    text(r_aab_vpd(i,2,1)+0.05,r_aab_vpd(i,1,1),regionID(i))
end
xlabel({'Fire-climate correlation,' 'lighting area burned (r)'})
ylabel({'Fire-climate correlation,' 'H, U  area burned (r)'})
grid on
axis square
title('Ann. area burned - VPD corr., by igntion source')

subplot(223)
[~,in] = sort(r_aab_vpd(:,3,2));
patch([-0.35 0.35 0.35 -0.35],[0.5 0.5 nRegions+0.5 nRegions+0.5],'w',...
    'FaceColor',[0.9 0.9 0.9],'EdgeColor','none')
hold on
h1 = plot(r_aab_vpd(in,3,2),[1:nRegions],'ok','MarkerFaceColor',[0.75 0.75 0.75]);
h2 = plot(r_aab_vpd(in,2,2),[1:nRegions],'ok','MarkerFaceColor',[0.8 0 0],...
    'MarkerSize',4);
h3 = plot(r_aab_vpd(in,1,2),[1:nRegions],'ok','MarkerFaceColor',[0 0 0.8],...
    'MarkerSize',4);
legend([h1 h2 h3],'Tot.','Light.-caused','Human-caused','Location','NorthWest')

ylim([0 nRegions+1])
xlim([-1 1])
set(gca,'ytick',[1:nRegions],'yticklabel',regionID(in))
axis square; grid on
xlabel('Correlation (r)')
title('Tot. annual area burned -- prior yr. VPD correlation')

subplot(224)
plot(abs(r_aab_vpd(:,2,1)),abs(r_aab_vpd(:,2,2)),'ok','MarkerFaceColor',[0.5 0.5 0.5])
hold on
xlim([0 1]); ylim([0 1])
for i = 1:nRegions
    text(abs(r_aab_vpd(i,2,1))+0.05,abs(r_aab_vpd(i,2,2)),regionID(i))
end
xlabel({'|r| (year of)'})
ylabel({'|r| (lag 1)'})
grid on
axis square
title('Climate- vs. fule-limited fire-regime space')

% subplot(224)
% plot(r_aab_vpd(:,2,2),r_aab_vpd(:,1,2),'ok','MarkerFaceColor',[0.5 0.5 0.5])
% hold on
% plot([-1 1],[-1 1],'k')
% for i = 1:nRegions-1
%     text(r_aab_vpd(i,2,2)+0.01,r_aab_vpd(i,1,2),regionID(i))
% end
% xlabel('Fire-climate correlation, lighting area burned (r)')
% ylabel('Fire-climate correlation, H, U  area burned (r)')
% grid on
% axis square
% title('Ann. area burned - prior yr. VPD corr., by igntion source')

if saveFile == 1
	cd C:\Users\philip.higuera.UM\Box\2_lab_SHARE\4_archivedData\Higuera_et_al_2023_PNAS_Nexus\figures
    fileName = ['ICS209_FireClimateCorrelations_' char(spatialDomain) '.jpg'];
    saveas(gcf,fileName)
	cd C:\Users\philip.higuera.UM\Box\2_lab_SHARE\4_archivedData\Higuera_et_al_2023_PNAS_Nexus\code
end 

%% PLOT FIRE-CLIMATE SLOPE BY REGION
figure(151); clf; set(gcf,'color','w','position',[52 0 1020 730])
mPlot = exp(m); % Exponentiate slope, for interpretation of kha/kpa
idx = (p <= 0.10);
% mPlot = mPlot .* idx;

subplot(221)
[~,in] = sort(mPlot(:,3,1));
plot(mPlot(in,3,1),[1:nRegions],'ok','MarkerFaceColor',[0.5 0.5 0.5])
hold on
plot(mPlot(in,2,1),[1:nRegions],'ok','MarkerFaceColor',[0.8 0 0],'MarkerSize',4)
plot(mPlot(in,1,1),[1:nRegions],'ok','MarkerFaceColor',[0 0 0.8],'MarkerSize',4)

idx = (p(:,:,1) > 0.05);
plot(mPlot(in),[1:nRegions],'sk')

legend('Tot.','Light.-caused','Human-caused','Location','SouthEast')
ylim([0 nRegions+1])
set(gca,'ytick',[1:nRegions],'yticklabel',regionID(in),'xscale','log')
axis square; grid on
xlabel('Slope (kha / kpa)')
title('Sensitivity of area burned to seasonal climate')

subplot(222)
plot(mPlot(:,2,1),mPlot(:,1,1),'ok','MarkerFaceColor',[0.5 0.5 0.5])
hold on
plot([1 10000],[1 10000],'k')
for i = 1:nRegions
    text(mPlot(i,2,1)+0.05,mPlot(i,1,1),regionID(i))
end
xlabel({'Sensitivity to climate,' 'lighting area burned (kha /  kpa)'})
ylabel({'Sensitivity to climate,' 'H, U  area burned  (kha /  kpa)'})
set(gca,'xscale','log','yscale','log')
grid on
axis square
title('Ann. area burned - VPD corr., by igntion source')

subplot(223)
[~,in] = sort(mPlot(:,3,2));
plot(mPlot(in,3,2),[1:nRegions],'ok','MarkerFaceColor',[0.5 0.5 0.5])
hold on
plot(mPlot(in,2,2),[1:nRegions],'ok','MarkerFaceColor',[0.8 0 0],'MarkerSize',4)
plot(mPlot(in,1,2),[1:nRegions],'ok','MarkerFaceColor',[0 0 0.8],'MarkerSize',4)
plot([1 1],[0 nRegions+1],'k')
legend('Tot.','Light.-caused','Human-caused','Location','NorthWest')
ylim([0 nRegions+1])
% xlim([-1 1])
set(gca,'ytick',[1:nRegions],'yticklabel',regionID(in),'xscale','log')
axis square; grid on
xlabel('Slope (kha / kpa)')
title('Sensitivity of area burned to prior-yr climate')

subplot(224)
plot(abs(mPlot(:,2,1)),abs(mPlot(:,2,2)),'ok','MarkerFaceColor',[0.5 0.5 0.5])
hold on
% xlim([0 1]); ylim([0 1])
for i = 1:nRegions
    text(abs(mPlot(i,2,1))+0.05,abs(mPlot(i,2,2)),regionID(i))
end
xlabel({'|r| (year of)'})
ylabel({'|r| (lag 1)'})
set(gca,'xscale','log','yscale','log')
grid on
axis square
title('Climate- vs. fule-limited fire-regime space')

if saveFile == 1
    
end 

%% Save variables m, p, and r_aab_vpd manually, 
% as "fireClimate_m_STUSPS.mat", etc.
%
% Last saved: 11 March, 2022

%% LOCAL FUNCTIONS

function [r, m, mSE, p] = fireClimateCorr(x,y)
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
    mSE = mdl.Coefficients.SE(2);
    
    if p <= 0.10
        plot(xpred,exp(yhat),'-k','Color','k','Linewidth',2)
        plot(xpred,exp(ci(:,1)),'--k','Linewidth',1)
        plot(xpred,exp(ci(:,2)),'--k','Linewidth',1)
    end        
    title(['r = ' num2str(round(r*100)/100)])
end

function [h1] = fireClimateTimeSeries(yr,aab,climate,params)
%%%% Trend and slope, area burned
alpha = 0.10;
[taub tau h1 sig1 Z S sigma sen1 n senplot1 CIlower CIupper D Dall C3] =...
    ktaub([yr' aab],alpha,1); % Sens slope estimator
%%%% Trend and slope, climate
[taub tau h2 sig2 Z S sigma sen2 n senplot2 CIlower CIupper D Dall C3] =...
    ktaub([yr' climate],alpha,1); % Sens slope estimator

%%%% Plot time series
hold off
plot1 = bar(yr,aab,1,'FaceColor',params.faceColor);
if h1 == 1
    hold on; plot(yr,senplot1(:,2),'--k')
end
ylabel(params.ylabel1)
set(gca,'tickdir','out','box','off')
yyaxis right
plot2 = plot(yr,climate,'-k','linewidth',2);
if h2 == 1
    hold on; plot(yr,senplot2(:,2),'--k')
end
set(gca,'ycolor','k','box','off','FontSize',10)
ylabel(params.ylabel2)
xlabel(params.xlabel)
legend([plot1,plot2],params.legend,'Location','NorthWest')
title(params.region)

end