%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  HISTORICAL METHOD, 1 FACTOR
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Impor data

load data/Stocks   % load the contents of stocks.mat which is in
                      % the subfolder 'data'
Fiat_ret = diff(log(Fiat));
dates_ret = dates_stocks(2:end);  % cancels the first date (no return for date 1!)


% Var and ES at 5% with Historical Method (250 days) 

pi_Fiat = 100;  
t0 = find(dates_ret == datenum(2007,01,01));  
       % first converts 1/1/2007 in numerical format
       % then finds which ret_dates entry coincides with that date
       % warning! t0 may be [] if 1/1/2007 is a holyday (so: no ret_dates entry
       % corresponds to that date). Be careful and always check t0 is a (single) date
       
V0 = pi_Fiat*Fiat(t0);   % current portfolio value (as of 1/1/2007)

M = 250; alpha = 0.05;
ret_window = Fiat_ret(t0-M+1:t0);   % build the estimation window: last M returns
                          % note: last return observed today (t0)
[VaR, ES] = Historical(V0,ret_window,alpha);  % implements historical method  
disp('VaR e ES')
disp([VaR ES])


% Var and ES at 1%

alpha = 0.01;  
T = length(dates_ret);   % total length of the time series

for t = t0:T    % cycle from 1/1/2007 (t0) to the end of the time series
    V0 = pi_Fiat*Fiat(t);   % current portfolio value at date t
    [VaR(t), ES(t), VaR_perc(t), ES_perc(t)] = ...
                     Historical(V0,Fiat_ret(t-M+1:t),alpha); 
         % note: the estimation window is rolling forward 1 day at each step
end

figure
plot(dates_ret(t0:end),VaR(t0:end),'k')  % just plot from t0 onwards
hold on
plot(dates_ret(t0:end),ES(t0:end),'r') 
datetick('x','yyyy'), xlabel('year'), ylabel('VaR/ES')
title('VaR (black) and ES (red) at 1% with hist. method (M = 250)')

figure
plot(dates_ret(t0:end),VaR_perc(t0:end),'k')  % note box-shaped behaviour
hold on
plot(dates_ret(t0:end),ES_perc(t0:end),'r') 
datetick('x','yyyy'), xlabel('year'), ylabel('perc. VaR/ES')
title('Perc. VaR (black) and ES (red) at 1% with hist. method (M = 250)')
     

% Var and ES with 1000 observations and comparison with previuos results(250 days)

M = 1000;  % change the estimation window length (check: t0 > 1000 !)

for t = t0:T  
    V0 = pi_Fiat*Fiat(t);   
    [VaR1000(t) ES1000(t) VaR1000_perc(t) ES1000_perc(t)] = ...
                       Historical(V0,Fiat_ret(t-M+1:t),alpha);
end

figure
plot(dates_ret(t0:end),VaR_perc(t0:end),'k') 
hold on
plot(dates_ret(t0:end),VaR1000_perc(t0:end),'r')
datetick('x','yyyy'), xlabel('year'), ylabel('VaR')
title('VaR at 1% with the historical method; M = 250 (black), 1000 (red)')

% Var and ES at 1% for a portfolio short and comparison results with long
% portfolio

M = 250;
pi_Fiat = -100;  % short position

for t = t0:T  
    V0 = pi_Fiat*Fiat(t);   
    [VaR_short(t) ES_short(t) VaR_short_perc(t) ES_short_perc(t)] = ...
                       Historical(V0,Fiat_ret(t-M+1:t),alpha);
end

figure
plot(dates_ret(t0:end),VaR(t0:end),'k') 
hold on
plot(dates_ret(t0:end),VaR_short(t0:end),'r') 
datetick('x','yyyy'), xlabel('year'), ylabel('VaR')
title('VaR at 1% with the hist. method (M = 250) for a long (black) and short (red) portfolio')
   % note: long and short positions (same number of shares) have different risk