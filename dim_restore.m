clear;

variables = load('C:\Users\Dell\OneDrive\Desktop\2,1\CS215\Assignment 2\data\mnist.mat'); 
variables.digits_train = cast(variables.digits_train(),'double');

N = 60000 ;

count = zeros(10);
mean = zeros(28*28,10) ;
cov = zeros(28*28,28*28,10) ;

for i = 1:N
    count(variables.labels_train(i) +1 ) = count(variables.labels_train(i) +1 ) +1 ;
    mean(:,variables.labels_train(i)+1) = mean(:,variables.labels_train(i)+1) + reshape(variables.digits_train(:,:,i),[28*28,1]) ;
end 

for i = 1:10
    mean(:,i) = mean(:,i)/count(i) ;    
end

for i = 1:N
   cov(:,:,variables.labels_train(i)+1) = cov(:,:,variables.labels_train(i)+1) + (reshape(variables.digits_train(:,:,i),[28*28,1]) - mean(:,variables.labels_train(i)+1))*transpose(reshape(variables.digits_train(:,:,i),[28*28,1]) - mean(:,variables.labels_train(i)+1)) ;   
end

for i = 1:10
    cov(:,:,i) = cov(:,:,i)/count(i) ;
end

for i = 0:9
    nameofdigit = ['Dimensionality Reduction for digit ' num2str(i)];
    ind = find(variables.labels_train == i) ;
    j = ind(1) ;
    N = reshape(variables.digits_train(:,:,j),[28*28,1]) ;
    [eve,eva] = eig(cov(:,:,i+1)) ;
    first = reshape(N,[28,28]) ;
    new_dimension = reduce(N,eva,eve) ;
    new_dimension_2 = regenerate(new_dimension,eva,eve) ;
    second = reshape(new_dimension_2,[28,28]) ;
    figure ;
    imagesc([first,second]) ; 
    title(nameofdigit) ;
end 

function [x] = reduce(X,evanot,evenot)
    x = zeros(84,1);
    eve = zeros(28*28,84) ;
    eva = zeros(84) ;
    [~,ind] = sort(diag(evanot),'descend') ;
    evalue = evanot(ind,ind) ;
    evector = evenot(:,ind) ;
    for i =1:84
        eva(i) = eva(i) + evalue(i,i) ;
        eve(:,i) = eve(:,i) + evector(:,i) ;
    end 
    for i =1:84
        x(i,1) = x(i,1) + transpose(X)*eve(:,i) ;
    end 
end 

function [x] = regenerate(Y,evanot,evenot)
    x = zeros(28*28,1) ;
    eve = zeros(28*28,84) ;
    eva = zeros(84) ;
    [~,ind] = sort(diag(evanot),'descend') ;
    evalue = evanot(ind,ind) ;
    evector = evenot(:,ind) ;
    for i =1:84
        eve(:,i) = evector(:,i) ;
        eva(i) = eva(i) + evalue(i,i) ;
    end 
    for i =1:84
        x = x + Y(i,1)*eve(:,i) ;
    end
end 
