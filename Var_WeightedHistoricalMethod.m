%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  WEIGHTED HISTORICAL METHOD
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Estimation of the daily VaR and ES at 1%, at date 1/1/07 for Fiat stock

load stocks
Fiat_ret = diff(log(Fiat));
dates_ret = dates_stocks(2:end);
pi_Fiat = 100;  
t0 = find(dates_ret == datenum(2007,01,01));  
V0 = pi_Fiat*Fiat(t0); 
M = 250; alpha = 0.01;
ret_window = Fiat_ret(t0-M+1:t0);

[VaR, ES] = HistoricalWeighted(V0,ret_window,alpha,0.8);
     % implements weighted historical method (eta = 0.95)
display(VaR);
display(ES);

     
% Estimation of VaR at 1% with weighted hist. method (M = 250); eta = 0.95 and 0.99 
% for the window 1/1/07 to 30/12/10

T = length(dates_ret);
VaR95 = zeros(T-t0+1,1);
VaR95per = zeros(T-t0+1,1);
VaR99 = zeros(T-t0+1,1);
VaR99per = zeros(T-t0+1,1);

for t = t0:T  
    V0 = pi_Fiat*Fiat(t);   
    [VaR95(t), ~, VaR95per(t)] = HistoricalWeighted(V0,Fiat_ret(t-M+1:t),alpha,0.95); 
                                                     % eta = 0.95
    [VaR99(t), ~, VaR99per(t)] = HistoricalWeighted(V0,Fiat_ret(t-M+1:t),alpha,0.99);
                                                     % eta = 0.99
end

figure
plot(dates_ret(t0:end),VaR95per(t0:end),'k') 
hold on
plot(dates_ret(t0:end),VaR99per(t0:end),'r')  % note the different estimates
datetick('x','yyyy'), xlabel('year'), ylabel('VaR')
title('VaR at 1% with weighted hist. method (M = 250); eta = 0.95 (black), 0.99 (red)')


% 3 Var Historical method and Weighted historical method comparison with realized PL 

VaR = zeros(T-1-t0+1,1);
PL  = zeros(T-1-t0+1,1);

for t = t0:T-1 
    V0 = pi_Fiat*Fiat(t);   
    VaR(t) = Historical(V0,Fiat_ret(t-M+1:t),alpha);  % historical
    PL(t) = V0*Fiat_ret(t+1);  % actual PL at date t+1
                               % to be compared with estimates made in t
end

figure
bar(dates_ret(t0:T-1),PL(t0:T-1),'k')  % bar plot of actual PL
hold on
plot(dates_ret(t0:T-1),-VaR95(t0:T-1),'r') 
plot(dates_ret(t0:T-1),-VaR(t0:T-1),'b')
title('Red: -VaR 1% with weighted hist. (eta = 0.95); blue: -VaR 1% with hist.; black: realized PL')
