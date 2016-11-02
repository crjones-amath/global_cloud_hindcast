function [out, atts] = nc2struct(ncfiles, vars, appendTo)
%NC2STRUCT reads data from netcdf file into a structure array
%
% out = NC2STRUCT(ncfiles): Reads all variables into structure array "out"
% out = NC2STRUCT(ncfiles, vars): Reads variables contained in cell array "vars"
%   into structure array "out."
% [out,atts] = NC2STRUCT(...): out contains variable content; atts
%   structure contains attributes of variables.

if ischar(ncfiles)
   % convert single filename to cell array
   ncfiles = {ncfiles};
end

nf = numel(ncfiles);
doReadAll = false;

if (~exist('vars','var') || isempty(vars))
   % get all variables in file:
   vars = getVars(ncfiles);
   doReadAll = true;
elseif ischar(vars)
   vars = {vars};
end

nv = numel(vars);

for f=nf:-1:1
   for v=vars
      out(f).(v{:}) = nc_varget(ncfiles{f},v{:});
   end
end

if nargout>1
   if doReadAll
      for f=nf:-1:1
         nctmp = ncinfo(ncfiles{f});
         v2 = {nctmp.Variables.Name};
         for j=1:nv
            v = vars{j};
            ix = find(strcmp(v,v2));
            if isempty(ix)
               atts(f).(v) = [];
            else
               attNames = {nctmp.Variables(ix).Attributes.Name};
               nAtt = numel(attNames);
               for a=1:nAtt
                  a1 = genvarname(attNames{a}); % sanitize field name
                  atts(f).(v).(a1) = nctmp.Variables(ix).Attributes(a).Value;
               end
               % add dimensions/size as well:
               atts(f).(v).Dimensions = {nctmp.Variables(ix).Dimensions.Name};
               atts(f).(v).Size = nctmp.Variables(ix).Size;
            end
         end
      end
   else
      for f=nf:-1:1
         for j=1:nv
            v = vars{j};
            try 
               nctmp = ncinfo(ncfiles{f},v);
               attNames = {nctmp.Attributes.Name};
               nAtt = numel(attNames);
               for a=1:nAtt
                  a1 = genvarname(attNames{a}); % sanitize field name
                  atts(f).(v).(a1) = nctmp.Attributes(a).Value;
               end
               % add dimensions as well:
               atts(f).(v).Dimensions = {nctmp.Dimensions.Name};
               atts(f).(v).Size = nctmp.Size;
            catch ME
               atts(f).(v) = [];
            end
         end
      end
   end
end

end

function vars = getVars(ncfiles)
% gets list of all unique variables in files ncfiles
vars = {};
nf = numel(ncfiles);
   for f=nf:-1:1
      nctmp = ncinfo(ncfiles{f});
      v2 = {nctmp.Variables.Name};
      vars = unique([ v2 , vars]);
   end
end

function stitchInTime()
end