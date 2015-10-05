[predicted_label, acc, dic_value] = predict(CQL, QD3, lin);

[P1, LQ, t_id, rec] = calc_acc(predicted_label', QD3, CL, QL);

savRecPath = ['Results/', dataSet, '_n', num2str(n_of_extract), '_kd', num2str(params.trees), '_lin.mat'];
save(savRecPath,'rec');

savTimePath = ['Results', '/', 'lin_t'];
if ~isdir(savTimePath)
    mkdir(savTimePath);
end
save([savTimePath, '/', dataSet, '_n', num2str(n_of_extract), '.mat'], 'lin_time');
