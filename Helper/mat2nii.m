function mat2nii(mat_file, nii_template);

nii = load_untouch_nii(nii_template);

foo = load(mat_file);

field = fieldnames(foo);
eval(sprintf('mat = foo.%s;',field{1}));

nii.img = mat .* 100;

[fp, fn, fe] = fileparts(mat_file);
out_name = fullfile(fp,[fn '.nii']);

save_untouch_nii(nii, out_name);