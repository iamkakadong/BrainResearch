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
    # kernel_smooth = float(sys.argv[2])
    # b = float(sys.argv[3])
    l1_ratio = float(sys.argv[2])
    fileout = sys.argv[3]
    pc = scipy.io.loadmat('pc_results_nooutlier.mat')
    tmp = scipy.io.loadmat('y_nooutlier.mat')
    cond = np.array(scipy.io.loadmat('condition_nooutlier.mat')['event_types']).astype(float)[0]
    sub_idx = tmp['subject_range'].tolist()
    sub_idx = [i for sl in sub_idx for i in sl]
    y = np.array(tmp['y']).astype(float)[0]
    y_std = standardize(y, sub_idx)
    score = np.array(pc['SCORE'])
    pc_red = np.c_[cond.T, score[:, 1:pc_num]]

    scaler = preprocessing.StandardScaler()
    pc_std = scaler.fit_transform(pc_red)

    model = linear_model.ElasticNetCV(l1_ratio=l1_ratio, cv=27, verbose=1, n_jobs=2, fit_intercept=True, normalize=True, copy_X=True)
    #model = linear_model.RidgeCV(cv=27, fit_intercept=True, normalize=True)
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
        assert (len(y_test) == sub_idx[i] - prev_idx)
        assert (len(y_train) == len(gen_idx(sub_idx, i)))
        #x_test = x_test[np.abs(y_test) <= 4, :]
        #y_test = y_test[np.abs(y_test) <= 4]
        #x_train = x_train[np.abs(y_train) <= 4, :]
        #y_train = y_train[np.abs(y_train) <= 4]
        #assert (len(y_test) == sub_idx[i] - prev_idx)
        #assert (len(y_train) == len(gen_idx(sub_idx, i)))
        #weight = np.array(kmm.kmm(x_train, x_test, kf=kernel.rbf, kfargs=(kernel_smooth, ), B=b)['x']).flatten()
        #weight = np.array(kmm.kmm(x_train, pc_red, kf=kernel.rbf, kfargs=(kernel_smooth, ), B=b)['x']).flatten()
        #print 'max weight %0.5f' % (max(weight))
        #print 'min weight %0.5f' % (min(weight))
        #print 'mean weight %0.5f' % (weight.mean())
        #print 'median weight %0.5f' % (np.median(weight))
        #print 'std weight %0.4f' % (np.std(weight))
        #model.fit(x_train, y_train, weight)
        model.fit(x_train, y_train)
        train_r2.append(model.score(x_train, y_train))
        #train_r2_weighted.append(model.score(x_train, y_train, weight))
        test_r2.append(model.score(x_test, y_test))
        #weights.append(weight)
        coefs.append(model.coef_)
        prev_idx = sub_idx[i]
        print 'iteration %d training: %0.4f, testing: %0.4f' % (i, train_r2[-1], test_r2[-1])

    results = dict()
    results['train_r2'] = train_r2
    results['train_r2_weighted'] = train_r2_weighted
    results['test_r2'] = test_r2
    results['weights'] = weights
    results['coefs'] = coefs
    scipy.io.savemat(fileout, results)
