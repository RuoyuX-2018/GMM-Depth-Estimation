function Yval = MeasureDepth(proMatrix)
    area_measure = findMaxRegion(proMatrix);
    %model = load('GMModel.mat');
    %model = model.theta;
    %img1 = imread('train_images/68.jpg');
    %img2 = imread('train_images/91.jpg');
    %img3 = imread('train_images/106.jpg');
    %img4 = imread('train_images/160.jpg');
    %img5 = imread('train_images/208.jpg');
    %img6 = imread('train_images/223.jpg');
    %img7 = imread('train_images/248.jpg');
    %img8 = imread('train_images/280.jpg');
    %i1 = testGMM(img1,model);
    %i2 = testGMM(img2,model);
    %i3 = testGMM(img3,model);
    %i4 = testGMM(img4,model);
    %i6 = testGMM(img6,model);
    %i7 = testGMM(img7,model);
    %i8 = testGMM(img8,model);
    %img1 = findMaxRegion(i1);
    %img2 = findMaxRegion(i2);
    %img3 = findMaxRegion(i3);
    %img4 = findMaxRegion(i4);
    %img5 = findMaxRegion(i5);
    %img6 = findMaxRegion(i6);
    %img7 = findMaxRegion(i7);
    %img8 = findMaxRegion(i8);
    area_measure = findMaxRegion(proMatrix);
    x = [1665;979;689;541;349;289;214;164;129;110];
    y = [68;91;106;121;152;168;200;223;256;280];
    fitline = fit(x,y,'Exp2');
    Yval = feval(fitline,area_measure);
end

function area = findMaxRegion(img)
     l = bwlabel(im2bw(img),4);
    S = regionprops(l,'Area');
    %max_img = ismember(l,find([S.Area]==max([S.Area])));
    area = max([S.Area]);
end





