
subset = [];

addpath(genpath('../../BrainResearch'));
load_outside_functions;

subject_idx = [151 152 153 158 159 160 171 173 175 176 187 188 189 177 12 13 6 181 182 183 184 186 190 191 192 193 194 196];

fprintf('loading data...\n')
%[X, y, event_types, subject_range, final_mask] = load_data(subject_idx, 0);
load data;
X = [event_types; X]';
y = y';	% n * 1
fprintf('finished loading data\n')


fprintf('normalizing data...\n')
last_idx = 0;
for i = 1:length(subject_idx)
	y(last_idx + 1 : subject_range(i)) = normalize_feature(y(last_idx + 1 : subject_range(i)));
	last_idx = subject_range(i);
end
fprintf('finished normalization\n')


DFmax = [500, 1000, 2000, 3000];
params = cell(numel(DFmax), 1);

for i = 1:length(DFmax)
	param = struct;
	param.DFmax = DFmax;
	params{i} = param;
end

fprintf('performing cross-validation...\n')
data = struct;
data.X = X;
data.y = y;
cv_results = cross_validate(data, subject_range, @cor_train, @cor_pred, params, @my_r2, subset);
fprintf('finished cross-validation\n');


if (length(subset) == 0)
	filename = '../Results/corr_vs/corr_vs_all.mat';
else
	filename = strcat('../Results/corr_vs/corr_vs_', num2str(subset(1)), '_to_', num2str(subset(2)), '.mat');
end
save(filename, 'cv_result');