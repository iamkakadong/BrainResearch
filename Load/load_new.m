function [data] = load_new(sub_idxs, trial_idxs, thresh, vmask)
	% Input:
	%	thresh: cut-off z-score threshold for judging an observation as outlier
    %   vmask: a mask for valid entry indicies
	% data is a cell array of length equal to length of sub_idxs
	% each cell contains:
	% 	X: the feature matrix (n * p)
	%	y: the response vector (n * 1)
	%	c: the condition matrix (n * d)
	p_dir = '/data2/tren/NewData/';
	data = cell(length(sub_idxs), 1);

	ct = 1;
	for idx = sub_idxs
		res = load_response(p_dir, idx);
		valid_idxs = abs(res.y) <= thresh;
		valid_idxs = valid_idxs(1:length(trial_idxs));	% CAREFUL! This is only a hack used to experiment with preprocessing. Definitely REMOVE this in actual use.
		data{ct} = struct;
		data{ct}.y = normalize_feature(res.y(valid_idxs));
		data{ct}.c = res.c(valid_idxs, :);
		data{ct}.X = load_features(p_dir, idx, trial_idxs, vmask);
		data{ct}.X = data{ct}.X(valid_idxs, :);
		data{ct}.l = sum(valid_idxs);
		ct = ct + 1;
		fprintf('finished loading subject: %04d\n', idx);
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
	res.y = normalize_feature(res.y);
end

function [res, vbool] = load_features(p_dir, idx, trial_idxs, vmask)
	% res is a n * p matrix with invalid entries removed and features standardized
	res = [];
	for i = trial_idxs
		tmp = load_untouch_nii(strcat(p_dir, num2str(idx, '%04d'), '/single_trial_GLM/beta_', num2str(i, '%04d'), '.nii'));
		tmp = tmp.img(:);
		tmp = tmp(vmask ~= 0)';
		if (any(isnan(tmp(:))))
			fprintf('nan encountered in loading subject: %04d. Terminating...\n', idx);
		end
		res = [res; tmp];
	end
	res = normalize_feature(res);
end
