function [res] = standardize(X)
	% normalize a n * p matrix so that each observation of a feature is transformed into the respective z-score
	s = std(X);
	res = bsxfun(@rdivide, X, s);
	m = mean(res);
	res = bsxfun(@minus, res, m);
end