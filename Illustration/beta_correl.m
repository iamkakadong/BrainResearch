cr = load('../Results/correlations.mat');
cr = cr.cr;
cv_result = load('../Results/elas_net/elas_net_nocondition_a1e-1.mat');
cv_result = cv_result.cv_result_all;

p = length(cv_result{1}.model);
model = zeros(p, 1);
for i = 1:28
    model = model + cv_result{i}.model;
end
model = model / 28;
cr = cr(2:end);
model = model(2:end);
scatter(model(model~=0), cr(model~=0))
xlabel('average learned weight across 28 trails');
ylabel('correlation to response');
title('average learned weight vs. correlation to response');