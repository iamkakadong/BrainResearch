addpath(genpath('~/BrainResearch/'));
load('vmask.mat');
load('ol_range.mat');

sub_idxs = [0464  0551  0553  0560  0581  0595  0549  0555  0556  0567  0568  0590  0606  0552  0554  0566  0585  0591  0596  0609];

train_subs = sub_idxs(1 : 10);
test_subs = sub_idxs(13 : 16);

trial_idxs = [];
for i = 1:8
	tmp = (56 + 6) * (i - 1) + 1;
	trial_idxs = [trial_idxs, tmp : tmp + 55];
end
