function [b] = lasso_train(X, y, params)
	% X should be n * p
	% y should be n * 1
	[nx, px] = size(X);
	[ny, py] = size(y);
	assert(nx == ny, 'invalid input: number of observations does not match.');
	
	[b, fitinfo] = lasso(X, y, 'Standardize', true, ...
		'CV', params.cv_num, 'Options');
	b = b(:, fitinfo.IndexMinMSE);
end