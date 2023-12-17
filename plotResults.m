

function plotResults(params,stressList_exp,epsMatrix,ai)
    %% Predicted stress section
    sig_list_pred = zeros(length(epsMatrix),6);
    if nargin<=3
        ai = [1;0;0];
    end
    [I1barList,I2barList, ...
            I3List, ...
            I4barList,I5barList, ...
            Base1List, ...
            Base2List, ...
            Base4List, ...
            Base5List ...
            ] ...
            =get_requiredValues(epsMatrix,ai);
    for k=1:length(I1barList)
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
        sig_list_pred(k,:) = sig_vec_pred;
        
    end

    %%
    fontsize = 14;
   
    xrange = find(stressList_exp(:,7)==1);
    eps = epsMatrix(xrange,1);
    sig = sig_list_pred(xrange,1);
    sig_exp = stressList_exp(xrange,1);
    subplot(2,3,1)
    plot(eps,sig,'b-','LineWidth',2); hold on;
    plot(eps,sig_exp,'r.'); hold off;
    xlabel('$\varepsilon_{11}$','interpreter','latex','FontSize',fontsize)
    ylabel('$\sigma_{11}$','interpreter','latex','FontSize',fontsize)
    
    subplot(2,3,2)
    xrange = find(stressList_exp(:,7)==2);
    eps = epsMatrix(xrange,2);
    sig = sig_list_pred(xrange,2);
    sig_exp = stressList_exp(xrange,2);
    plot(eps,sig,'b-','LineWidth',2); hold on;
    plot(eps,sig_exp,'r.'); hold off;
    xlabel('$\varepsilon_{22}$','interpreter','latex','FontSize',fontsize)
    ylabel('$\sigma_{22}$','interpreter','latex','FontSize',fontsize)
    
    subplot(2,3,3)
    xrange = find(stressList_exp(:,7)==3);
    eps = epsMatrix(xrange,3);
    sig = sig_list_pred(xrange,3);
    sig_exp = stressList_exp(xrange,3);
    plot(eps,sig,'b-','LineWidth',2); hold on;
    plot(eps,sig_exp,'r.'); hold off;
    xlabel('$\varepsilon_{33}$','interpreter','latex','FontSize',fontsize)
    ylabel('$\sigma_{33}$','interpreter','latex','FontSize',fontsize)
    
    subplot(2,3,4)
    xrange = find(stressList_exp(:,7)==4);
    eps = epsMatrix(xrange,4);
    sig = sig_list_pred(xrange,4);
    sig_exp = stressList_exp(xrange,4);
    plot(eps,sig,'b-','LineWidth',2); hold on;
    plot(eps,sig_exp,'r.'); hold off;
    xlabel('$\varepsilon_{12}$','interpreter','latex','FontSize',fontsize)
    ylabel('$\sigma_{12}$','interpreter','latex','FontSize',fontsize)
    
    subplot(2,3,5)
    xrange = find(stressList_exp(:,7)==5);
    eps = epsMatrix(xrange,5);
    sig = sig_list_pred(xrange,5);
    sig_exp = stressList_exp(xrange,5);
    plot(eps,sig,'b-','LineWidth',2); hold on;
    plot(eps,sig_exp,'r.'); hold off;
    xlabel('$\varepsilon_{13}$','interpreter','latex','FontSize',fontsize)
    ylabel('$\sigma_{13}$','interpreter','latex','FontSize',fontsize)
    
    subplot(2,3,6)
    xrange = find(stressList_exp(:,7)==6);
    eps = epsMatrix(xrange,6);
    sig = sig_list_pred(xrange,6);
    sig_exp = stressList_exp(xrange,6);
    plot(eps,sig,'b-','LineWidth',2); hold on;
    plot(eps,sig_exp,'r.'); hold off;
    
    xlabel('$\varepsilon_{23}$','interpreter','latex','FontSize',fontsize)
    ylabel('$\sigma_{23}$','interpreter','latex','FontSize',fontsize)
end





