function mat2nii(mat_file, nii_template);

nii = load_nii(nii_template);

foo = load(mat_file);

field = fieldnames(foo);
eval(sprintf('mat = foo.%s;',field{1}));

nii.img = mat;
nii.img = double(nii.img);
[fp, fn, fe] = fileparts(mat_file);
out_name = fullfile(fp,[fn '.nii']);

save_nii(nii, out_name);