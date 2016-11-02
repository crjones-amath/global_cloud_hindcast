function dat = nc_varget(varargin)
% function that squeezes and converts data as needed.

% squeeze out singleton dimensions
dat = squeeze(ncread(varargin{:}));

% convert to MATLAB native double
if isnumeric(dat) && ~isa(dat,'double')
   dat = double(dat);
end

end