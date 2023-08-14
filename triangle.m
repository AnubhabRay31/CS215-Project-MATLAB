clear;
rng(1);
% so that each time same outputs are created
N  = 10000000;

y = exp(1) * rand(1,N);
% rand() generates numbers from a
% uniform distribution over [0,1)

x_min = pi.*y./(3*exp(1));
x_max = pi.*(1-2.*y./(3*exp(1)));
x = x_min + (x_max - x_min).*rand(1,N);


histogram2(x,y,100,"DisplayStyle","tile");

axis equal;
xlabel("X");
ylabel("Y");
