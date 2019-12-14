function theta = trainGMM(train_data,k)
    %theta is the list storing mean, covariance and weights of every
    %gaussian
    theta = {};
    N = size(train_data,2);
    for j = 1:k
        %initialize theta
        rand_idx = randperm(N,100);
        rand_sample = train_data(:,rand_idx);
        sample_mean = rot90(mean(rot90(rand_sample)),-1);
        sample_cov = cov(rot90(rand_sample));
        weight_K = rand;
        theta = [theta;{sample_mean,sample_cov,weight_K}];
    end
    %if true, result converged, end loop
    converge = false;
    while(true)
        %Exception step
        %weight for all gauss
        weight_All = [];
        for j = 1:k
            pro_K = [];
            pro_kk = [];
            for i = 1:N
                %get each pixel's RGB matrix
                pixel = train_data(:,i);
                mean_old = theta{j,1};
                cov_old = theta{j,2};
                weight_old = theta{j,3};
                %calculate f(x|theta)
                Pxj = exp(-0.5*(pixel-mean_old)'*(cov_old^(-1))*(pixel-mean_old))/sqrt((2*pi)^3*det(cov_old));
                pro_kk = [pro_kk Pxj];
                sum = sum_Pxj(theta,pixel,k);
                %calculate P(j|xi,theta)
                Pjx = (weight_old*Pxj)/(sum);
                pro_K = [pro_K Pjx];
            end
        
            weight_All = [weight_All;pro_K];
        end
    
        %Maximization step
        %weight_sum is used to judge convergence
        weight_sum = 0;
        %get the new mean
        for j = 1:k
            sum_mean = 0;
            for i = 1:N
                pixel = train_data(:,i);
                sum_mean = sum_mean + weight_All(j,i)*pixel;
            end
            sum_P = 0;
            for m = 1:N
                sum_P = sum_P + weight_All(j,m);
            end
            mean_new = sum_mean/sum_P;
            theta{j,1} = mean_new;
        
            %get new covariance
            sum_cov = zeros(3);
            for i = 1:N
                pixel = train_data(:,i);
                sum_cov = sum_cov + weight_All(j,i)*(pixel-mean_new)*(pixel-mean_new)';
            end 
            cov_new = sum_cov/sum_P;
            theta{j,2} = cov_new;
        
            %get new weights
            weight_new = sum_P/N;
            %judge convergence
            diff = theta{j,3} - weight_new;
            theta{j,3} = weight_new;
            weight_sum = weight_sum + diff;
        end
        %condition of convergence:the change of weights is less than
        %0.0000001
        if(weight_sum<0.00000001)
            break;
        end
    end
    save('GMModel.mat', 'theta');
end


%calculate the sum of aj*fj(xi|theta)
function sum = sum_Pxj(theta,pixel,k)
    sum = 0;
    for i = 1:k
        mean = theta{i,1};
        cov = theta{i,2};
        weight = theta{i,3};
        Pxj = exp(-0.5*(pixel-mean)'*(cov^(-1))*(pixel-mean))/sqrt((2*pi)^3*det(cov));
        sum = sum + Pxj*weight;
    end
end


        
        
        
          