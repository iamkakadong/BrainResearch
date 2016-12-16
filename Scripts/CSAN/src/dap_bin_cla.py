import scipy.io
import matplotlib.pyplot as plt
import numpy as np
import kernel, kmm
import sys
from sklearn import linear_model, preprocessing

def standardize(d_in, idxs):
    d = d_in
    prev_idx = 0
    for i in range(len(idxs)):
        d[prev_idx : idxs[i]+1] /= d[prev_idx : idxs[i]+1].std()
        d[prev_idx : idxs[i]+1] -= d[prev_idx : idxs[i]+1].mean()
        prev_idx = idxs[i]+1
    return d

def kmm_demo(x_so, x_ta, sigma, b):
     res = kmm.kmm(x_so, x_ta, kf=kernel.rbf, kfargs=(sigma,), B=b)
     plt.plot(res['x'])
     plt.show()
     return res

def gen_idx(sub_idx, to_exclude):
    if to_exclude == 0:
        ex_range = range(sub_idx[0])
    else:
        ex_range = range(sub_idx[to_exclude - 1], sub_idx[to_exclude])
    res = [i for i in range(sub_idx[-1]) if i not in ex_range]
    return res

if __name__ == '__main__':
    pc_num = int(sys.argv[1])
    fileout = sys.argv[2]
    pc = scipy.io.loadmat('pc_results.mat')
    tmp = scipy.io.loadmat('y.mat')
    cond = np.array(scipy.io.loadmat('condition.mat')['event_types']).astype(int)[0]
    sub_idx = tmp['subject_range'].tolist()
    sub_idx = [i for sl in sub_idx for i in sl]
    rt = np.array(tmp['y']).astype(float)[0]
    score = np.array(pc['SCORE'])
    pc_red = np.c_[rt, score[:, 1:pc_num]]
    y = cond

    scaler = preprocessing.StandardScaler()
    pc_std = scaler.fit_transform(pc_red)

    lr = linear_model.LogisticRegressionCV(fit_intercept=True, penalty='l2', cv=27, verbose=1, refit=True)

    prev_idx = 0
    train_acc = list()
    train_acc_weighted = list()
    test_acc = list()
    weights = list()
    coefs = list()

    for i in range(28):
        x_test = pc_red[prev_idx:sub_idx[i], :]
        y_test = y[prev_idx:sub_idx[i]]
        x_train = pc_red[gen_idx(sub_idx, i), :]
        y_train = y[gen_idx(sub_idx, i)]

        bin_idx = list()
        bin_idx.extend(np.where(y_train == -1)[0])
        bin_idx.extend(np.where(y_train == 1)[0])
        y_train = y_train[bin_idx]
        x_train = x_train[bin_idx, :]

        bin_idx = list()
        bin_idx.extend(np.where(y_test == -1)[0])
        bin_idx.extend(np.where(y_test == 1)[0])
        y_test = y_test[bin_idx]
        x_test = x_test[bin_idx, :]

        weight = np.array(kmm.kmm(x_train, x_test, kf=kernel.rbf, kfargs=(64, ), B=50)['x']).flatten()
        lr.fit(x_train, y_train, weight)
        train_acc.append(lr.score(x_train, y_train))
        train_acc_weighted.append(lr.score(x_train, y_train, weight))
        test_acc.append(lr.score(x_test, y_test))
        weights.append(weight)
        coefs.append(lr.coef_)
        prev_idx = sub_idx[i]
        print 'iteration %d training: %0.4f, testing: %0.4f' % (i, train_acc[-1], test_acc[-1])

    results = dict()
    results['train_acc'] = train_acc
    results['train_acc_weighted'] = train_acc_weighted
    results['test_acc'] = test_acc
    results['weights'] = weights
    results['coefs'] = coefs
    scipy.io.savemat(fileout, results)
