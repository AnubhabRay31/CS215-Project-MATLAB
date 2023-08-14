clear;
rng(1);
% so that each time same outputs are created
N  = 10000000;

theta = rand(1,N)*2*pi;
% rand() generates numbers from a 
%uniform distribution over [0,1)

Max_Radius = 2 ./ sqrt(1 + 3.*(sin(theta)).^2 );

radius = Max_Radius .* sqrt(rand(1,N));

x = radius .* cos(theta);
y = radius .* sin(theta);


histogram2(x,y,100,"DisplayStyle","tile");
axis equal;
xlabel("X");
ylabel("Y");
