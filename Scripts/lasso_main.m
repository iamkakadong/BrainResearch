clear all

addpath(genpath('../../Toolbox'));
load_outside_functions;

subject_idx = [151 152 153 158 159 160 171 173 175 176 187 188 189 177 12 13 6 181 182 183 184 186 190 191 192 193 194 196];

fprintf('loading data...\n')
[X, y, event_types, subject_range, final_mask] = load_data(subject_idx, 0);
X = [event_types; X]';
y = y';
fprintf('finished loading data\n')

fprintf('normalizing data...\n')
last_idx = 0;
for i = 1:length(subject_idx)
	y(last_idx + 1 : subject_range(i)) = normalize_feature(y(last_idx + 1 : subject_range(i)));
	last_idx = subject_range(i);
end
X = normalize(X);
fprintf('finished normalization\n')

param = struct;
% param.alpha = 0.9;
% param.DFmax = 1000;
param.cv_num = 10;
matlabpool(1);
opts = statset('UseParallel', true);
param.opts = opts;
param = {param};

data = struct;
data.X = X;
data.y = y;

try
	fprintf('Performing cross-validation...\n')
	tic;
	cv_result = cross_validate(data, subject_range, @lasso_train, @lasso_pred, param, @my_r2);
	toc
	fprintf('finished cross-validation\n')
catch
	matlabpool close;
end
	
matlabpool close;