function [hp, hL] = plotSatelliteTimeSeries(time,structIn,fieldsToPlot,fieldUncertainty,lineStyles)
% Plots a time series for a subset of fields of a given structure

defaultPlotOpts = {'Linewidth',2};

nsat = numel(fieldsToPlot);

if ~exist('lineStyles','var')
    lineStyles = repmat({'-'},1,nsat);
end

% if ~exist('plotOpts','var')
%     plotOpts = repmat({''},1,nsat);
% end


for n=1:nsat
    sat = fieldsToPlot{n};
    unc = fieldUncertainty{n};
    
    if isempty(unc)
        hp(n) = plot(time,structIn.(sat),defaultPlotOpts{:},'LineStyle',lineStyles{n});
    else
        hp(n) = errorbar(time,structIn.(sat),structIn.(unc),defaultPlotOpts{:},'LineStyle',lineStyles{n});
    end
    hold on
end

hL = legend(fieldsToPlot,'Location','best');
end