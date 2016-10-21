% clear all

if (~exist('subset'))
	subset = [];
elseif (length(subset) ~= 2)
	fprintf('Incorrect subset size');
	% break
end

addpath(genpath('../../Toolbox'));
load_outside_functions;

subject_idx = [151 152 153 158 159 160 171 173 175 176 187 188 189 177 12 13 6 181 182 183 184 186 190 191 192 193 194 196];

fprintf('loading data...\n')
%[X, y, event_types, subject_range, final_mask] = load_data(subject_idx, 0);
load data;
%X = [event_types; X]';	% n * p
X = X';
y = y';	% n * 1
fprintf('finished loading data\n')

fprintf('normalizing data...\n')
last_idx = 0;
for i = 1:length(subject_idx)
	y(last_idx + 1 : subject_range(i)) = normalize_feature(y(last_idx + 1 : subject_range(i)));
	last_idx = subject_range(i);
end
fprintf('finished normalization\n')

%l_alpha = [0.9, 0.5, 0.1];
l_alpha = [0.01, 0.001];
DFmax = 1000;
cv_num = 10;

params = cell(numel(l_alpha) * numel(DFmax) * numel(cv_num), 1);

parpool(4);
idx = 1;
for i = 1 : numel(l_alpha)
	for j = 1 : numel(DFmax)
		for k = 1 : numel(cv_num)
			param = struct;
			param.alpha = l_alpha(i);
			param.DFmax = DFmax(j);
			param.cv_num = cv_num(k);
			opts = statset('UseParallel', true);
			param.opts = opts;
			params{idx} = param;
			idx = idx + 1;
		end
	end
end

data = struct;
data.X = X;
data.y = y;

try
	fprintf('evaluating elastic net...\n')
	tic;
	cv_result = cross_validate(data, subject_range, @elas_net_train, @elas_net_pred, params, @my_r2, subset);
	toc
	fprintf('finished evaluating elastic net\n')
catch ME
	rethrow(ME);
	delete(gcp('nocreate'));
end

if (length(subset) == 0)
	filename = '../Results/elas_net/elas_net_all.mat';
else
	filename = strcat('../Results/elas_net/nnn_elas_net_', num2str(subset(1)), '_to_', num2str(subset(2)), '.mat');
end
save(filename, 'cv_result');

delete(gcp('nocreate'));
