function [pattern_corrs_day1, pattern_corrs_day2, pattern_data, dims] = ...
    dailyPatternCorrREMSSModel(lwpSat, timeSat, modelStruct, ...
    lat, lon, satsToCompare, samplesPerDay, reverseLats, latMask)
% Assumed input:
% lwpSat(day).(sat) = 3-dim array [nlon, nlat, sat_orbit] of daily LWP data
% timeSat(day).(sat) = 3-dim array [] with UTC time (in hrs) corresponding
%                     to lwpSat LWP measurements.
% modelStruct(day).LWP = 3-dim array [nlon, nlat, forecast_times in hrs] of
%                       model LWP data
%
% lat, lon are common to satellite and model
% samplesPerDay = number of model measurements per day (assumed evenly
% spaced)

[LAT, ~] = meshgrid(lat, lon);
cosLAT = cos(LAT.*pi./180); % weights for pattern correlation
% satsToCompare = {'amsr','tmi','ssmi'};

if ~exist('reverseLats','var')
    reverseLats = false;
end

if exist('latMask','var')
    [mask, ~] = meshgrid(latMask, lon);
end

%% QC for Satellite data

thresh = 5; % if difference between adjacent sides is greater than 6 hours, ignore this point

% specific to AM4
dt = 24/samplesPerDay;
timeBins = 0:dt:24;
nDay1 = 24/dt;
% timeBins = 0:24;
day1TimeIndices = 1:nDay1;
day2TimeIndices = (nDay1+1):2*nDay1;

nDays = numel(timeSat);

% loop all through this biz:
for nsat=1:numel(satsToCompare)
    sat = satsToCompare{nsat};
    patternCorDay1 = NaN(nDays,1);
    patternCorDay2 = NaN(nDays,1);
    
    for day=nDays:-1:1
        dailyTimeData = timeSat(day).(sat);
        dailyLWPData = lwpSat(day).(sat);
        modelLWP = NaN(size(dailyTimeData));  % day 1
        modelLWP2 = NaN(size(dailyTimeData)); % day 2
        satLWP = NaN(size(dailyTimeData));
        
        if reverseLats
            dailyTimeData = dailyTimeData(:,end:-1:1,:);
            dailyLWPData = dailyLWPData(:,end:-1:1,:);
        end        
        
        for k=1:size(dailyTimeData,3)
            tDat = dailyTimeData(:,:,k);  % 2d time array [lon x lat]
            lwpDat = dailyLWPData(:,:,k); % 2d LWP array [lon x lat]
            
            if exist('latMask','var')
                tDat(mask) = NaN;
                lwpDat(mask) = NaN;
            end
            
            % ignore points that average across different overpass times
            datToDrop = abs(tDat-tDat([end,1:end-1],:)) > thresh & ...
                abs(tDat-tDat([2:end, 1],:)) > thresh;
            
            tDat(datToDrop) = NaN;
            
            % linear indices where both time and LWP obs exist (lon x lat)
            iDataToCompare = find(~isnan(tDat) & ~isnan(lwpDat));
            
            % sub-indices for lat, lon (2d: lon x lat)
            [ilon, ilat] = ind2sub(size(tDat),iDataToCompare); 

            % determine corresponding time index of model
            day1_ids = discretize(tDat,timeBins,day1TimeIndices); 
            day2_ids = discretize(tDat,timeBins,day2TimeIndices);
            
            % 1 Day Forecasts
            
            % linear indices for reading from modelStruct [lon,lat,time]
            iModelToRead = sub2ind(size(modelStruct(day).LWP), ...
                ilon, ilat, day1_ids(iDataToCompare)); 
            % linear indices for writing to modelLWP,satLWP [lon,lat,sat_pass]
            iToWrite = sub2ind(size(modelLWP), ilon, ilat, k*ones(size(ilon)));
            
            % CJONES NOTE: Strictly speaking, I don't need to ever fill in
            % satLWP, modelLWP except to plot the values some time in the
            % future ...
            
            % fill in satLWP and modelLWP values being compared
            satLWP(iToWrite) = lwpDat(iDataToCompare);
            modelLWP(iToWrite) = modelStruct(day).LWP(iModelToRead);
            
            % obs, model, and weights to be used to calculate pattern corr
            weights{k} = cosLAT(iDataToCompare);
            modelObsMatrix{k} = [satLWP(iToWrite), modelLWP(iToWrite)];
            
            % 2 Day Forecats
            if day>1
                iModelToRead2 = sub2ind(size(modelStruct(day).LWP),...
                    ilon, ilat, day2_ids(iDataToCompare));
                modelLWP2(iToWrite) = modelStruct(day-1).LWP(iModelToRead2);                
                modelObsMatrix2{k} = [satLWP(iToWrite), modelLWP2(iToWrite)];
            end            
        end
        
        modelObs = cat(1,modelObsMatrix{:});
        w = cat(1,weights{:});
        w = w./sum(w);
        
        corrMatrix = weightedcorrs(modelObs,w);
        patternCorDay1(day,1) = corrMatrix(2,1);
        
        if day>1
            corrMat = weightedcorrs(cat(1,modelObsMatrix2{:}), w);
            patternCorDay2(day,1) = corrMat(2,1);
        end
        
        if nargout>2
            pattern_data(day).(sat).obs = satLWP;
            pattern_data(day).(sat).model_day1 = modelLWP;
            pattern_data(day).(sat).model_day2 = modelLWP2;
        end
        
        
    end
    
    pattern_corrs_day1.(sat) = patternCorDay1;
    pattern_corrs_day2.(sat) = patternCorDay2;
end

if nargout>3
    dims.lat = lat;
    dims.lon = lon;
    dims.cosLAT = cosLAT;
end

end