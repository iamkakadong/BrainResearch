function [pred] = sparse_lr_pred(X, model)
	pred = cvglmnetPredict(model, X);
end