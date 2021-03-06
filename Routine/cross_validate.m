function [ cv_result ] = cross_validate( data, subject_range, trainer, predictor, parameters, evaluator, task, subset )
%CROSS_VALIDATE Summary of this function goes here
%   Detailed explanation goes here:

%	data contains two fields X: n * p and y: n * 1
%	subject_range contains the last index for each subject in data
% 	trainer is a function that takes in X and y, and outputs a model
%	predictor is a function that takes in a X and a model, and outputs a prediction
%	parameters contains configurations of parameter needed by trainer
%	evaluator is used to evaluate the prediction for each round of cross-validation

try
n_subjects = length(subject_range);
n_parameters = length(parameters);
if (length(subset) == 0)
	beg_sub = 1;
	end_sub = n_subjects;
else
	beg_sub = subset(1);
	end_sub = subset(2);
end

if (n_parameters == 0)
	parameters = cell(1);
	parameters{1} = 0;
	n_parameters = 1;
end

% if isequal(task, 'classification')
% 	en_res = load('../Results/elas_net/elas_net_all.mat');
% 	en_res = en_res.cv_result_all;
% 	idxs = zeros(length(en_res{1}.model), length(en_res));
% 	for i = 1:length(en_res)
% 		idxs(:, i) = en_res{i}.model~=0;
% 	end
% end

cv_result = cell(n_parameters, n_subjects);

size(data.X)

for j = beg_sub : end_sub
	if (j == 1) 
		idx_range = (subject_range(j) + 1) : subject_range(n_subjects); 
		cv_idx_range = 1 : subject_range(j);
	else 
		idx_range = [1 : subject_range(j - 1), (subject_range(j) + 1) : subject_range(n_subjects)]; 
		cv_idx_range = (subject_range(j - 1) + 1) : subject_range(j);
	end

	X_train = data.X(idx_range, :);
	y_train = data.y(idx_range, :);
	X_cv = data.X(cv_idx_range, :);
	y_cv = data.y(cv_idx_range, :);
	
	if isequal(task, 'classification')
		y_train_cong = (y_train == 2);
		y_train_incong = (y_train == 0);
		y_cv_cong = (y_cv == 2);
		y_cv_incong = (y_cv == 0);
		X_train = X_train(y_train_cong~=0 + y_train_incong~=0, :);
		y_train = y_train(y_train_cong~=0 + y_train_incong~=0, :) / 2;
		X_cv = X_cv(y_cv_cong~=0 + y_cv_incong~=0, :);
		y_cv = y_cv(y_cv_cong~=0 + y_cv_incong~=0, :) / 2;
	end

	if isequal(trainer, @pca_train)
		[coeff, score, ~, ~, explained] = pca(X_train);
		X_train = score;
		X_cv = bsxfun(@minus, X_cv, mean(X_cv)) * coeff;
	end

	for i = 1 : n_parameters
		fprintf('cross-validating subject %d with parameter set #%d... \n', [j,i]);

		model = trainer(X_train, y_train, parameters{i});
		y_pred = predictor(X_cv, model);
		score = evaluator(y_cv, y_pred);

		res = struct;
		res.score = score;
		res.model = model;
		res.pred = y_pred;
		res.param = parameters{i};
		res.truth = y_cv;
		
		cv_result{i, j} = res;
		fprintf('subject %d has score %0.3d under configuartion %d\n', [j, score, i]);
	end
end

catch ME
	rethrow(ME);
	return
end

end
