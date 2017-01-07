config;
thresh = 3;

data = load_new(train_subs, trial_idxs, thresh, vmask);

tmp = struct;
tmp.X = [];
tmp.y = [];
subject_range = [];

for i = 1:length(data)
	tmp2 = [data{i}.c, data{i}.X];
	tmp.X = [tmp.X; tmp2];
	tmp.y = [tmp.y; data{i}.y];
	subject_range = [subject_range, length(data{i}.y)];
end

data = tmp;
subject_range = cumsum(subject_range);
