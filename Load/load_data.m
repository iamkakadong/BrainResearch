function [X, y, event_types, subject_range, final_mask] = load_data(subject_idx, mask_type)
%{
  load data from files. 
Inputs:
	subject_idx: indicates the subjects that are going to be loaded
	mask_type: which type of mask to be used (default to gray & white matter mask)
		if mask_type == 0: gray & white matter mask
		if mask_type == 1: only white matter mask
		if mask_type == 2: mask after almost_ridge variable selection
Returns:
  X: the design matrix (p * n)
  y: the response variable, i.e. Reaction Time (1 * n)
  event_types: the event type corresponding to each trial
  subject_range: an array with the index of last entry for a subject in data matricies
  mymask: the final 3D mask that filters out any unobserved/nan entries in the design matrix
%}

	% parse input
	p = inputParser;
	defaultMaskFlag = 0;
	addRequired(p, 'subject_idx');
	addOptional(p, 'mask_type', defaultMaskFlag, @(x) x == 0 || x == 1 || x == 2);
	
	parse(p, subject_idx, mask_type);
	% p.Results.mask_type
	
	% load summary file
	rt = load('/data/ARL/StroopST_analysis/sortedRTs_all_subjects.mat');

	% transform inputs
	subs_idx = rt.subs;
	subs_rt = rt.RT_vec_list;

	% initialization
	X = [];
	y = [];
	idx = [];
	subject_range = zeros(length(subject_idx) + 1, 1);
	subject_range(1) = 0;
	event_types = [];
	cur_path = pwd;

	% load data for subjects in subject_idx
	for j = 1 : length(subject_idx)
		tmp_path = strcat('/data/ARL/', num2str(subject_idx(j), '%04d'), '/snStroop_singletrial_GLM');
		% cd(tmp_path);
		% load reaction time for this subject
		this_rt = subs_rt(find(subs_idx == subject_idx(j)));
		this_rt = this_rt{1,1};
		subject_range(j + 1) = subject_range(j) + length(this_rt);
		% load SPM to record experiment type
		event_types = [event_types, load_event(strcat(tmp_path, '/SPM.mat'))];
		% load brain image and response time
		[X, y] = load_xy(X, y, this_rt);
		% index matrix for masking non-zero entries
		idx = [idx, X(:, subject_range(j + 1))];
	end
	subject_range = subject_range(2:end);

	% load mask to select voxels
	idx(isnan(idx)) = 0;
	tmp = all(idx~=0, 2);
	if (mask_type == 0)	% basic configuration. gray and white matter
		mask = load_untouch_nii(strcat(tmp_path, '/mask.img');
	elseif (mask_type == 1)	% only white matter
		mask = load_untouch_nii('/data/ARL/ROIs/resliced_MNI-maxprob-thr25-2mm_binary.nii');
	elseif (mask_type == 2)	% almost_ridge mask
		mask = load('/home/tren/masks/almost_ridge.mat');
	end
	mask1d = double(mask.img(:));
	tmp = and(tmp, (mask1d ~= 0));
	X = X(tmp, :);
	final_mask = reshape(tmp, size(mask.img));

	% cd(cur_path);
end

function [event] = load_event(filename)
% load event types for all trials in 'filename'
% congruent = 1;
% neutral = 0;
% incongruent = -1;
	SPM = load(filename);
	SPM = SPM.SPM;
	n = length(SPM.Sess.U);
	event = zeros(1, n);
	for i = 1 : n
		if strcmp(SPM.Sess.U(i).name{1},'Congruent')
			event(i) = 1;
		elseif strcmp(SPM.Sess.U(i).name{1},'Neutral')
			event(i) = 0;
		else
			event(i) = -1;
		end
	end
end

function [X, y] = load_xy(X, y, thisRT)
	subject_data = [];
	y = [y, thisRT];
	for i = 1:length(thisRT)
		imgpath = ['beta_', num2str(i, '%04d'), '.img'];
		% load brain image
		img = load_untouch_nii(imgpath);
		img1d = img.img(:);
		subject_data = [subject_data, img1d];
	end
	X = [X, normalize_feature(subject_data')'];
end

