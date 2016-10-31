function [model] = svm_train(X, y, params)
	[nx, px] = size(X);
	[ny, py] = size(y);
	assert(nx == ny, 'invalid input: number of observations does not match.');

	model = fitcsvm(X, y, 'KernelFunction', params.kf, 'Standardize', true, 'CrossVal', 'on', 'KFold', 20, 'KernelScale', 'auto', 'Verbose', 1);

	b = b(:, stats.IndexMinDeviance);
	model = b;
end