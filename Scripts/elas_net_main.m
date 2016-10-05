clear all

addpath(genpath('../../Toolbox'));
load_outside_functions;

subject_idx = [151 152 153 158 159 160 171 173 175 176 187 188 189 177 12 13 6 181 182 183 184 186 190 191 192 193 194 196];

fprintf('loading data...\n')
[X, y, event_types, subject_range, final_mask] = load_data(subject_idx, 0);
X = [event_types; X]';	% n * p
y = y';	% n * 1
fprintf('finished loading data\n')

fprintf('normalizing data...\n')
last_idx = 0;
for i = 1:length(subject_idx)
	y(last_idx + 1 : subject_range(i)) = normalize_feature(y(last_idx + 1 : subject_range(i)));
	last_idx = subject_range(i);
end
fprintf('finished normalization\n')

l_alpha = [0.9, 0.6, 0.3, 0.1];
DFmax = 1000;
cv_num = 10;

params = cell(numel(l_alpha) * numel(DFmax) * numel(cv_num), 1);

% matlabpool(2);
idx = 1;
for i = 1 : numel(l_alpha)
	for j = 1 : numel(DFmax)
		for k = 1 : numel(cv_num)
			param = struct;
			param.alpha = l_alpha(i);
			param.DFmax = DFmax(j);
			param.cv_num = cv_num(k);
			% opts = statset('UseParallel', true);
			% param.opts = opts;
			params{idx} = param;
			idx = idx + 1;
		end
	end
end

% param = struct;
% param.alpha = 0.9;
% param.DFmax = 1000;
% param.cv_num = 10;
% matlabpool(1);
% opts = statset('UseParallel', true);
% param.opts = opts;

data = struct;
data.X = X;
data.y = y;

try
	fprintf('evaluating elastic net...\n')
	tic;
	cv_result = cross_validate(data, subject_range, @elas_net_train, @elas_net_pred, params, @my_r2);
	toc
	fprintf('finished evaluating elastic net\n')
catch ME
	rethrow(ME);
	% matlabpool close;
end
	
% matlabpool close;