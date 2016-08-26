function [pred] = lin_reg_pred(X, b)
	% X is n * p
	% b is p * 1
	[rx, cx] = size(X);
	[rb, cb] = size(b);
	assert(cx == rb, 'invalid input: number of features does not match.');
	pred = X * b;
end