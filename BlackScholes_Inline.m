% Fast Black-Scholes calculations using inline and anonymous functions in Matlab

clc; clear;

% Spot, strike, risk free rate, maturity, and volatility
S = 100;
K = 100;
r = 0.05;
v = .25;
T = 0.5;

% Inline function for the Black Scholes call and put
Ci = inline('s.*normcdf((log(s./K) + (r+v.^2./2).*T)./v./sqrt(T)) - K.*exp(-r.*T).*normcdf((log(s./K) + (r+v.^2./2).*T)./v./sqrt(T) - v.*sqrt(T))',...
	's','K','r','v','T');
Pi = inline('K.*exp(-r.*T).*normcdf(-(log(s./K) + (r+v.^2./2).*T)./v./sqrt(T) + v.*sqrt(T)) - s.*normcdf(-(log(s./K) + (r+v.^2./2).*T)./v./sqrt(T))',...
	's','K','r','v','T');

% Anonymous functions for the Black Scholes call and put
Ca = @(s,K,r,v,T) (s.*normcdf((log(s./K) + (r+v.^2./2).*T)./v./sqrt(T)) - K.*exp(-r.*T).*normcdf((log(s./K) + (r+v.^2./2).*T)./v./sqrt(T) - v.*sqrt(T)));
Pa = @(s,K,r,v,T) (K.*exp(-r.*T).*normcdf(-(log(s./K) + (r+v.^2./2).*T)./v./sqrt(T) + v.*sqrt(T)) - s.*normcdf(-(log(s./K) + (r+v.^2./2).*T)./v./sqrt(T)));


% Compute the prices
tic
CallI = Ci(S,K,r,v,T);
PutI = Pi(S,K,r,v,T);
tI = toc;

tic
CallA = Ca(S,K,r,v,T);
PutA = Pa(S,K,r,v,T);
tA = toc;

% Display the results
fprintf('Function type       Call      Put       Time \n')
fprintf('-----------------------------------------------\n')
fprintf('Inline         %10.5f %10.5f %10.2e \n',CallI,PutI,tI);
fprintf('Anonymous      %10.5f %10.5f %10.2e \n',CallA,PutA,tA);
fprintf('-----------------------------------------------\n')
