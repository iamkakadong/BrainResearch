if (~exist('subset'))
	subset = [];
elseif (length(subset) ~= 2)
	fprintf('Incorrect subset size');
	return
end

config;
thresh = 3;

data = load_new(train_subs, trial_idxs, thresh, vmask);

tmp = struct;
tmp.X = [];
tmp.y = [];
subject_range = [];

for i = 1:length(data)
	tmp2 = [data{i}.c, data{i}.X];
	tmp.X = [tmp.X; tmp2];
	tmp.y = [tmp.y; data{i}.y];
	subject_range = [subject_range, length(data{i}.y)];
end

data = tmp;
subject_range = cumsum(subject_range);

DFmax = 10000;
l_alpha = [0.001, 0.01, 0.1, 0.9];
params = cell(numel(DFmax) * numel(l_alpha), 1);

idx = 1;
for i = 1:length(DFmax)
	for j = 1:length(l_alpha)
		param = struct;
		param.DFmax = DFmax(i);
		% param.k = [0, 0.01, 0.1, 1];
		param.alpha = l_alpha(j);
		param.cv_num = 14;
		opts = statset('UseParallel', true);
		param.opts = opts;
		%params{(i - 1) * length(DFmax) + j} = param;
		params{idx} = param;
		idx = idx + 1;
	end
end

fprintf('performing cross-validation...\n')
%data = struct;
%data.X = X;
%data.y = y;
task = 'regression';
cv_result = cross_validate(data, subject_range, @elas_net_train, @elas_net_pred, params, @my_r2, task, subset);
fprintf('finished cross-validation\n');


if (length(subset) == 0)
	filename = '/home/tren/BrainResearch/New_results/elas_net/elas_net_all_nnew.mat';
else
	filename = strcat('/home/tren/BrainResearch/New_results/elas_net/elas_net_', num2str(subset(1)), '_to_', num2str(subset(2)), '.mat');
end
save(filename, 'cv_result');
