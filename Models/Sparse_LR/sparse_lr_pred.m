function [pred] = sparse_lr_pred(X, model)
	pred = cvglmnetPredict(model, X);
	% mu = X * model;
	% pred = sigmoid(mu);
end