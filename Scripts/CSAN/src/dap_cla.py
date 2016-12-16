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

    #elas_net = linear_model.ElasticNetCV(l1_ratio=0.01, cv=26, verbose=1, n_jobs=2, fit_intercept=True, normalize=True, copy_X=True)
    #ridge = linear_model.RidgeCV(cv=27, fit_intercept=True, normalize=True)
    lr_ovr = linear_model.LogisticRegressionCV(fit_intercept=True, penalty='l2', cv=27, n_jobs=2, verbose=1, refit=True, multi_class='ovr')
    lr_multi = linear_model.LogisticRegressionCV(fit_intercept=True, penalty='l2', cv=27, n_jobs=2, verbose=1, refit=True, multi_class='multinomial')
    #gbr = ensemble.GradientBoostingRegressor

    prev_idx = 0
    mult_train_acc = list()
    mult_train_acc_weighted = list()
    mult_test_acc = list()
    mult_weights = list()
    mult_coefs = list()

    ovr_train_acc = list()
    ovr_train_acc_weighted = list()
    ovr_test_acc = list()
    ovr_weights = list()
    ovr_coefs = list()
    for i in range(28):
        x_test = pc_red[prev_idx:sub_idx[i], :]
        y_test = y_std[prev_idx:sub_idx[i]]
        x_train = pc_red[gen_idx(sub_idx, i), :]
        y_train = y_std[gen_idx(sub_idx, i)]
        weight = np.array(kmm.kmm(x_train, x_test, kf=kernel.rbf, kfargs=(64, ), B=50)['x']).flatten()
        lr_ovr.fit(x_train, y_train, weight)
        lr_multi.fit(x_train, y_train, weight)
        mult_train_acc.append(lr_multi.score(x_train, y_train))
        mult_train_acc_weighted.append(lr_multi.score(x_train, y_train, weight))
        mult_test_acc.append(lr_multi.score(x_test, y_test))
        mult_weights.append(weight)
        mult_coefs.append(lr_multi.coef_)
        ovr_train_acc.append(lr_ovr.score(x_train, y_train))
        ovr_train_acc_weighted.append(lr_ovr.score(x_train, y_train, weight))
        ovr_test_acc.append(lr_ovr.score(x_test, y_test))
        ovr_weights.append(weight)
        ovr_coefs.append(lr_ovr.coef_)
        print 'iteration %d training: %0.4f, testing: %0.4f' % (i, mult_train_acc[-1], mult_test_acc[-1])
        print 'iteration %d training: %0.4f, testing: %0.4f' % (i, ovr_train_acc[-1], ovr_test_acc[-1])

    results = dict()
    results['mult_train_acc'] = mult_train_acc
    results['mult_train_acc_weighted'] = mult_train_acc_weighted
    results['mult_test_acc'] = mult_test_acc
    results['mult_weights'] = mult_weights
    results['mult_coefs'] = mult_coefs

    results['ovr_train_acc'] = ovr_train_acc
    results['ovr_train_acc_weighted'] = ovr_train_acc_weighted
    results['ovr_test_acc'] = ovr_test_acc
    results['ovr_weights'] = ovr_weights
    results['ovr_coefs'] = ovr_coefs
    scipy.io.savemat(fileout, results)
