function mn = globalMean(val,cosLAT)
% return area-weighted global mean of val

if ~exist('cosLAT', 'var')
    % uniform weighting:
    mn = nanmean(val); 
    return
end

assert(all(size(val) == size(cosLAT)), 'globalMean:dimensionMismatch')
sel = ~isnan(val);
mn = sum(cosLAT(sel).*val(sel))./sum(cosLAT(sel));
end