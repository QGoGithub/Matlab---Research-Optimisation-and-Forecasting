function [price] = QuantoOption (S,v,k,t,cp,f,dr,fr,d,fx,sfx,vfx,rho)
%Compute the price of a Quanto option (applying the method from Haug)

%   Applying MATLAB Statistics Toolbox
%   S  = Price of the Underlying Asset
%   v  = Volatility of the Underlying Asset
%   k  = Strike
%   t  = Time to Maturity (years)
%   cp = Call (0) or Put (1)?
%   f  = Value in Domestic (0) or Foreign (1) currency?
%   dr = Domestic Risk Free Rate
%   fr = Foreign Risk Free Rate ( = 0 if S is a future)
%   d  = Dividend Yield
%   fx = (Predertemined) FX Rate (units of domestic per unit of foreign)
%   sfx= Spot FX Rate (units of foreign per unit of domestic)
%   vfx= Volatility of the Domestic FX Rate
%   rho  = Correlation between Underlying Asset and Domestic FX Rate
%-------------------------------------------------
a = v * sqrt(t);
pv = S * exp((fr - dr - d - rho*vfx*v) * t);

d1 = (log(S/k) + (fr - d - rho*vfx*v + v*v/2)*t)/a;
d2 = d1 - a;
e = fx;

if(f == 1)
    e = fx*sfx;
end

if(cp == 0)
    price = e*(pv*normcdf(d1) - k*exp(-dr*t)*normcdf(d2));
end

if(cp == 1)
    price = e*(k*exp(-dr*t)*normcdf(-d2) - pv*normcdf(-d1));
end

end
    
    