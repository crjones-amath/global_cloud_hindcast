function fig02_TOA_map_ceres_gfs_am3(saveFigures)
%%
% FIG02_TOA_MAP_CERES_GFS_AM3(SAVEFIGURES) generates Fig. 02
% 
% *FIG. 2:* July 2013 monthly mean OLR (left column) and RSW (right column)
% patterns. The top row shows CERES observations. Monthly mean Day 2
% hindcast bias patterns relative to CERES are shown for the GFS (middle
% row) and AM3 (bottom row). 
%
%  SAVEFIGURES:  (logical) default - false
%   optionally saves fig02[a-f].png to ../figs directory
%

%% Load data and specify options
%
addpath helper_functions
load ../data/fig02_data.mat

% optionally save output figures
if ~exist('saveFigures','var')
    saveFigures = false; 
end

% format numbers in subfigure titles
fmt = '%3.2f';

% CERES data on AM3 grid:
olr = am3Mon.lw; % CERES EBAF on AM3 grid
rsw = am3Mon.sw; % CERES EBAF on AM3 grid
olat = adim.lat; olon = adim.lon;  % lat/lon dims for CERES on AM3 grid
cosLAT = cosALAT; % cos(latitude) for area-weighting

%% Figure 1a: CERES TOA OLR
olr_mean = globalMean(olr, cosLAT);
mean_str = ['  Global Mean = ', num2str(olr_mean, fmt)];

figure(1); clf
pcolormForPaper(olat, olon, olr);
title(['CERES TOA OLR (W m^{-2})', mean_str])
if saveFigures
    print -dpng ../figs/fig02a.png
end

%% Figure 1b: CERES TOA RSW
rsw_mean = globalMean(rsw, cosLAT);
mean_str = ['  Global Mean = ', num2str(rsw_mean, fmt)];

figure(2); clf
pcolormForPaper(olat, olon, rsw);
title(['CERES TOA RSW (W m^{-2})', mean_str])
if saveFigures
    print -dpng ../figs/fig02b.png
end

%% Plot options for bias maps
timeRange = 1:30; % Day2 => 2 day forecasts initialized on July 1 - July 30

% OLR colormap and colorbar options
clim_olr = [-50, 50];
opts_olr = {'ColorMap', b2r(clim_olr(1), clim_olr(2), false, true), ...
    'Caxis', clim_olr};

% RSW colormap and colorbar options
clim_rsw = [-125, 125];
opts_rsw = {'ColorMap', b2r(clim_rsw(1), clim_rsw(2), false, true), ...
    'Caxis',clim_rsw};

%% Figure 2c: GFS OLR Bias
gfs_olr_day2 = nanmean(cat(3,gfs(timeRange).OLR_day2),3);
dz = gfs_olr_day2(:, end:-1:1) - gfsMon.lw;
[bias, rmse] = getBiasAndRMSE(dz, cosGLAT);
title_stats = ['Global Mean = ', num2str(bias,'%0.1f'),...
               '  RMSE = ', num2str(rmse,'%0.1f'), ' W m^{-2}'];

figure(3); clf
pcolormForPaper(gdim.lat, gdim.lon, dz, opts_olr{:});
title({'GFS \DeltaOLR (W m^{-2})'; title_stats})
if saveFigures
    print -dpng ../figs/fig02c.png
end

%% Figure 1d: GFS RSW Bias
gfs_rsw_day2 = nanmean(cat(3, gfs(timeRange).UpSW_day2), 3);
dz = gfs_rsw_day2(:, end:-1:1) - gfsMon.sw;
[bias, rmse] = getBiasAndRMSE(dz, cosGLAT);
title_stats = ['Global Mean = ', num2str(bias,'%0.1f'),...
               '  RMSE = ', num2str(rmse,'%0.1f'), ' W m^{-2}'];

figure(4); clf
pcolormForPaper(gdim.lat, gdim.lon, dz, opts_rsw{:});
title({'GFS \DeltaRSW (W m^{-2})'; title_stats})
if saveFigures
    print -dpng ../figs/fig02d.png
end

%% Figure 1e: AM3 OLR Bias

% hindcast monthly mean
am3_olr_day2 = nanmean(cat(3, am3(timeRange).OLR_day2), 3); 
dz = am3_olr_day2 - am3Mon.lw;
[bias, rmse] = getBiasAndRMSE(dz, cosALAT);
title_stats = ['Global Mean = ', num2str(bias, '%0.1f'),...
               '  RMSE = ', num2str(rmse, '%0.1f'), ' W m^{-2}'];

figure(5); clf
pcolormForPaper(adim.lat, adim.lon, dz, opts_olr{:});
title({'AM3 \DeltaOLR (W m^{-2})'; title_stats})
if saveFigures
    print -dpng ../figs/fig02e.png
end

%% Figure 1f: AM3 RSW Bias

% hindcast monthly mean
am3_rsw_day2 = nanmean(cat(3, am3(timeRange).UpSW_day2), 3);
dz = am3_rsw_day2 - am3Mon.sw;
[bias, rmse] = getBiasAndRMSE(dz, cosALAT);
title_stats = ['Global Mean = ', num2str(bias, '%0.1f'),...
               '  RMSE = ', num2str(rmse, '%0.1f'), ' W m^{-2}'];

figure(6); clf
pcolormForPaper(adim.lat, adim.lon, dz, opts_rsw{:});
title({'AM3 \DeltaRSW (W m^{-2})'; title_stats})
if saveFigures
    print -dpng ../figs/fig02f.png
end