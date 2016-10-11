function [model] = sparse_lr_train(X, y, params)
	options = glmnetSet;
	options.alpha = params.alpha;
	options.dfmax = params.dfmax;
	model = cvglmnet(X, y, 'multinomial', options, [], params.cv_num, [], true);
end