%when initialize the model, set train = 1,after getting the model, set
%train = 0
addpath(genpath('test_images'));
addpath(genpath('train_images')); 
train = 0;
k = 7;
%get model from train_data
if train == 1
    train_data = load('train_data');
    train_data = rot90(train_data.train_data);
    model = trainGMM(train_data,k);
%use model to get probility matrix of test images
else
    x = [];
    depth = [];
    train_data = load('train_data');
    train_data = rot90(train_data.train_data);
    model = load('GMModel');
    model = model.theta;
    for i = 1:8
        %read image
        img = imread([num2str(i,'%d'),'.jpg']);
        str = [num2str(i),' new.jpg'];
        %get pro matrix
        new_img = testGMM(img,model,k);
        disp('processing image');
        imwrite(new_img,str);
        subplot(1,2,1);
        imshow(img);
        subplot(1,2,2);
        imshow(new_img);
        %get the ball region,l is all connected regions, S is area of these
        %regions, area is the biggest region
        l = bwlabel(im2bw(new_img),4);
        S = regionprops(l,'Area');
        area = max([S.Area]);
        x = [x;area];
        %get depth corresponding to the area
        y = MeasureDepth(new_img);
        depth = [depth;y];
        save('test_depth','depth');
    end
    %plotGMM
    n = plotGMM(train_data,model,k);
end

