function [model] = pca_train(X, y, param)
	[coeff, score] = pca(X);
	coeff = coeff(:, 1:param.pc_num);
	b = lin_reg_train(score, y);
	model = struct;
	model.b = b;
	model.coeff = coeff;
end