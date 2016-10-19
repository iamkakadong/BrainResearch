load('sparse_lr_1_to_4.mat')
cv_result_all = cv_result;
load('sparse_lr_5_to_8.mat')
for i = 5:8
cv_result_all{i} = cv_result{i};
end
load('sparse_lr_9_to_12.mat')
for i = 9:12
cv_result_all{i} = cv_result{i};
end
load('sparse_lr_13_to_16.mat')
for i = 13:16
cv_result_all{i} = cv_result{i};
end
load('sparse_lr_17_to_20.mat')
for i = 17:20
cv_result_all{i} = cv_result{i};
end
load('sparse_lr_21_to_24.mat')
for i = 21:24
cv_result_all{i} = cv_result{i};
end
load('sparse_lr_25_to_28.mat')
for i = 25:28
cv_result_all{i} = cv_result{i};
end
r = zeros(28,1);
for i = 1:28
r(i) = cv_result_all{i}.score;
end