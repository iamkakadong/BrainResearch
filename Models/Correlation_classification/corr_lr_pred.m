function [pred] = corr_lr_pred(X, model)
	X = X(:, model.idx);
	pred = sigmoid(X * model);
end