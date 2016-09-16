function [res] = normalize_feature(X)
	% normalize a n * p matrix so that each observation of a feature is transformed into the respective z-score
	m = mean(X);
	res = bsxfun(@minus, X, m);
	s = std(res);
	res = bsxfun(@rdivide, res, s);
end