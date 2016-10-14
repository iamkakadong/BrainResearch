bar(m)
hold on
errorbar([1:3],m,s, '.r');
set(gca, 'XTickLabel', {'Elastic Net', 'PCA + Elastic Net', 'Correlation + Elastic Net'})
ylabel('Average test r^2');
title('Mean and confidence inverval of r^2 for different models');
legend('mean', '95% confidence interval');