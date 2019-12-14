%using GMModel to train new image, out put is probality matrix
function new_img = testGMM(img,model,k)
    img_h = size(img,1);
    img_w = size(img,2);
    %new_img is probality matrix
    new_img = zeros(img_h,img_w);
    for i = 1:img_h
        for j = 1:img_w
            pixel = [double(img(i,j,1));double(img(i,j,2));double(img(i,j,3))];
            posterior = 0;
            for m = 1:k
                mean = model{m,1};
                cov = model{m,2};
                weight = model{m,3};
                %calculate posterior
                Pxj = exp(-0.5*(pixel-mean)'*(cov^(-1))*(pixel-mean))/sqrt((2*pi)^3*det(cov));
                posterior = posterior + weight*Pxj;
            end
            %use threshold to get a binary image
            if(posterior<10^(-20))
                posterior = 1;
            else
                posterior = 0;
            end
            new_img(i,j) = posterior;
        end
    end
end