function [model] = cor_train(X, y, params)
	cr = corr(X, y);
	[~, ord] = sort(cr, 1, 'descend');
	idx = ord(1:params.DFmax);
	Xn = X(:, idx);
	% model.b = lin_reg_train(Xn, y, {});
	model.b = ridge_train(Xn, y, params);
	model.idx = idx;
end