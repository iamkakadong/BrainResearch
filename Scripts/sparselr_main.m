% clear all

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
load data;

X = X';
[n, p] = size(X);
X = [ones(n, 1), y', X];
y = event_types' + 1;
% y_cong = (y == 2);
% y_incong = (y == 0);
% X = X(y_cong~=0 + y_incong~=0, :);
% y = y(y_cong~=0 + y_incong~=0, :);
fprintf('finished loading data\n')

%l_alpha = [0.9, 0.1, 0.01, 0.001];
%l_alpha = [0.9, 0.1, 0.01];
l_alpha = 0.01;
DFmax = 3000;
cv_num = 10;

params = cell(numel(l_alpha) * numel(DFmax) * numel(cv_num), 1);

%matlabpool(4);
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
task = 'classification';

try
	fprintf('evaluating elastic net...\n')
	tic;
	cv_result = cross_validate(data, subject_range, @sparse_lr_train, @sparse_lr_pred, params, @my_acc, task, subset);
	toc
	fprintf('finished evaluating elastic net\n')
catch ME
	rethrow(ME);
	% parpool close;
	delete(gcp('nocreate'));
end

if (length(subset) == 0)
	filename = '../Results/sparse_lr_all.mat';
else
	filename = strcat('../Results/sparse_lr/sparse_lr_rt_', num2str(subset(1)), '_to_', num2str(subset(2)), '.mat');
end
save(filename, 'cv_result');

% parpool close;
delete(gcp('nocreate'));
