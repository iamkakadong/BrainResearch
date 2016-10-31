function [model] = corr_lr_train(X, y, param)
	cr = corr(X, y);
	[~, ord] = sort(abs(cr), 1, 'descend');
	idx = ord(1:params.DFmax);
	Xn = X(:, idx);
	model.b = sparse_lr_train(Xn, y, param);
	model.idx = idx;
end