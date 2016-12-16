function [pred] = cor_pred(X, model)
	Xn = X(:, model.idx);
	Xn = [ones(size(Xn, 1), 1), Xn];
	intc = model.fitinfo.Intercept(model.fitinfo.IndexMinMSE);
	pred = lin_reg_pred(Xn, model.b) + intc;
end
