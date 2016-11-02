function fig07_remss_lwp_histogram(saveFigure)
%%
% FIG07_REMSS_LWP_HISTOGRAM(SAVEFIGURE) generates Fig. 06
% 
% *FIG. 7:* Monthly mean LWP histogram for RSS composite along with Day 2
% hindcast means for GFS and AM3 over the oceans.
%
%  SAVEFIGURE:  (logical) default - false
%   optionally saves fig06.eps to ../figs directory
% 

%% 
addpath helper_functions
load ../data/fig05_fig07_monthly_lwp.mat

if ~exist('saveFigure', 'var')
    saveFigure = false;
end

%% Figure 5: histogram:
% PDF normalization; interpolate to 2.5 x 2.5 degree
figure(5); clf
subplot(2,2,1)
ghist2 = gfs.lwp_day2;
ghist2(gfs.landMask) = NaN;
ghist2(ghist2 == 0) = NaN;
ahist2 = am3.lwp_day2;
ahist2(am3.landMask) = NaN;
ahist2(ahist2 == 0) = NaN;

histogram(rss.am3_day2(:),'normalization','probability');
hold on
histogram(ghist2(:), 'normalization', 'probability');
histogram(ahist2(:), 'normalization', 'probability');
legend({'RSS', 'GFS', 'AM3'}, 'Location', 'Best')
xlim([-0.05 0.4])
xlabel('LWP [mm]')
ylabel('Probability Density')

%% Save figure
if saveFigure
    print(5, '-depsc', '../figs/fig07.eps')
end