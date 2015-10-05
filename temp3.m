%# pair (C,gamma) with best accuracy
[~,idx] = max(cv_acc);

%# now you can train you model using best_C and best_gamma
best_C = 2^C(idx);
best_gamma = 2^gamma(idx);

SVM = svmtrain(CCL, CD3, sprintf('-c %f -g %f', 2^C(i), 2^gamma(i)));
[predicted_label, acc, dic_value] = svmpredict(CQL, QD3, SVM);

fprintf('Best C = 2^%d, Best gamma = 2^%d\n', C(idx), gamma(idx));
fprintf('svm time: %f\n', svm_time);

%[P1, LQ, t_id, rec] = calc_acc(ID, QD2, CL, QL);
[P1, LQ, t_id, rec] = calc_acc(predicted_label', QD3, CL, QL);

savRecPath = ['Results/', dataSet, '_n', num2str(n_of_extract), '_kd', num2str(params.trees), '_svm.mat'];
save(savRecPath,'rec');

savTimePath = ['Results', '/', 'svm_t'];
if ~isdir(savTimePath)
    mkdir(savTimePath);
end
save([savTimePath, '/', dataSet, '_n', num2str(n_of_extract), '.mat'], 'svm_time');
