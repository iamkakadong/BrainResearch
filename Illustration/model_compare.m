% bar(m)
% hold on
% errorbar([1:3],m,s, '.r');
% set(gca, 'XTickLabel', {'Elastic Net', 'PCA + Elastic Net', 'Correlation + Elastic Net'})
% ylabel('Average test r^2');
% title('Mean and confidence inverval of r^2 for different models');
% legend('mean', '95% confidence interval');

load('../Results/regression_all.mat');
boxplot(scores_all, 'colorgroup', [1,1,1,1,2,2,2,2,3,3,3,3], 'boxstyle', 'filled', 'medianstyle', 'target', 'whisker', 0.7193, 'labels', labels)
box_vars = findall(gca,'Tag','Box');
hLegend = legend(box_vars([9,5,1]), {'Correlation-vs','Elastic Net','PCA + Elastic Net'});
title('Test r^2 of regression')