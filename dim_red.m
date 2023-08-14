vars = load('C:\Users\Dell\OneDrive\Desktop\2,1\CS215\Assignment 2\data\mnist.mat');
labels_train = vars.labels_train;
digits_train = vars.digits_train;
digits_traindouble = cast(digits_train,'double'); %this converts it into floating-point type

covm = zeros(28*28,28*28,10); %this is the covariance matrix for each digit
eve = zeros(28*28,28*28,10);

mu = zeros(28*28,10); %this matrix stores the mean for each digit
eva = zeros(28*28,28*28,10);

notimes = zeros(1,10); %this will store the number of times each digit appears

%Now, we will find value of a specific image
for i = 1:60000
    k = labels_train(i);
    notimes(1,k+1)= notimes(1,k+1) + 1;
    reshapedm = reshape(digits_traindouble(:,:,i),[28*28,1]);
    mu(:,k+1) = mu(:,k+1) + reshapedm;
    covm(:,:,k+1) = covm(:,:,k+1) + reshapedm*transpose(reshapedm);
end

for i = 1:10
    mu(:,i) = (1/notimes(1,i))*mu(:,i);
    covm(:,:,i) = (1/notimes(1,i))*covm(:,:,i);
end

%sorted eigen values matrix of each digit
sortedeva = zeros(28*28,10);

%maximal variance direction vectors matrix of each digit
mvd = zeros(28*28,10);
for i = 1:10
    covm(:,:,i) = covm(:,:,i)-mu(:,i)*transpose(mu(:,i));
    [eve(:,:,i),eva(:,:,i)] = eig(covm(:,:,i));
    sortedeva(:,i) = sort(diag(eva(:,:,i)),'descend');
    maxeigenarray = (find(diag(eva(:,:,i))==sortedeva(1,i)));
    maxeigen = maxeigenarray(1);
    mvd(:,i) = eve(:,maxeigen,i);
end

for i=1:10
    sorted1 = sortedeva(1,i);
    figure('Name','PCA');
    plot1 = mu(:,i) - sorted1^(0.5) * mvd(:,i);
    imagearray1 = reshape(plot1,[28,28]);
    
    plot2 = mu(:,i);
    imagearray2 = reshape(plot2,[28,28]);
    
    plot3 = mu(:,i) + sorted1^(0.5) * mvd(:,i);
    imagearray3 = reshape(plot3,[28,28]);
    imagesc([imagearray1 imagearray2 imagearray3]);
end

x = linspace(1,784,784);
for i=1:10
    figure('Name','Decreasing order of eigen values');
    scatter(x,sortedeva(:,i));
    title('Decreasing order of eigen values');
    ylabel('Eigen Values');
end
    