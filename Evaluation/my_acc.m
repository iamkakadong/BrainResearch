function [score] = my_acc(truth, prediction)
	[~, prediction] = max(prediction, [], 2);
	score = sum(truth == prediction) / numel(truth);
end