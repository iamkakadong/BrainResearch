function [data] = load_data(sub_idxs, trial_idxs)
	% data is a cell array of length equal to length of sub_idxs
	% each cell contains:
	% 	X: the feature matrix (n * p)
	%	y: the response vector (n * 1)
	%	c: the condition matrix (n * d)
	p_dir = '/data2/tren/NewData/';
	data = cell(length(sub_idxs), 1);
	% X = [];
	% y = [];
	% c = [];

	for idx = sub_idxs
		res = load_response(p_dir, idx);
		data{idx}.y = res.y;
		data{idx}.c = res.c;
		data{idx}.X = load_features(p_dir, idx, trial_idxs);
		% y = [y; res.y];
		% c = [c; res.c];
		% X = [X; load_features(p_dir, idx, trial_idxs)];
	end
end

function [res] = load_response(p_dir, idx)
	% res.y is n * 1
	% res.c is n * d, where d is the number of conditions
	res = struct;
	res.y = [];
	res.c = [];
	for i = 1:8
		tmp = importdata(strcat(p_dir, num2str(idx, '%04d'), '/DangerZone_run', num2str(i, '%01d'), '/', num2str(idx, '%0.4d'), '_run', num2str(i, '%01d'), '_bias.txt'));
		res.y = [res.y; tmp(:, 1)];
		res.c = [res.c; tmp(:, 2:end)];
	end
end

function [res] = load_features(p_dir, idx, trial_idxs)
	% res is a n * p matrix with invalid entries removed and features standardized
	res = [];
	for i = trial_idxs
		tmp = load_untouch_nii(strcat(p_dir, num2str(idx, '%04d'), '/single_trial_GLM/beta_', num2str(i, '%04d'), '.nii'));
		tmp = tmp.img(:);
		tmp = tmp(~isnan(tmp))';
		res = [res; tmp];
	end
	res = normalize_feature(res);
end