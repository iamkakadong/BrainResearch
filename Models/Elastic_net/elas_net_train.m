function [b, fitinfo] = elas_net_train(X, y, params)
	[b, fitinfo] = lasso(X, y, 'Alpha', params.alpha, 'Standardize', true, ...
		'DFmax', params.DFmax, 'CV', params.cv_num, 'Options', params.opts);
end