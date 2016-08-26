function [res] = normalize(X)
	% normalize a n * p matrix so that each observation of a feature is transformed into the respective z-score
	m = mean(X);
	s = std(X);
	res = bsxfun(@minus, X, m);
	res = bsxfun(@rdivide, res, s);
end