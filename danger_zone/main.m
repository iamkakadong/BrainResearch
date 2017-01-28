%% Step 1. Build the mask for removing invalid data
fprintf('building mask for dataset...\n');
build_mask;

%% Step 2. Load data for analysis
fprintf('loading data for analysis...\n');
config;
data = load_new(train_subs, trial_idxs, thresh, vmask);
tX = []; ty = []; tc = []; t4 = [];
for i = 1:numel(data)
	tX = [tX; data{i}.X];
	ty = [ty; data{i}.y];
	tc = [tc; data{i}.c];
	tl = [tl; data{i}.l];
end
clear data;

%% Step 3. PCA + regression
% transform feature to pc score and join with task conditions
fprintf('performing pca...\n');
prop = 0.8;
[coeff, score, latent, tsquared, explained] = pca(tX);
tmp = cumsum(explained);
[~, idx] = min(find(tmp > prop));
features = [tc, score(:, :idx)];

% define parameters for regression
fprintf('define model hyper-parameters...\n');
data.X = features;
data.y = ty;
subject_range = cumsum(tl);
trainer = @elas_net_train;
predictor = @elas_net_pred;
l_alpha = [0.9, 0.1, 0.01, 0.001];
use_parallel = true;
cv_num = 10;
parameters = cell(numel(l_alpha), 1);
for i = numel(l_alpha)
	param = struct;
	param.alpha = l_alpha(i);
	param.cv_num = cv_num;
	param.opts = statset('UseParallel', use_parallel);
	parameters{i} = param;
end
evaluator = @my_r2;
task = 'regression';

subset = [1, 1];

% perform regression
parpool(2);
try
	fprintf('evaluating elastic net...\n');
	tic;
	cv_result = cross_validate(data, subject_range, trainer, predictor, parameters, evaluator, task, subset);
	toc
	fprintf('finished evaluating elastic net\n');
catch ME
	rethrow(ME);
	delete(gcp('nocreate'));
end
filename = strcat('../Results/danger_zone/pc_elastic_net/', num2str(subset(1)), '_to_', num2str(subset(2)), '.mat');