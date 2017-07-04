% American Put Option -   Finite Differences(Explicit)

T = 1;         % Maturity
Spot = 100;    % Spot price
K = 100;       % Strike price
v = 0.20;      % Volatility
r = 0.06;      % Risk free rate
q = 0.03;      % Dividend yield
N = 3   ;      % Number of time steps
M = 3   ;      % Number of stock price steps

dt = T/N;              % Time increment
mu = r - q - v^2/2;    % Drift for stock process
dx = v*sqrt(3*dt);     % Increment for stock price

pu = dt*(v^2/2/dx^2 + mu/2/dx);       % Up probability
pm = 1 - dt*v^2/dx^2 - r*dt;          % Middle probability
pd = dt*(v^2/2/dx^2 - mu/2/dx);       % Down probability

S = zeros(2*M+1, N+1);   % Initialize stock price
V = zeros(2*M+1, N+1);   % Initialize option price

I = [0:1:N];             % Indices for time step
J = [M:-1:-M]';          % Indices for stock price step

% Stock price at maturity
S = Spot*exp(J.*dx);

% Call price at maturity
V(:,end) = max(K - S, 0);

% Work backwards through the lattice
for j=N:-1:1
	for i=2:2*M
		V(i,j) = pu*V(i-1,j+1) + pm*V(i,j+1) + pd*V(i+1,j+1);
	end
	% Lower boundary
	V(2*M+1,j) = V(2*M,j) + (S(2*M) - S(2*M+1));
	% Upper boundary
	V(1,j) = V(2,j);
	% Early exercise check
	for i=1:2*M+1
		V(i,j) = max(K - S(i), V(i,j));
	end
end

AmerPutPrice = V(M+1,1)