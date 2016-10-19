function [score] = my_acc(truth, prediction)
	% [~, prediction] = max(prediction, [], 2);
	prediction = prediction > 0.5;
	score = sum(truth == prediction) / numel(truth);
end