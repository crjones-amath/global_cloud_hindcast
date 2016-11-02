function fig06_lwp_patcorr(saveFigure)
%%
% FIG06_LWP_PATCORR(SAVEFIGURE) generates Fig. 06
% 
% *FIG. 6:* Time series of global area-weighted LWP pattern correlation.
%
%  SAVEFIGURE:  (logical) default - false
%   optionally saves fig06.eps to ../figs directory
%

%% Analysis: daily LWP correlations between REMSS and AM3
% Methodology: Using both the ascending and descending passes from REMSS
% daily passive microwave LWP measurements over ocean, perform an area-weighted
% pattern correlation relative to GFS and AM3.
%
% 
% * REMSS 0.25 degree data is regridded to each model's 2.5 degree grid
% separately before the comparison (GFS grid and AM3 grids are offset). The
% regridding is done by averaging all (non-NaN) time and LWP measurements
% that fall within a given model cell.
% * For each pass and within each grid cell, the satellite LWP is compared
% to the model forecast LWP at the closest model output time.
% * Since the GFS gives 3-hour output and the AM3 gives 1-hour output, AM3
% LWP was averaged to 3-hours (to provide a more even comparison against
% GFS -- turns out this doesn't matter all that much).
% * During the regridding, geographic areas at the border between a pass
% near 00:00 and another pass occuring hear 24:00 may be averaged together.
% To account for this, I ignored any points where the mean time in that
% grid cell differed by more than 5 hours from both neighboring cells at
% the same latitude -- only a few cells are affected each day.
% * Data from both passes on a given day are included to calculate the
% pattern correlation. Any grid cells without valid LWP satellite data are
% ignored in this calculation.
% * There are a few points over land (near bodies of water) and near coasts
% that record LWP satellite data. I do nothing to screen these (few) grid
% cells out.
%
%

%% 

% Load data
load ../data/fig06_pcorr_data.mat

if ~exist('saveFigure', 'var')
    saveFigure = false;
end

%% the plots
plotOpts = {'Linewidth', 1.5};
ylab = 'Pattern Correlation';
xlab = 'Hindcast day of July 2013';
legendEntries = {'AMSR-2', 'TMI', 'SSMIS', 'WindSat'};
yRange = [0.15 0.55];
xRange = [1 31];

figure(1); clf
subplot(2,2,1)
plot(cell2mat(struct2cell(pcor_am3_day1).'),plotOpts{:});
ylim(yRange);
xlim(xRange);
title('AM3 Day 1 Hindcast LWP')
ylabel(ylab)
legend(legendEntries, 'Location', 'best')

subplot(2,2,2)
plot(cell2mat(struct2cell(pcor_gfs_day1).'), plotOpts{:});
ylim(yRange);
xlim(xRange);
title('GFS Day 1 Hindcast LWP')

% 2-day forecast
subplot(2,2,3)
plot(cell2mat(struct2cell(pcor_am3_day2).'), plotOpts{:});
ylim(yRange);
xlim(xRange);
title('AM3 Day 2 Hindcast LWP')
xlabel(xlab)
ylabel(ylab)

subplot(2,2,4)
plot(cell2mat(struct2cell(pcor_gfs_day2).'),plotOpts{:});
ylim(yRange);
xlim(xRange);
title('GFS Day 2 Hindcast LWP')
xlabel(xlab)

if saveFigure
    print('-depsc','../figs/fig06.eps')
end