function [VaR ES VaR_perc ES_perc] = HistoricalWeighted(V0,ret_window,alpha,eta)
% [VaR ES VaR_perc ES_perc] = HistoricalWeighted(V0,ret_window,alpha,eta)
% Estimates VaR and ES at order alpha, using the weighted historical method 
% with parameter eta of a linear univariate portfolio
%
% INPUTS
% V0 (scalar): see above
% ret_window (vector): window of past observed returns
% alpha (scalar): see above
% eta (scalar): see above
%
% OUTPUTS
% VaR, ES (scalars): see above
% VaR_perc, ES_perc (scalars): percentage VaR and ES (i.e. VaR/V0, ES/V0)

PL = V0*ret_window;
M = length(ret_window);
weights = (1-eta)/(eta*(1-eta^M))*eta.^(1:M)';   % buid weights

[VaR, ES] = RiskDiscrete(PL,weights,alpha);  % uses 'RiskDiscrete'

VaR_perc = abs(VaR/V0);       
ES_perc = abs(ES/V0);