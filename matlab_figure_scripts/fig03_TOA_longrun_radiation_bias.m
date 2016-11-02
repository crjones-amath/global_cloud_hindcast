function fig03_TOA_longrun_radiation_bias(saveFigures)
%%
% FIG03_TOA_LONGRUN_RADIATION_BIAS(SAVEFIGURES) generates Fig. 03
% 
% *FIG. 3:* As in bottom two rows of Figure 2, except showing monthly mean
% bias patterns for the July 2013 month-long hindcast relative to
% CERES-EBAF product. 
%
%  SAVEFIGURES:  (logical) default - false
%   optionally saves fig03[a-d].png to ../figs directory
%

%% Load data 
% Contents of fig03_longrun_toa_data.mat:
% 
% * ceresGFS - structure of CERES TOA rad data on GFS grid
% * ceresAM3 - structure of CERES TOA rad data on AM3 grid
% * gfs - structure of GFS longrun monthly mean TOA rad fluxes
% * am3 - structure of AM3 longrun monthly mean TOA rad fluxes
% 
addpath helper_functions
figDir = '../figs/';
if ~exist('saveFigures', 'var')
    saveFigures = false;
end

load ../data/fig03_longrun_toa_data.mat

%% Monthly Mean Bias Patterns for GFS and AM3 relative to CERES EBAF
% Set plot options
apply_to_current_axis = false;
reversed = true;
clim_olr = [-50, 50];
clim_rsw = [-125, 125];

cmap_olr = b2r(clim_olr(1), clim_olr(2), apply_to_current_axis, reversed);
cmap_rsw = b2r(clim_rsw(1), clim_rsw(2), apply_to_current_axis, reversed);

opts_olr = {'ColorMap', cmap_olr, 'Caxis', clim_olr};
opts_rsw = {'ColorMap', cmap_rsw, 'Caxis', clim_rsw};

%% GFS Plots

% OLR
figure(1); clf
title_stats = plotsubfig3(gfs.olr, ceresGFS.lw, ceresGFS, opts_olr);
title({'GFS Long \DeltaOLR (W m^{-2})'; title_stats})

% RSW
figure(2); clf
title_stats = plotsubfig3(gfs.rsw, ceresGFS.sw, ceresGFS, opts_rsw);
title({'GFS Long \DeltaRSW (W m^{-2})'; title_stats})

%% AM3 Plots

% OLR
figure(3); clf
title_stats = plotsubfig3(am3.olr, ceresAM3.lw, ceresAM3, opts_olr);
title({'AM3 Long \DeltaOLR (W m^{-2})'; title_stats})

% RSW
figure(4); clf
title_stats = plotsubfig3(am3.rsw, ceresAM3.sw, ceresAM3, opts_rsw);
title({'AM3 Long \DeltaRSW (W m^{-2})'; title_stats})

%% Optionally save figures
if saveFigures
    print(4, '-dpng', [figDir, 'fig03a.png']);
    print(2, '-dpng', [figDir, 'fig03b.png']);
    print(3, '-dpng', [figDir, 'fig03c.png']);
    print(1, '-dpng', [figDir, 'fig03d.png']);
end

end

% Plot function
function title_stats = plotsubfig3(model, obs, modGrid, opts)
dz = model - obs;
[bias, rmse] = getBiasAndRMSE(dz, modGrid.cosLAT);
title_stats = ['Global Mean = ', num2str(bias,'%0.1f'),...
               '  RMSE = ', num2str(rmse,'%0.1f'), ' W m^{-2}'];
pcolormForPaper(modGrid.lat, modGrid.lon, dz, opts{:});
end