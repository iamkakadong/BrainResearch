if (~exist('subset'))
	subset = [];
elseif (length(subset) ~= 2)
	fprintf('Incorrect subset size');
	return
end

addpath(genpath('../../BrainResearch'));
load_outside_functions;

subject_idx = [151 152 153 158 159 160 171 173 175 176 187 188 189 177 12 13 6 181 182 183 184 186 190 191 192 193 194 196];

fprintf('loading data...\n')
%[X, y, event_types, subject_range, final_mask] = load_data(subject_idx, 0);
load data;
% X = [event_types; X]';
% X = [ones(n, 1), X];
X = X';
y = event_types' + 1;
% y = y';	% n * 1
fprintf('finished loading data\n')

DFmax = [50, 250, 500, 1000];
%l_alpha = [0.9, 0.1, 0.01, 0.001];
l_alpha = 0.0001;
params = cell(numel(DFmax) * numel(l_alpha), 1);

idx = 1;
for i = 1:length(DFmax)
	for j = 1:length(l_alpha)
		param = struct;
		param.DFmax = DFmax(i);
		% param.k = [0, 0.01, 0.1, 1];
		param.alpha = l_alpha(j);
		param.cv_num = 26;
		opts = statset('UseParallel', true);
		param.opts = opts;
		params{idx} = param;
		idx = idx + 1;
	end
end

fprintf('performing cross-validation...\n')
data = struct;
data.X = X;
data.y = y;
task = 'classification';
cv_result = cross_validate(data, subject_range, @corr_lr_train, @corr_lr_pred, params, @my_acc, task, subset);
fprintf('finished cross-validation\n');


if (length(subset) == 0)
	filename = '../Results/corr_cl/corr_cl_new.mat';
else
	filename = strcat('../Results/corr_cl/corr_cl_ridge', num2str(subset(1)), '_to_', num2str(subset(2)), '.mat');
end
save(filename, 'cv_result');
