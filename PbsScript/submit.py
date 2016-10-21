import os
import sys

def buildfile(texts, idx, script_name):
	ntext = list()
	for line in texts:
		line = line.replace('sub_idx', str(idx))
		line = line.replace('script_name', script_name)
		ntext.append(line)
	return ntext

def submit(f, script, subjects):
	name = f.name
	tokens = name.split('.')
	prefix = tokens[0]
	suffix = tokens[1]
	texts = f.readlines()
	for i in subjects:
		tmp_texts = buildfile(texts, i, script)
		fname = prefix + str(i) + '.' + suffix
		fnew = file(fname, 'w')
		fnew.writelines(tmp_texts)
		fnew.close()
		bc = 'qsub ' + fname
		os.system(bc)
		os.remove(fname)

if __name__ == '__main__':
	args = sys.argv
	script = args[1]
	subjects = range(int(args[2]), int(args[3]) + 1)
	f = file('testjob.pbs', 'r')
	submit(f, script, subjects)
	f.close()