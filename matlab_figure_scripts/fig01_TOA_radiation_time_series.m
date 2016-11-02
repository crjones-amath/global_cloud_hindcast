function fig01_TOA_radiation_time_series(saveFigure)
%%
% FIG01_TOA_RADIATION_TIME_SERIES(SAVEFIGURE)  generates Fig. 01
% 
% *Fig 1:* Global OLR (left) and RSW (right) bias and RMSE compared to CERES
% daily SYN1deg observations for GFS and AM3 hindcasts. Squares at day 31
% show the difference between the monthly mean of the SYN1deg data and the
% CERES EBAF product.
%
%  SAVEFIGURE:  (logical) default - false
%   optionally saves fig01.eps and fig01.pdf to ../figs directory
%

%% load data and set defaults
% Contents of fig01_data.mat:
% 
% * am3Bias - structure daily TOA AM3 hindcast biases relative to CERES
% * am3RMSE - structure of CERES TOA rad data on AM3 grid
% * gfsBias - structure of GFS longrun monthly mean TOA rad fluxes
% * gfsRMSE - structure of AM3 longrun monthly mean TOA rad fluxes
% * bias_lw_daily_vs_ebaf
% * bias_sw_daily_vs_ebaf
% 
if ~exist('saveFigure', 'var')
    saveFigure = false;
end

load ../data/fig01_data.mat

%% Plot options
zeroLine = {[1 31], [0 0], 'Color', [0.5 0.5 0.5], 'Linewidth', 0.5, 'Linestyle', '-'};
ebafStyle = {'Marker','s','MarkerFaceColor', [0.5 0.5 0.5], 'MarkerEdgeColor', [0.5 0.5 0.5]};
rmseStyle = {'Linewidth', 2, 'LineStyle', '--'};
legendEntries = {'GFS Day1', 'GFS Day2', 'AM3 Day1', 'AM3 Day2'};

%% OLR

clf; subplot(3,2,[1 3])

% bias plots
plotData = {gfsBias.dlw_day1, gfsBias.dlw_day2,...
    am3Bias.dlw_day1, am3Bias.dlw_day2};

for p = 1:numel(plotData)
    ax(p) = plot(1:31, plotData{p}, 'Linewidth', 2); hold on
end
title('OLR (W m^{-2})')
xlabel('time (d)')

% RMSE plots
rmsPlotData = {gfsRMSE.dlw_day1, gfsRMSE.dlw_day2,...
    am3RMSE.dlw_day1, am3RMSE.dlw_day2};

for p = 1:numel(rmsPlotData)
    col = ax(p).Color;
    plot(1:31, rmsPlotData{p}, rmseStyle{:}, 'Color', col); hold on
end

% Add ebaf offset
plot(31, bias_lw_daily_vs_ebaf, ebafStyle{:});
plot(zeroLine{:})
ylabel('Bias (-) and RMSE (--)')
xlim([1 31])

%% RSW

subplot(3, 2, [2 4])

% bias plots
plotData = {gfsBias.dsw_day1, gfsBias.dsw_day2,...
    am3Bias.dsw_day1, am3Bias.dsw_day2};
for p = 1:numel(plotData)
    ax(p) = plot(1:31,plotData{p},'Linewidth',2); hold on
end
title('RSW (W m^{-2})')
xlabel('time (d)')
legend(legendEntries, 'Location', 'best', 'Position', ...
    [0.5796465097403 0.65056284832353 0.17464285956110 0.16547619410924])

% RMSE plots
rmsPlotData = {gfsRMSE.dsw_day1, gfsRMSE.dsw_day2,...
    am3RMSE.dsw_day1, am3RMSE.dsw_day2};

for p = 1:numel(rmsPlotData)
    col = ax(p).Color;
    plot(1:31,rmsPlotData{p}, rmseStyle{:}, 'Color', col); hold on
end

% Add ebaf offset
plot(31, bias_sw_daily_vs_ebaf, ebafStyle{:});
plot(zeroLine{:})
xlim([1 31])

%% Save output
if saveFigure
    print -depsc ../figs/fig01.eps
    print -dpdf ../figs/fig01.pdf
end