function [VaR, ES, VaR_perc, ES_perc] = Historical(V0,ret_window,alpha)
% [VaR ES VaR_perc ES_perc] = historical(V0,ret_window,alpha)
% Estimates VaR and ES at order alpha, using the historical method of a linear 
% univariate portfolio (whose PL is V0*R, where R is the return)
%
% INPUTS
% V0 (scalar): see above
% ret_window (vector): window of past observed returns
% alpha (scalar): see above
%
% OUTPUTS
% VaR, ES (scalars): see above
% VaR_perc, ES_perc (scalars): percentage VaR and ES (i.e. VaR/V0, ES/V0)

PL = V0*ret_window;           % compute hypothetical PL
VaR = -quantile(PL,alpha);    % estimate for VaR
ES = -mean(PL(PL <= -VaR));   % estimate for ES
VaR_perc = abs(VaR/V0);       % note: we are interested in a positive percentage
ES_perc = abs(ES/V0);