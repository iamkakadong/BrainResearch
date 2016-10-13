function [val] = sigmoid(v)
	val = 1 / (1 + exp(-v));
end