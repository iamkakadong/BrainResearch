function [model] = ridge_train(X, y, params)
	[n, p] = size(X);
	k = params.k;
	cv_num = params.cv_num;
	last_idx = 1;
	rest = n;
	cvs = zeros(cv_num, length(k));

	for i = 1:cv_num
		cvidx = [last_idx: min(n, last_idx + ceil(rest / (cv_num - i + 1)))];
		last_idx = last_idx + ceil(rest / (cv_num - i + 1));
		rest = rest - length(cvidx);
		idx = zeros(n, 1);
		idx(cvidx) = 1;
		
		X_train = X(idx == 0, :);
		y_train = y(idx == 0);
		X_cv = X(idx == 1, :);
		y_cv = y(idx == 1);

		model = ridge(y_train, X_train, k);
		y_pred = X_cv * model;	% n * length(k)

		for j = 1:size(y_pred, 2)
			cvs(i, j) = my_r2(y_cv, y_pred(:, j));
		end
	end

	models = ridge(y, X, k);
	m = mean(cvs, 1);
	[~, etr] = max(m);
	model = models(:, etr);

end