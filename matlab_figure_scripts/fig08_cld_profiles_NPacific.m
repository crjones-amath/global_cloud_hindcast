function fig08_cld_profiles_NPacific(saveFigure)
%%
% FIG08_CLD_PROFILES(SAVEFIGURE) generates Fig. 08
%
% *FIG. 8:* Mean cloud fraction profiles in representative 10$^\circ$
% latitude bins from July 2013 GEOPROF-LIDAR swaths (left column), GFS
% (second column), and AM3 (third column). The rightmost column shows the
% result of applying the GFS Xu-Randall diagnostic cloud fraction scheme to
% the AM3 output.*FIG. 7:* Monthly mean LWP histogram for RSS composite
% along with Day 2 hindcast means for GFS and AM3 over the oceans.
%
%  SAVEFIGURE:  (logical) default - false
%   optionally saves fig08.png to ../figs directory
%

%% Geoprof-lidar profiles in N. Pacific plot options

addpath helper_functions
load ../data/fig08_gfs_am3_gpl_profiles_20161025.mat

if ~exist('saveFigure', 'var')
    saveFigure = false;
end
outFigureFilename = '../figs/fig08.png';

includeAM3WithGFSCloudFraction = true;

% figure config
am3Column = 2;
gfsColumn = 3;
geoprofColumn = 1;

if includeAM3WithGFSCloudFraction
    ncolumns = 4;
else
    ncolumns = 3;
end


%% Plot options

yrange = [0 17];
xrange = [150 245];
crange = [0 0.7];

theXTicks = [150, 180, 210, 240]; % 160:20:240;
theTickValsBottom = {'150E','180','150W','120W'};
fontSize = 9;

%% Geoprof column

figure(2); clf
for s=1:length(latLabels)
    subregion = latRegions{s};
    disp(subregion)
    if s==3
        theTickVals = theTickValsBottom;
    else
        theTickVals = [];
    end
    
    subplot(3, ncolumns, (s - 1)*ncolumns + geoprofColumn)
    pcolor(gplProfiles.lon, gplProfiles.(subregion).height, ...
        gplProfiles.(subregion).cloudFraction);
    shading flat
    
    ylim(yrange)
    caxis(crange)
    xlim(xrange)
    ylabel('z [km]')
    if s==1
        text(155, 15, latLabels{s}, 'Color', 'w')
        title('Geoprof-Lidar')
    elseif s==2
        text(190,15,latLabels{s},'Color','w')
    elseif s==3
        text(155,4,latLabels{s},'Color','w')
        xlabel('Longitude')
    end
    set(gca,'XTick',theXTicks,'XTickLabel',theTickVals,'Fontsize',fontSize);
end

%% AM3 column

for s=1:length(latLabels)
    subregion = latRegions{s};
    disp(subregion)
    if s==3
        theTickVals = theTickValsBottom;
    else
        theTickVals = [];
    end
    
    subplot(3,ncolumns, (s-1)*ncolumns + am3Column)
    pcolor(am3Profiles.lon, am3Profiles.(subregion).height, ...
        am3Profiles.(subregion).cloudFraction);
    shading flat
    
    ylim(yrange)
    caxis(crange)
    xlim(xrange)
    
    if s==1
        title('AM3')
    elseif s==3
        xlabel('Longitude')
    end
    set(gca,'XTick',theXTicks,'XTickLabel',theTickVals,'Fontsize',fontSize,...
        'YTickLabel',[]);
end

%% GFS column
for s=1:length(latLabels)
    subregion = latRegions{s};
    disp(subregion)
    if s==3
        theTickVals = theTickValsBottom;
    else
        theTickVals = [];
    end
    
    subplot(3,ncolumns,(s - 1)*ncolumns + gfsColumn)
    pcolor(gfsProfiles.lon, gfsProfiles.(subregion).height, ...
        gfsProfiles.(subregion).cloudFraction);
    shading flat
    
    ylim(yrange)
    caxis(crange)
    xlim(xrange)
    if s==1
        title('GFS')
    elseif s==3
        xlabel('Longitude')
    end
    set(gca,'XTick',theXTicks,'XTickLabel',theTickVals,'Fontsize',fontSize, ...
        'YTickLabel',[]);
end

%% AM3 with GFS cloud fraction column

if includeAM3WithGFSCloudFraction
    
    for s=1:length(latLabels)
        subregion = latRegions{s};
        disp(subregion)
        if s==3
            theTickVals = theTickValsBottom;
        else
            theTickVals = [];
        end
        
        subplot(3, ncolumns, s*ncolumns)
        pcolor(am3Profiles.lon, am3Profiles.(subregion).height, ...
            am3Profiles.(subregion).gfsCloudFraction);
        shading flat
        
        ylim(yrange)
        caxis(crange)
        xlim(xrange)
        
        if s==1
            title('AM3 (GFS diag. CF)')
        elseif s==3
            xlabel('Longitude')
        end
        set(gca,'XTick',theXTicks,'XTickLabel',theTickVals,'Fontsize',fontSize, ...
            'YTickLabel',[]);
    end
end

%% Save
% Note: works best to add colorbar first, then edit the figure by hand
% before saving.

if saveFigure
    cb = colorbar('Location', 'East');
    input('Enter to continue after editing colorbar size/location')
    print('-dpng', outFigureFilename);
end