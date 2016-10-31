function [pred] = pca_pred(X, model)
	assert (model.npc = length(model.b), 'model dimension mismatch');
	X = X(:, 1 : model.npc);
	pred = lin_reg_pred(X, model.b);
end
