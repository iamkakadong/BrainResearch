% Deprecated
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
fprintf('finished normalization\n')

fprintf('performing cross-validation...\n')
data = struct;
data.X = X;
data.y = y;
cv_results = cross_validate(data, subject_range, @lin_reg_train, @lin_reg_pred, {}, @my_r2);
fprintf('finished cross-validation\n');

% fprintf('partitioning into training and testing set...\n')
% X_train = X(subject_range(1) + 1 : end, :);
% X_test = X(1:subject_range(1), :);
% y_train = y(subject_range(1) + 1 : end, :);
% y_test = y(1:subject_range(1), :);
% fprintf('finished partition\n')

% fprintf('training...\n')
% b = lin_reg_train(X_train, y_train);
% fprintf('finished training\n')

% fprintf('predicting on test set...\n')
% pred = lin_reg_pred(X_test, b);
% fprintf('finished predicting\n')

% fprintf('evaluating r-sqaure\n')
% rsqr = my_r2(y_test, pred);

% fprintf('r_square = %0.3f\n', rsqr);