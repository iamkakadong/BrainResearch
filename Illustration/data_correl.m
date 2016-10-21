load('../Results/correlations.mat');
hist(cr);
xlabel('Pearson Correlation');
ylabel('# of Features');
title('Histogram of correlation between predictors and response');

hist(pval);
xlabel('p-value of Person Correlation');
ylabel('# of Features');
title('Histogram of p-value of correlations between predictors and response');