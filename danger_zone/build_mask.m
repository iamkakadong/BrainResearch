
config;

p_dir = '/data2/tren/NewData/';
vmask = ones(79 * 95 * 78, 1);
for i = sub_idxs
	fprintf('\tbuilding mask with subject %d...\n', i);
	for j = trial_idxs
		tmp = load_untouch_nii(strcat(p_dir, num2str(i, '%04d'), '/single_trial_GLM/beta_', num2str(j, '%04d'), '.nii'));
		tmp = tmp.img(:);
		vmask = vmask & isnan(tmp);
	end
end

save('mask.mat', 'vmask');