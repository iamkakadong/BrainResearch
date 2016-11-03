function [model] = corr_lr_train(X, y, param)
	cr = corr(X, y);
	[~, ord] = sort(abs(cr), 1, 'descend');
	idx = ord(1:param.DFmax);
	Xn = X(:, idx);
	Xn = [ones(size(X, 1), 1), Xn];
	model.b = sparse_lr_train(Xn, y, param);
	model.idx = idx;
end