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

cv_result = cell(n_parameters, n_subjects);

fprintf('\tthe design matrix has dimension %d x %d\n', size(data.X));

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

	for i = 1 : n_parameters
		fprintf('\tcross-validating subject %d with parameter set #%d... \n', [j,i]);

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
		fprintf('\tsubject %d has score %0.3d under configuartion %d\n', [j, score, i]);
	end
end

catch ME
	rethrow(ME);
	return
end

end
