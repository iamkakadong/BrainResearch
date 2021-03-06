import scipy.io
import h5py
import matplotlib.pyplot as plt
import numpy as np
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

    # score = np.array(h5py.File('pc_score.mat')['score']).astype(float).transpose()
    score = np.array(scipy.io.loadmat('ae_score.mat')['score']).astype(float)
    y_std = np.array(scipy.io.loadmat('y.mat')['ty']).astype(float).flatten()
    sub_idx = scipy.io.loadmat('subject_range.mat')['subject_range'].tolist()
    sub_idx = [i for sl in sub_idx for i in sl]
    cond = np.array(scipy.io.loadmat('conditions.mat')['tc']).astype(float)

    pc_red = np.c_[cond, score[:, 1:pc_num]]

    # debatable whether pc score should be standardized again. Also maybe should not penalize task conditions
    scaler = preprocessing.StandardScaler()
    pc_std = scaler.fit_transform(pc_red)

    model = linear_model.ElasticNetCV(l1_ratio=l1_ratio, cv=10, verbose=1, n_jobs=2, fit_intercept=True, normalize=True, copy_X=True)

    prev_idx = 0
    train_r2 = list()
    train_r2_weighted = list()
    test_r2 = list()
    pred = list()
    truth = list()
    weights = list()
    coefs = list()
    for i in range(15):
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
        pred.append(model.predict(x_test))
        truth.append(y_test)
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
    results['pred'] = pred
    results['truth'] = truth
    scipy.io.savemat(fileout, results)
