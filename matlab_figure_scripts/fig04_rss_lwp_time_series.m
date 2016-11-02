function fig04_rss_lwp_time_series(saveFigure)
%%
% FIG04_RSS_LWP_TIME_SERIES(SAVEFIGURE) generates Fig. 04
% 
% *FIG. 4:* Global LWP time series for RSS satellite retrievals (dashed
% lines) and hindcasts (solid lines). 
%
%  SAVEFIGURE:  (logical) default - false
%   optionally saves fig04.eps to ../figs directory
%

%% Comparison of REMSS Daily CWP products for July 2013
% Daily data was accessed from http://www.remss.com on 29 Jan 2016. Here we
% compare AM3 and GFS hindcasts of LWP over the ocean to daily global
% (area-weighted) averages from 4 satellite products: 
% 
% * AMSR2
% * SSMIS 
% * TMI
% * WindSat
% 
%

%% 
addpath helper_functions

if ~exist('saveFigure','var')
    saveFigure = false;
end

load ../data/fig04_daily_lwp_data.mat

%% Globally-averaged LWP time series
% Daily time series of globally-averaged (area-weighted) daily mean cloud
% liquid water path. For a more detailed look at the satellite global
% statistics, see
% <http://www.atmos.uw.edu/~cjones/private/cpt/remss_lwp/remss_cloud_statistics.html
% here>.  
%
% Model output is shown in solid lines, satellite data with dashed lines.
% The GFS TWP approaches the lower bound of LWP from the satellites, but
% the LWP is underestimated by more than a factor of 2. For 0-24 hr
% forecasts and 24-48 hr forecasts, the GFS LWP is remarkably consistent
% (moreso than the TWP, suggesting that most of the cloud "drift" in the
% GFS from 1-2 days is due to high clouds. 
%
% AM3 also substantially underpredicts LWP relative to all satellites.
% Furthermore, the globally averaged 24-48 hr forecast LWP is
% systematically lower than the 0-24 hr forecast.

ndays = 31;
satsToPlot = {'amsr','ssmi','tmi','windsat'};
hasUncertaintySat = {[],[],[],[]};
modsToPlot = {'GFS_LWP_day1', 'GFS_LWP_day2', 'AM3_day1', 'AM3_day2'};
hasUncertaintyModel = cell(1, numel(modsToPlot));
lineStyles = [repmat({'--'},1,numel(satsToPlot)), repmat({'-'},1,numel(modsToPlot))];
legendEntries = {'AMSR-2', 'SSMIS', 'TMI', 'WindSat', ...
    'GFS Day 1', 'GFS Day 2', 'AM3 Day 1', 'AM3 Day 2'};

figure(1); clf
[hp, ~] = plotSatelliteTimeSeries(1:ndays, dailyMeanLWP, ...
    [satsToPlot, modsToPlot],[hasUncertaintySat hasUncertaintyModel], lineStyles);
hL = legend(hp, legendEntries);
legPos = [0.584523809847378 0.35107142971081 0.180357145411628 0.322619054885138]; 
set(hL, 'Interpreter', 'none', 'Location', 'EastOutside', 'Position', legPos);

xlabel('time [d]')
ylabel('Cloud liquid water [mm]')
title('Daily Mean LWP')
xlim([1 31])

if saveFigure
    print('-depsc','../figs/fig04.eps')
end
end