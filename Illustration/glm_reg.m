% corr_based_regression;
% corr_vs_scores = scores(1:2,:)';

load('../Results/elas_net/elas_net_all.mat');
[np, nt] = size(cv_result_all);
scores = zeros(np, nt);
for i = 1:np
    for j = 1:nt
        scores(i,j) = cv_result_all{i,j}.score;
    end
end

hist(scores);
xlabel('r^2 on test set');
ylabel('# of subjects');
title('Histogram of r^2 using Elastic Net with \alpha = 0.9');
% scores = [scores', corr_vs_scores];
% 
% m = mean(scores);
% s = std(scores);
% 
% H = bar(m);
% hold on
% xtick = zeros(nt, 1);
% for i = 1:3
%     plot(xtick+i, scores(:,i), '.r');
% end
% 
% plot(scores');
% xlabel('test subject index');
% ylabel('test r^2');
% title('Testing r^2 of correlation-based variable selction + linear regression');
% legend('top-500', 'top-1000', 'top-2000');