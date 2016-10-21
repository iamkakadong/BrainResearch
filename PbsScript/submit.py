import os

def buildfile(texts, idx):
	ntext = list()
	for line in texts:
		line = line.replace('sub_idx', str(idx))
		ntext.append(line)
	return ntext

def submit(f):
	name = f.name
	tokens = name.split('.')
	prefix = tokens[0]
	suffix = tokens[1]
	texts = f.readlines()
	for i in range(1):
		tmp_texts = buildfile(texts, i+1)
		fname = prefix + str(i + 1) + '.' + suffix
		fnew = file(fname, 'w')
		fnew.writelines(tmp_texts)
		fnew.close()
		bc = 'qsub ' + fname
		os.system(bc)

if __name__ == '__main__':
	f = file('testjob.pbs', 'r')
	submit(f)
	f.close()