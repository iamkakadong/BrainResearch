clear all

addpath(genpath('../../Toolbox'));
load_outside_functions;

subject_idx = [151 152 153 158 159 160 171 173 175 176 187 188 189 177 12 13 6 181 182 183 184 186 190 191 192 193 194 196];

fprintf('loading data...')
[X, y, event_types, subject_range, final_mask] = load_data(subject_idx, 0);
X = [event_types; X]';
y = y';
fprintf('finished loading data')

fprintf('normalizing data...')
last_idx = 1;
for i = 1:length(subject_idx)
	y(last_idx : subject_range(i)) = normalize(y(last_idx : subject_range(i)));
end
fprintf('finished normalization')

fprintf('partitioning into training and testing set...')
X_train = X(1:subject_range(i), :);
X_test = X(subject_range(i) + 1 : end, :);
y_train = y(1:subject_range(i), :);
y_test = y(subject_range(i) + 1 : end, :);
fprintf('finished partition')

fprintf('training...')
b = lin_reg_train(X_train, y_train);
fprintf('finished training')

fprintf('predicting on test set...')
pred = lin_reg_pred(X_test, b);
fprintf('finished predicting')

fprintf('evaluating r-sqaure')
rsqr = r2(y_test, pred);

fprintf('r_square = %0.3f', rsqr);