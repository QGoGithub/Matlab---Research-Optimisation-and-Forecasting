% CRR Binomial tree for Vanilla Call and Put Pricing

clc; clear;

% Inline function for the Black Scholes call
BSCall = inline('s*exp(-q*T)*normcdf((log(s/K) + (r-q+v^2/2)*T)/v/sqrt(T)) - K*exp(-r*T)*normcdf((log(s/K) + (r-q+v^2/2)*T)/v/sqrt(T) - v*sqrt(T))',...
	     's','K','r','q','v','T');

% Inline function for the Black Scholes put
BSPut = inline('K*exp(-r*T)*normcdf(-(log(s/K) + (r-q+v^2/2)*T)/v/sqrt(T) + v*sqrt(T)) - s*exp(-q*T)*normcdf(-(log(s/K) + (r-q+v^2/2)*T)/v/sqrt(T))',...
	    's','K','r','q','v','T');

% Stock price features.
Spot = 100;              % Spot price.
r = 0.05;                % Risk free rate.
q = 0.02;                % Dividend Yield.
v = 0.30;                % Volatility.
N = 3;                 % Time steps for trinomial tree.

% Option features.
K = 100;                 % Strike price.
T = 0.25;                % Maturity in years.
PutCall = 'C';           % 'P'ut or 'C'all.
EuroAmer = 'E';          % 'E'uropean or 'A'merican.

% Trinomial tree parameters and probabilities.
dt = T/N;
u = exp(v*sqrt(dt));
d = 1/u;
p = (exp((r-q)*dt)-d)/(u-d);

% Initialize the stock prices
S = zeros(2*N+1,N+1);
S(N+1,1) = Spot;

% Calculate all the stock prices.
for j=2:N+1
    for i=N-j+2:2:N+j
        S(i,j) = Spot*u^(N+1-i);
	end
end

% Initialize the option prices.
V = zeros(2*N+1,N+1);

% Calculate terminal option prices.
switch PutCall
	case 'C'
		V(:,N+1) = max(S(:,N+1) - K, 0);
	case 'P'
		V(:,N+1) = max(K - S(:,N+1), 0);
end

% Calculate Remaining entries for Calls and Puts

for j=N:-1:1
	for i=N-j+2:2:N+j
		switch EuroAmer
			case 'A'
				if strcmp(PutCall, 'C')
					V(i,j) = max(S(i,j) - K, exp(-r*dt)*(p*V(i-1,j+1) + (1-p)*V(i+1,j+1)));
				else
					V(i,j) = max(K - S(i,j), exp(-r*dt)*(p*V(i-1,j+1) + (1-p)*V(i+1,j+1)));
				end
			case 'E'
				V(i,j) = exp(-r*dt)*(p*V(i-1,j+1) + (1-p)*V(i+1,j+1));
		end
	end
end

% Option price is at the first node.
TreePrice = V(N+1,1)

% Compute the European price.
if strcmp(PutCall, 'C')
	EuroPrice = BSCall(Spot,K,r,q,v,T)
else
	EuroPrice =  BSPut(Spot,K,r,q,v,T)
end

% Compute the exercise premium for American Puts.
if strcmp(PutCall, 'P') & strcmp(EuroAmer, 'A')
	ExercisePremium = TreePrice - EuroPrice
end
