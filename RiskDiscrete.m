function [VaR, ES] = RiskDiscrete(x,p,alpha)
% [VaR, ES] = RiskDiscrete(x,p,alpha) 
% Computes VaR and ES at order alpha of a discrete X taking value x(i) with
% probability p(i)
% 
% INPUTS
% x and p (vectors of same length): see above
% alpha (scalar): see above
% The function can also be called in the form 
%    RiskDiscrete(x,alpha)
% In this case, the empirical distribution is considered (p(i)=1/N)
%
% OUTPUTS
% VaR, ES (scalars): see above

N = length(x);

%fase di controlli
if nargin == 2
    alpha = p;
    p = ones(N,1)/N;
elseif not(length(p) == N)
    error('check length of x and p')
end

x = x(:);
p = p(:)/sum(p);   % if sum(p) is not 1, it normalizes

[x, I] = sort(x);  %ordina le componenti di x e ridà le permutazioni in I(nelle componenti)
p = p(I);          %il nuovo vettore riordinato
cump = cumsum(p);  

index = 1;
while (alpha > cump(index))  %qui ha tolto l'uguale (ragioniamo su (x,y,z,t,v) con p(1/100,1/100,1/100,1/100,96/100) e su alpha=0.05)
    index = index+1;
end

VaR = -x(index);
if index > 1
    j = index - 1;
    ES = -(sum(p(1:j).*x(1:j)) + (alpha-cump(j))*x(index))/alpha;
         % ES is (minus) the average of quantiles of order u < alpha
else
    ES = VaR;
end