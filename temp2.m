CD4 = sparse(CD3);
QD4 = sparse(QD3);
tic
lin = train(CCL, CD4, sprintf('-c %f', C));
[predicted_label, acc, dic_value] = predict(CQL, QD4, lin);
lin_time = toc;

fprintf('Best C = %f\n', C);
fprintf('LIBLINEAR time: %f\n', lin_time);

%[P1, LQ, t_id, rec] = calc_acc(ID, QD2, CL, QL);
[P1, LQ, t_id, rec] = calc_acc(predicted_label', QD3, CL, QL);

savRecPath = ['Results/', dataSet, '_n', num2str(n_of_extract), '_kd', num2str(params.trees), '_lin.mat'];
save(savRecPath,'rec');

savTimePath = ['Results', '/', 'lin_t'];
if ~isdir(savTimePath)
    mkdir(savTimePath);
end
save([savTimePath, '/', dataSet, '_n', num2str(n_of_extract), '.mat'], 'lin_time');
