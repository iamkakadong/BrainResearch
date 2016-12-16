import scipy.io
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
    cond = np.array(scipy.io.loadmat('condition.mat')['event_types']).astype(float)[0]
    sub_idx = tmp['subject_range'].tolist()
    sub_idx = [i for sl in sub_idx for i in sl]
    y = np.array(tmp['y']).astype(float)[0]
    y_std = standardize(y, sub_idx)
    score = np.array(pc['SCORE'])
    pc_red = np.c_[cond.T, score[:, 1:pc_num]]

    scaler = preprocessing.StandardScaler()
    pc_std = scaler.fit_transform(pc_red)

    #elas_net = linear_model.ElasticNetCV(l1_ratio=0.01, cv=26, verbose=1, n_jobs=2, fit_intercept=True, normalize=True, copy_X=True)
    ridge = linear_model.RidgeCV(cv=27, fit_intercept=True, normalize=True)
    #gbr = ensemble.GradientBoostingRegressor

    prev_idx = 0
    train_r2 = list()
    train_r2_weighted = list()
    test_r2 = list()
    weights = list()
    coefs = list()
    for i in range(28):
        x_test = pc_red[prev_idx:sub_idx[i], :]
        y_test = y_std[prev_idx:sub_idx[i]]
        x_train = pc_red[gen_idx(sub_idx, i), :]
        y_train = y_std[gen_idx(sub_idx, i)]
        weight = np.array(kmm.kmm(x_train, x_test, kf=kernel.rbf, kfargs=(64, ), B=50)['x']).flatten()
        ridge.fit(x_train, y_train, weight)
        train_r2.append(ridge.score(x_train, y_train))
        train_r2_weighted.append(ridge.score(x_train, y_train, weight))
        test_r2.append(ridge.score(x_test, y_test))
        weights.append(weight)
        coefs.append(ridge.coef_)
        print 'iteration training: %0.4f, testing: %0.4f' % (train_r2[-1], test_r2[-1])

    results = dict()
    results['train_r2'] = train_r2
    results['train_r2_weighted'] = train_r2_weighted
    results['test_r2'] = test_r2
    results['weights'] = weights
    results['coefs'] = coefs
    scipy.io.savemat(fileout, results)
