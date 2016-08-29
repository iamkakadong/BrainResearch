function score = my_r2(truth, prediction)
	ss_tot = norm(truth - mean(truth)) ^ 2;
	ss_res = (prediction - truth)' * (prediction - truth);
	score = 1 - ss_res / ss_tot;
end