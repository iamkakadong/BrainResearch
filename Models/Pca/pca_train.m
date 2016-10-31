function [model] = pca_train(X, y, param)
	npc = param.npc;
	cv_num = param.cv_num;
	[n, p] = size(X);

	last_idx = 1;
	rest = n;
	cvs = zeros(cv_num, length(npc));

	for i = 1:cv_num
		cvidx = [last_idx: min(n, last_idx + ceil(rest / (cv_num - i + 1)))];
		last_idx = last_idx + ceil(rest / (cv_num - i + 1));
		rest = rest - length(cvidx);
		idx = zeros(n, 1);
		idx(cvidx) = 1;

		for j = 1 : length(npc)
			X_train = X(idx == 0, 1:npc(j));
			y_train = y(idx == 0);
			X_cv = X(idx == 1, 1:npc(j));
			y_cv = y(idx == 1);

			[b, fitinfo] = lasso(X_train, y_train, 'Alpha', param.alpha, 'Standardize', true, ...
				'CV', cv_num - 1, 'Options', param.opts);
			model = b(:, fitinfo.IndexMinMSE);
			y_pred = X_cv * model;	% n * length(k)

			cvs(i, j) = my_r2(y_cv, y_pred);
		end
	end

	res = mean(cvs);
	[~, idx] = min(res);
	X = X(:, 1:npc(idx));
	[b, fitinfo] = lasso(X, y, 'Alpha', param.alpha, 'Standardize', true, ...
				'CV', cv_num, 'Options', param.opts);
	model = struct;
	model.b = b(:, fitinfo.IndexMinMSE);
	model.npc = npc(idx);
	model.fitinfo = fitinfo;
	model.cvs = cvs;
end
