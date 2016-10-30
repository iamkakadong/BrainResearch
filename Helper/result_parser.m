%% Establish result dimension
l = zeros(1,28);
for i = 1:28
%     s = strcat('nnn_elas_net_', num2str(i), '_to_', num2str(i), '.mat');
    s = strcat('pc_', num2str(i), '_to_', num2str(i), '.mat');
    load(s);
    l(i) = size(cv_result, 1);
end

%% Build results
results = cell(4,28);
for i = 1:28
    s = strcat('nn_sparse_lr_', num2str(i), '_to_', num2str(i), '.mat');
    load(s);
    if (l(i) == 2)
        for j = 1:2
            results{j+1,i} = cv_result{j,i};
        end
    else
        for j = 1:4
            results{j,i} = cv_result{j,i};
        end
    end
end

%% Save results
j = 4;   % ROW NUMBER
cv_results_all = cell(1, 28);
for i = 1:28
    cv_results_all{i} = results{j, i};
end
name = input('What is the filename you want to save for cv_results_all?\n', 's');
save(name, 'cv_results_all');

%% Load results
f = input('What is the result file you want to load?\n', 's');
load(f);

%% Process results for scores
model = zeros(length(cv_results_all{1}.model), 28);
score = zeros(1, 28);

for i = 1:28
    model(:,i) = cv_results_all{i}.model;
    score(i) = cv_results_all{i}.score;
end

m = mean(model, 2);
s = std(model, [], 2);
pct = model > 0;
nct = model < 0;
pct = sum(pct, 2);
nct = sum(nct, 2);
ct = pct - nct;

%% Convert to 3d matrix
load('../fullmask.mat');
coeff_img = reverse_mask(m(2:end), mymask);
ct_img = reverse_mask(ct(2:end), mymask);
coeff_file = input('what is the filename for storing visualize coefficient?\n(Do not include suffix)\n', 's');
ct_file = input('what is the filename for storing visualize count?(Do not include suffix)\n', 's');
save(strcat(coeff_file, '.mat'), 'coeff_img');
save(strcat(ct_file, '.mat'), 'ct_img');

%% Convert to nii file
mat2nii(strcat(coeff_file, '.mat'), '../wmeanepi_Stroop_iPAT1.88PMU.nii');
mat2nii(strcat(ct_file, '.mat'), '../wmeanepi_Stroop_iPAT1.88PMU.nii');