function fig05_remss_lwp_map(saveFigure)
%%
% FIG05_REMSS_LWP_MAP(SAVEFIGURE) generates Fig. 05
% 
% *FIG. 5:* Monthly mean LWP maps for RSS passive microwave observations
% (top), GFS Day 2 hindcast (middle) and AM3 Day 2 hindcast (bottom).
%
%  SAVEFIGURE:  (logical) default - false
%   optionally saves fig05.png to ../figs directory
%

%% Paper Figure: REMSS LWP Map
% OBS: Use monthly mean LWP of all 4 products. Averaging here is justified
% because we have already shown they agree well with each other. 
%
% Obs is gridded to models. Instead of showing bias plots, it's clearer to
% show the absolute LWP values for the models (bias plots mostly just show
% regions where obs has lots of LWP).

%% 
addpath helper_functions
load ../data/fig05_fig07_monthly_lwp.mat

if ~exist('saveFigure', 'var')
    saveFigure = false;
end

% REMSS dimensions:
lon = 0.125:.25:360-0.125;
lat = -89.875:0.25:89.875;
[OLAT, ~] = meshgrid(lat, lon);
cosOLAT = cos(OLAT.*pi/180);

%% Figure 5: LWP maps
fig5opts = {'CAxis', [0 0.3], 'Colormap', parula(16), ...
    'showColorbar', false, 'PadRight', -3};
fmt = '%0.2g';

figure(4); clf
subplot(3,1,1)
ax4(1) = pcolormForPaper(lat, lon, rss.obs, fig5opts{:});
obsMean = globalMean(rss.obs, cosOLAT);
title(['RSS July 2013 (Mean ',num2str(obsMean,fmt),')'])

subplot(3,1,2)
zPlot = gfs.lwp_day2; 
zPlot(gfs.landMask) = NaN;
gfsMean = globalMean(zPlot, gfs.cosLAT);

ax4(2) = pcolormForPaper(gfs.lat, gfs.lon, zPlot, fig5opts{:});
title(['GFS Day 2 (Mean ',num2str(gfsMean, fmt),')'])

subplot(3,1,3)
zPlot = am3.lwp_day2; 
zPlot(am3.landMask) = NaN;
am3Mean = globalMean(zPlot, am3.cosLAT);

ax4(3) = pcolormForPaper(am3.lat, am3.lon, zPlot, fig5opts{:});
title(['AM3 Day 2 (Mean ', num2str(am3Mean, fmt),')']);

newPos = [0.3250    0.0700    0.3850    0.0200]; % do this manually
cbh4 = colorbar(ax4(3), 'Position', newPos, 'Location', 'South');
cbh4.Label.String = 'LWP [mm]';


%% Save figures
if saveFigure
    input('Resize window to appropriate size before continuing.')
    print(4,'-dpng','../figs/fig05.png')
end

end