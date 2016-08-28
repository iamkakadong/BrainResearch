function [b] = lin_reg_train(X, y, ~)
	% X should be n * p
	% y should be n * 1
	[nx, px] = size(X);
	[ny, py] = size(y);
	assert(nx == ny, 'invalid input: number of observations does not match.');
	b = X \ y;
end