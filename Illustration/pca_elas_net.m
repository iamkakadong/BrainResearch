load('../Results/pca_elas_net.mat');

H = plot(dn);
xlabel('subject idx');
ylabel('test r^2');
title('PCA + Regularized Regression');
legend(labels);

hist(dn(:,end));
xlabel('r^2 on test set');
ylabel('# of subjects');
title('Histogram of r^2 using PCA + Elastic Net with \alpha = 0.001');