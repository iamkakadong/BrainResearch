function [score] = my_mse(truth, prediction)
	assert(length(truth) == length(prediction), 'length of truth and prediction not equal');
	score = mean((truth - prediction) .^ 2);
end