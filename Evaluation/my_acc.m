function [score] = my_acc(truth, prediction)
	score = sum(truth == prediction) / numel(truth);
end