function [pred] = cor_pred(X, model)
	Xn = X(:, model.idx);
	% pred = lin_reg_pred(Xn, model.b);
	pred = ridge_pred(Xn, model.b);
end