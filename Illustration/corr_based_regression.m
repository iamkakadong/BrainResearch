load('../Results/corr_vs/corr_vs_all.mat');
[np, nt] = size(cv_result);
scores = zeros(np-1, nt);
for i = 1:np-1
    for j = 1:nt
        scores(i,j) = cv_result{i,j}.score;
    end
end

plot(scores');
xlabel('test subject index');
ylabel('test r^2');
title('Testing r^2 of correlation-based variable selction + linear regression');
legend('top-500', 'top-1000', 'top-2000');