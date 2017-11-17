% A simple yet insightful look at random walks %

% A simple comparison between two random walks with two differenct
%probability distribuitions.

% The First Random Walk is performed according to white noise with Normal Distribution with variance 1

% The Second Random Walk performed with the white noise component with a  Uniform distribution with variance 1
% The two distributions are taken to have the same varience so we can
% extract a useful comparison

clc, clear all, clf

N=100; % number of random walks

Point1=[0,0];% original location of the point
Point2=[0,0];% original location of the point

subplot(1,2,1)
plot(Point1(1),Point1(2),'o');
title('Normal. With Varience 1')
axis([-35 35 -35 35])% fixing size of the window. 
hold on 

subplot(1,2,2)
plot(Point2(1),Point2(2),'o');
title('Uniform. With Varience 1')

axis([-35 35 -35 35])% fixing size of the window. 
hold on 


n=1;%index. Count walks.

while n<N
    
    V11=randn*(-1)^floor(2*randn);% random jump in X with normal dist
    V21=randn*(-1)^floor(2*randn);% random jump in Y with normal dist
    
    V12=sqrt(12)*rand*(-1)^floor(2*rand);% random jump in X with uniform dist
    V22=sqrt(12)*rand*(-1)^floor(2*rand);% random jump in Y with uniform dist
    
    
    subplot(1,2,1)
    line([Point1(1),Point1(1)+V11], [Point1(2),Point1(2)+V21]); 
    % drawing a path that random walk took with Normal dist
    subplot(1,2,2)
    line([Point2(1),Point2(1)+V12], [Point2(2),Point2(2)+V22]); 
    % drawing a path that random walk took with Uniform dist
    drawnow
     
    subplot(1,2,1) 
    Point1(1)=Point1(1)+V11;% new cooridnates for Norm dist
    Point1(2)=Point1(2)+V21;
    
    subplot(1,2,2)
    Point2(1)=Point2(1)+V12;% new cooridnates for Uniform dist
    Point2(2)=Point2(2)+V22;
    
    subplot(1,2,1)
    plot(Point1(1),Point1(2),'o'); % drawing new coordinte
    hold on
    drawnow
    subplot(1,2,2)
    plot(Point2(1),Point2(2),'o'); % drawing new coordinte
    hold on
    drawnow % graphic function 
    pause(.2) % pause to make animation slower 
    
    
    n=n+1; %increament number of walks
end
