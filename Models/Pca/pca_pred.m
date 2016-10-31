function [pred] = pca_pred(X, model)
	X = bsxfun(@minus, X, mean(X));
	Xscore = X * model.coeff;
	pred = lin_reg_pred(Xscore, model.b);
end
