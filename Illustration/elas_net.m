load('../Results/elas_net/elas_net_combined.mat');

[m, n] = size(cv_result);
rs = zeros(m, n);
for i = 1:m
    for j = 1:n
        rs(i,j) = cv_result{i,j}.score;
    end
end

H = plot(rs');
xlabel('subject idx');
ylabel('test r^2');
title('Test r^2 of Elastic Net Regression');
legend(labels);
% 
% hist(dn(:,end));
% xlabel('r^2 on test set');
% ylabel('# of subjects');
% title('Histogram of r^2 using PCA + Elastic Net with \alpha = 0.001');