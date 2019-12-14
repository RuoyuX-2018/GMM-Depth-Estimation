function k = plotGMM(train_data,theta,k)
    train_data = rot90(train_data,-1);
    %new a figure
    figure;
    %draw a 3D scatter plot
    scatter3(train_data(:, 1), train_data(:, 2),train_data(:,3));
    figure;
    %draw all gaussian ellipsoids
    for i = 1:k
        data_mean = rot90(theta{i,1});
        data_cov = theta{i,2};
        [x, y, z] = ellipsoid(data_mean(1), data_mean(2), data_mean(3), data_cov(3,3)/100, data_cov(1, 1)/100, data_cov(2,2)/100);
        surf(x,y,z);
        hold on;
    end
    hold off;
end


