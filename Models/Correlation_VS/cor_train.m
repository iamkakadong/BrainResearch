function [model] = cor_train(X, y, params)
	cr = corr(X, y);
	[~, ord] = sort(abs(cr), 1, 'descend');
	idx = ord(1:params.DFmax);
	Xn = X(:, idx);
	model = struct;
	model.b = lin_reg_train(Xn, y, {});
	%[model.b, model.fitinfo] = elas_net_train(Xn, y, params);
	model.idx = idx;
end
