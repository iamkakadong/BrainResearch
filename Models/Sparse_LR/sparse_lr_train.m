function [model] = sparse_lr_train(X, y, params)
	[nx, px] = size(X);
	[ny, py] = size(y);
	assert(nx == ny, 'invalid input: number of observations does not match.');

	[b, stats] = lassoglm(X, y, 'binomial', 'Alpha', params.alpha, 'CV', params.cv_num, 'Options', params.opts, 'DFmax', params.DFmax);

	b = b(:, stats.IndexMinDeviance);
	model = b;
	% options = glmnetSet;
	% options.alpha = params.alpha;
	% options.dfmax = params.DFmax;
	% model = cvglmnet(X, y, 'binomial', options, [], params.cv_num, [], true);
end