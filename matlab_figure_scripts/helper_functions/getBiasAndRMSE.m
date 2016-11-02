function [meanBias, rmse] = getBiasAndRMSE(bias,cosLAT)
meanBias = globalMean(bias,cosLAT);
rmse = sqrt(globalMean(bias.^2,cosLAT));
end

