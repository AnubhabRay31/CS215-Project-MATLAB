clear;

firstsum = zeros(19200,1);  
for i = 1:16 %finding mean
    imagelocations = ['C:\Users\Dell\OneDrive\Desktop\2,1\CS215\Assignment 2\data\data_fruit\image_' num2str(i) '.png'];
    images = imread(imagelocations);  
    reshapedimage = double(reshape(images,[19200,1]));  
    firstsum = firstsum + reshapedimage;  
end
mean = firstsum/16;  %mean of all images


secondsum = zeros(19200,1);
arr_resized_image = zeros(19200,16);
for i = 1:16  %finding standard deviation
    imagelocations = ['C:\Users\Dell\OneDrive\Desktop\2,1\CS215\Assignment 2\data\data_fruit\image_' num2str(i) '.png'];
    images = imread(imagelocations);
    reshapedimage = double(reshape(images,[19200,1]));
    secondsum = secondsum + (reshapedimage-mean).^2;
    arr_resized_image(:,i) = reshapedimage;
end
sd = sqrt(secondsum/16);

stdm = zeros(19200,16);
for i=1:19200  %finding standardized matrix
    stdm(i,:) = (arr_resized_image(i,:)-mean(i))/sd(i);
end

tempm = stdm*transpose(stdm);
covm = tempm/16;  %19200x19200 matrix
[eve,eva] = eigs(covm,4);  %finds and stores the 4 largest eigenvalues in descending order in diagonal of matrix D, and corresponding eigenvectors in V 

subplot(2,3,1)  
image(rescale(reshape(mean,[80,80,3])))

for i=1:4
    subplot(2,3,i+1)  
    image(rescale(reshape(eve(:,i),[80,80,3])))  
end

evades = eigs(covm,10);
figure();
plot(1:1:10,evades,'linestyle','none','marker','o','linewidth',2);
title('Top 10 EigenValues');
xlabel('N ->','FontWeight','bold');
ylabel('EigenValue','FontWeight','bold');

for i=1:16
    figure();
    subplot(2,2,1)
    image(rescale(reshape(arr_resized_image(:,i),[80,80,3])))
    title('Original fruit');
    
    eigen1 = transpose(arr_resized_image(:,i))*eve(:,1);  
    eigen2 = transpose(arr_resized_image(:,i))*eve(:,2);  
    eigen3 = transpose(arr_resized_image(:,i))*eve(:,3);  
    eigen4 = transpose(arr_resized_image(:,i))*eve(:,4);
    
    mean1 = transpose(mean)*eve(:,1);  
    mean2 = transpose(mean)*eve(:,2);  
    mean3 = transpose(mean)*eve(:,3);  
    mean4 = transpose(mean)*eve(:,4);  
    mean5 = transpose(arr_resized_image(:,i))*mean;  
    mean6 = transpose(mean)*mean;  
    alpha = (mean5-(eigen1*mean1)-(eigen2*mean2)-(eigen3*mean3)-(eigen4*mean4))/((mean6-(mean1)^2-(mean2)^2-(mean3)^2-(mean4)^2)); 
    images = (alpha*mean)+((eigen1-(alpha*mean1))*eve(:,1))+((eigen2-(alpha*mean2))*eve(:,2))+((eigen3-(alpha*mean3))*eve(:,3))+((eigen4-(alpha*mean4))*eve(:,4));   
    
    subplot(2,2,2)
    image(rescale(reshape(images,[80,80,3])))
    title('Closest representation of fruit');
end


randimages = [6,10,14];  

for imagenum=1:3
    i = randimages(imagenum);
    vector = arr_resized_image(:,i)-mean(i); %normalizing the data
    evewgts = zeros(4,1);
    for l=1:4
        evewgts(l) = transpose(vector)*eve(:,l);
    end
    thirdsum = zeros(19200,1);
    for l=1:4
        thirdsum = thirdsum + (evewgts(l)*eve(:,l));
    end
    images = mean + thirdsum;  
    figure('Name','Newly generated fruit');
    image(rescale(reshape(images,[80,80,3])))
    title('Newly generated fruit');
end