function [model] = pca_train(X, y, param)
	[coeff, score, ~, ~, explained] = pca(X);
	tmp = 0;
	pc_num = 0;
	for i = 1 : length(explained)
		tmp = tmp + explained(i) / 100;
		pc_num = pc_num + 1;
		if (tmp > param.pc_explained)
			break
		end
	end
	coeff = coeff(:, 1:pc_num);
    score = score(:, 1:pc_num);
	b = lin_reg_train(score, y);
	model = struct;
	model.b = b;
	model.coeff = coeff;
end
