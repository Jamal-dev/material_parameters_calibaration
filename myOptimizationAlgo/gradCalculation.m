function [error,grad,L2erros,L2error_combined] = gradCalculation(params,I1barList, ...
                I2barList, ...
                I3List, ...
                I4barList, ...
                I5barList, ...
                Base1List, ...
                Base2List, ...
                Base4List, ...
                Base5List,stressList_exp,batch_size)
    num_stressValues = length(I1barList);
    d_bs = batch_size/6;
    bs1 = randi([1 170],1,d_bs);
    bs2 = randi([171 255],1,d_bs);
    bs3 = randi([256 425],1,d_bs);
    bs4 = randi([426 595],1,d_bs);
    bs5 = randi([596 748],1,d_bs);
    bs6 = randi([749 918],1,d_bs);
    index_list = [bs1,bs2,bs3,bs4,bs5,bs6];
    num_params = length(params);
    grads = zeros(num_stressValues,6,num_params);
    predStressList = zeros(num_stressValues,6);

    for kp =1:num_params
        func.name1 = ['diffUdI1_params_' num2str(kp)];
        func.name2 = ['diffUdI2_params_' num2str(kp)];
        func.name3 = ['diffUdI3_params_' num2str(kp)];
        func.name4 = ['diffUdI4_params_' num2str(kp)];
        func.name5 = ['diffUdI5_params_' num2str(kp)];
        for b_idx=1:batch_size
            k = index_list(b_idx);
            I1bar = I1barList(k);
            I2bar = I2barList(k);
            I3 = I3List(k);
            I4bar = I4barList(k);
            I5bar = I5barList(k);

            base1 = arrange(Base1List(k,:,:));
            base2 = arrange(Base2List(k,:,:));
            base4 = arrange(Base4List(k,:,:));
            base5 = arrange(Base5List(k,:,:));

            
            dsigDparam_pred = dcauchyDParam(params,I1bar, ...
                                I2bar,I3, ...
                                I4bar,I5bar, ...
                                base1, ...
                                base2, ...
                                base4, ...
                                base5, ...
                                    str2func(func.name1), ...
                                    str2func(func.name2), ...
                                    str2func(func.name3), ...
                                    str2func(func.name4), ...
                                    str2func(func.name5) ...
                                    );
            dsigDparam_vec_pred= [dsigDparam_pred(1,1),dsigDparam_pred(2,2),dsigDparam_pred(3,3), ...
                      dsigDparam_pred(1,2),dsigDparam_pred(1,3),dsigDparam_pred(2,3)];
            grads(k,:,kp) = dsigDparam_vec_pred;       
        end
        
    end
    
    for b_idx=1:batch_size
        k = index_list(b_idx);
        I1bar = I1barList(k);
        I2bar = I2barList(k);
        I3 = I3List(k);
        I4bar = I4barList(k);
        I5bar = I5barList(k);

        base1 = arrange(Base1List(k,:,:));
        base2 = arrange(Base2List(k,:,:));
        base4 = arrange(Base4List(k,:,:));
        base5 = arrange(Base5List(k,:,:));

        sig_predicted = cauchyStress(params,I1bar, ...
                                I2bar,I3, ...
                                I4bar,I5bar, ...
                                base1, ...
                                base2, ...
                                base4, ...
                                base5);
                            
        sig_vec_pred= [sig_predicted(1,1),sig_predicted(2,2),sig_predicted(3,3), ...
                      sig_predicted(1,2),sig_predicted(1,3),sig_predicted(2,3)];
        predStressList(k,:) = sig_vec_pred;
        
    end
    
    xrange = find(stressList_exp(:,7)==1);
    [error1,gradSig11,l2e1] = errorComp(xrange,1, ...
                         predStressList,stressList_exp,grads);
    xrange = find(stressList_exp(:,7)==2);
    [error2,gradSig22,l2e2] = errorComp(xrange,2, ...
                         predStressList,stressList_exp,grads);
    xrange = find(stressList_exp(:,7)==3);
    [error3,gradSig33,l2e3] = errorComp(xrange,3, ...
                         predStressList,stressList_exp,grads);
    xrange = find(stressList_exp(:,7)==4);
    [error4,gradSig12,l2e4] = errorComp(xrange,4, ...
                         predStressList,stressList_exp,grads);
    xrange = find(stressList_exp(:,7)==5);
    [error5,gradSig13,l2e5] = errorComp(xrange,5, ...
                         predStressList,stressList_exp,grads);
    xrange = find(stressList_exp(:,7)==6);
    [error6,gradSig23,l2e6] = errorComp(xrange,6, ...
                         predStressList,stressList_exp,grads);
    error.sig11 = error1;
    error.sig22 = error2;
    error.sig33 = error3;
    error.sig12 = error4;
    error.sig13 = error5;
    error.sig23 = error6;
    
    %1/length(error1)*
    grad.sig11 = error.sig11'*gradSig11;
    grad.sig22 = error.sig22'*gradSig22;
    grad.sig33 = error.sig33'*gradSig33;
    grad.sig12 = error.sig12'*gradSig12;
    grad.sig13 = error.sig13'*gradSig13;
    grad.sig23 = error.sig23'*gradSig23;
    
    % l2 erros
    L2erros.sig11 = l2e1;
    L2erros.sig22 = l2e2;
    L2erros.sig33 = l2e3;
    L2erros.sig12 = l2e4;
    L2erros.sig13 = l2e5;
    L2erros.sig23 = l2e6;
    L2error_combined = l2e1 + l2e2+ l2e3+ l2e4+ l2e5+ l2e6;
    
end

function [error,gradSig,L2norm] = errorComp(xrange,comp,pred_s,exp_s,grads)
    sig_pred=pred_s(xrange,comp);
    sigExp = exp_s(xrange,comp);
    error = sig_pred - sigExp;
    gradSig = reshape(grads(xrange,comp,:),length(xrange),[]);
    L2norm = norm(error);
end

