% load orange region data
train_data = load('train_data');
train_data = rot90(train_data.train_data);
img_train = imread('train_images/68.jpg');
img_test = imread('test_images/1.jpg');
%get image after singleGauss process
new_imgTrain = singleGauss(img_train,train_data);
new_imgTest = singleGauss(img_test,train_data);
%draw original image and binary image
subplot(2,2,1);
imshow(img_train);
subplot(2,2,2);
imshow(img_test);
subplot(2,2,3);
imshow(new_imgTrain);
subplot(2,2,4);
imshow(new_imgTest);

function new_img = singleGauss(image,ball_rgb)
    %get mean, covariance matrix
    ball_mean = rot90(mean(rot90(ball_rgb)), -1);
    ball_cov = cov(rot90(ball_rgb));
    img_h = size(image,1);
    img_w = size(image,2);
    new_img = [];
    for i = 1:img_h
        row = [];
        for j = 1:img_w
            %for every pixel in the image, calculate its posterior of being
            %orange
            pixel = [double(image(i, j, 1)); double(image(i, j, 2)); double(image(i, j, 3))];
            posterior = 0.5*exp(-0.5*(pixel-ball_mean)'*(ball_cov^(-1))*(pixel-ball_mean))/sqrt((2*pi)^3*det(ball_cov));
            %set a threshold to get a binary figure
            if posterior < 10^(-19)
                posterior = 1;
            else
                posterior = 0;
            end
            row = [row posterior];
        end
        new_img = [new_img; row];
    end
end