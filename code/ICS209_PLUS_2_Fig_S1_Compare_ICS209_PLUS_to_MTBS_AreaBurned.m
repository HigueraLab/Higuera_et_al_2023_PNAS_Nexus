%% ICS209_PLUS_2_Fig_SI_FireClimateRelationships.m
%
% Requires running ICS209_PLUS_1_LoadDataset.m first
%
% P. Higuera
% 26 Feb. 2022
%
% UPDATED June 2022: replaced MTBS+ data from Higuera and Abatzoglou (2021)
% with updated MTBS data, through 2020.
%
% Creates Fig. S1 in Supporting Information.
%
%% Compare_ICS209_PLUS_to_MTBS_AreaBurned.m
data = [
1999	1340	1166
2000	1869	1526
2001	850     665
2002	1427	1213
2003	1204	954
2004	364     258
2005	1216	1174
2006	2309	2023
2007	2538	2315
2008	977     859
2009	593     481
2010	519     430
2011	1551	1654
2012	2844	3042
2013	1043	896
2014	1078	892
2015	1710	1455
2016	1070	952
2017	2751	2369
2018	2527	2444
2019	609     478
2020	3852	2504]; % Year, ICS209-PLUS (kha), MTBS (kha) from Higuera 
% and Abatzoglou 2021

%% Load and summarize MTBS data, 1999-2020
%%%% Replace MTBS from Higuera and Abatzoglou 2021 with these values (all
%%%% from MTBS): 

mtbs = readtable('C:\Users\philip.higuera.UM\Box\2_lab_SHARE\4_archivedData\Higuera_et_al_2023_PNAS_Nexus\data\MTBS\mtbs_western_wildfire_events_1999to2020.csv');
mtbs_yr = [1999:2020]; % [yr]
mtbs_aab = NaN(length(mtbs_yr),1); % [kha] Annual area burned, West-wide

for i = 1:length(mtbs_yr)
    idx = find(mtbs.Ig_Year == mtbs_yr(i));
    mtbs_aab(i) = sum(mtbs.BurnBndAc(idx)) * 0.404686 / 1000; % [kha]
end

data(:,3) = mtbs_aab; % [kha]

%% Figure
figure(1); clf; set(gcf,'color','w','units','centimeters',...
    'position',[5 5 25 10])

subplot(121)
plot(data(:,1),data(:,2),'-b')
hold on
plot(data(:,1),data(:,3),'-k')
axis square
xlabel('Year')
ylabel('Area burned (kha)')
legend('ICS209-PLUS','MTBS')
grid on
box off
xlim([1998 2021])
ylim([250 5000])
legend('ICS209-PLUS','MTBS','location','northwest')
set(gca,'tickdir','out','yscale','log','ytick',[250 500 1000 2000 4000])
title('A')

subplot(122)
x = data(:,2);
y = data(:,3);
plot(x,y,'ok','MarkerFaceColor',[0.75 0.75 0.75])
hold on
mdl = fitlm(log(x),log(y));
	xpred = sort(log(x));
    [yhat, ci] = predict(mdl,xpred);
	plot(exp(xpred),exp(yhat),'-k','Color','k','Linewidth',2)
[r p] = corr(log(x),log(y));
ylim([250 5000]);
xlim([250 5000])
x_lim = get(gca,'xlim'); y_lim = get(gca,'ylim');
plot(x_lim,y_lim,'k--')
axis square
grid on
for i = [2012 2015 2017 2018 2020]
    idx = find(data(:,1) == i);
    text(data(idx,2),data(idx,3),['   ' num2str(i)])
end
box off
xlabel('Annual area burned, ICS209-PLUS (kha)')
ylabel('Annual area burned, MTBS (kha)')
text(275, 2750,['r = ' num2str(round(r*100)/100)])
set(gca,'tickdir','out','xscale','log','yscale','log',...
    'xtick',[250 500 1000 2000 4000],...
    'ytick',[250 500 1000 2000 4000])
title('B')
