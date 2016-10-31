function [pred] = corr_lr_pred(X, model)
	X = X(:, model.idx);
	X = [ones(size(X, 1), 1), X];
	pred = sigmoid(X * model);
end