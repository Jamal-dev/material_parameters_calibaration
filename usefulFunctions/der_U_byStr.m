
function der_U_byStr(num_params,psiString)
    syms I_1 I_2 I_4alpha I_5alpha theta phi lambda_1 lambda_2 lambda_3
    syms J D
    assume(I_1,'real'); assume(I_2,'real'); assume(I_4alpha,'real');
    assume(I_5alpha,'real');
    assume(J,'real');
    assume(D,'real');
     assume(theta,'real'); assume(phi,'real'); assume(lambda_1,'real');
     assume(lambda_2,'real');
      assume(lambda_3,'real');
    
    
    
    syms params [1 num_params]
    [derv_U_I1,derv_U_I4] =psi(I_1,I_2,I_4alpha,I_5alpha,J,params,psiString);
    
end
function [derv_U_I1,derv_U_I4] =psi(I1,I2,I4,I5,J,params,psiString)
    
    U=eval(psiString);
   
    % Ealpha = params(4)*(I1-3) + (1-3*params(4))*(I4-1);
    % U = params(1) * (I1-3) + ...
    %     params(2)/params(3) * ...
    %     (exp(params(3)*Ealpha^2)-1);

    
    derv_U_I1 = diff(U,I1);
    derv_U_I2 = diff(U,I2);
    derv_U_I3 = diff(U,J);
    derv_U_I4 = diff(U,I4);
    derv_U_I5 = diff(U,I5);
    
    %first empty the folder
    delete(fullfile('usefulFunctions','dervsWithParams','*'));
    
    derivative_name = 'diffUdI1';
    for k=1:length(params)
        file_path = fullfile('usefulFunctions','dervsWithParams',[derivative_name '_params_' num2str(k)]);
        matlabFunction(diff(derv_U_I1,params(k)), ...
                            "File",file_path, ...
                            "Vars",{params, I1,I2,J, I4,I5});
    end
    derivative_name = 'diffUdI2';
    for k=1:length(params)
        file_path = fullfile('usefulFunctions','dervsWithParams',[derivative_name '_params_' num2str(k)]);
        matlabFunction(diff(derv_U_I2,params(k)), ...
                            "File",file_path, ...
                            "Vars",{params, I1,I2,J, I4,I5});
    end
    
    derivative_name = 'diffUdI3';
    for k=1:length(params)
        file_path = fullfile('usefulFunctions','dervsWithParams',[derivative_name '_params_' num2str(k)]);
        matlabFunction(diff(derv_U_I3,params(k)), ...
                            "File",file_path, ...
                            "Vars",{params, I1,I2,J, I4,I5});
    end
    derivative_name = 'diffUdI4';
    for k=1:length(params)
        file_path = fullfile('usefulFunctions','dervsWithParams',[derivative_name '_params_' num2str(k)]);
        matlabFunction(diff(derv_U_I4,params(k)), ...
                            "File",file_path, ...
                            "Vars",{params, I1,I2,J, I4,I5});
    end
    derivative_name = 'diffUdI5';
    for k=1:length(params)
        file_path = fullfile('usefulFunctions','dervsWithParams',[derivative_name '_params_' num2str(k)]);
        matlabFunction(diff(derv_U_I5,params(k)), ...
                            "File",file_path, ...
                            "Vars",{params, I1,I2,J, I4,I5});
    end
    

    %% double Derivatives
    derv_U_dI3_dI3 = diff(derv_U_I3,J);
    matlabFunction(derv_U_dI3_dI3,"File",fullfile('usefulFunctions',"diffUdI3dI3"),"Vars",{params, I1,I2,J, I4,I5});
    derv_U_dI1_dI1 = diff(derv_U_I1,I1);
    matlabFunction(derv_U_dI1_dI1,"File",fullfile('usefulFunctions',"diffUdI1dI1"),"Vars",{params, I1,I2,J, I4,I5});

    derv_U_dI1_dI2 = diff(derv_U_I1,I2);
    matlabFunction(derv_U_dI1_dI2,"File",fullfile('usefulFunctions',"diffUdI1dI2"),"Vars",{params, I1,I2,J, I4,I5});

    derv_U_dI2_dI2 = diff(derv_U_I2,I2);
    matlabFunction(derv_U_dI2_dI2,"File",fullfile('usefulFunctions',"diffUdI2dI2"),"Vars",{params, I1,I2,J, I4,I5});

    derv_U_dI1_dI4 = diff(derv_U_I1,I4);
    matlabFunction(derv_U_dI1_dI4,"File",fullfile('usefulFunctions',"diffUdI1dI4"),"Vars",{params, I1,I2,J, I4,I5});

    derv_U_dI2_dI4 = diff(derv_U_I2,I4);
    matlabFunction(derv_U_dI2_dI4,"File",fullfile('usefulFunctions',"diffUdI2dI4"),"Vars",{params, I1,I2,J, I4,I5});

    derv_U_dI4_dI4 = diff(derv_U_I4,I4);
    matlabFunction(derv_U_dI4_dI4,"File",fullfile('usefulFunctions',"diffUdI4dI4"),"Vars",{params, I1,I2,J, I4,I5});

    derv_U_dI1_dI5 = diff(derv_U_I1,I5);
    matlabFunction(derv_U_dI1_dI5,"File",fullfile('usefulFunctions',"diffUdI1dI5"),"Vars",{params, I1,I2,J, I4,I5});
    
    derv_U_dI2_dI5 = diff(derv_U_I2,I5);
    matlabFunction(derv_U_dI2_dI5,"File",fullfile('usefulFunctions',"diffUdI2dI5"),"Vars",{params, I1,I2,J, I4,I5});

    derv_U_dI5_dI5 = diff(derv_U_I5,I5);
    matlabFunction(derv_U_dI5_dI5,"File",fullfile('usefulFunctions',"diffUdI5dI5"),"Vars",{params, I1,I2,J, I4,I5});

    derv_U_dI4_dI5 = diff(derv_U_I4,I5);
    matlabFunction(derv_U_dI4_dI5,"File",fullfile('usefulFunctions',"diffUdI4dI5"),"Vars",{params, I1,I2,J, I4,I5});

    %% function files
    matlabFunction(derv_U_I1,"File",fullfile('usefulFunctions',"diffUdI1"),"Vars",{params, I1,I2,J, I4,I5});
    matlabFunction(derv_U_I2,"File",fullfile('usefulFunctions',"diffUdI2"),"Vars",{params, I1,I2,J, I4,I5});
    matlabFunction(derv_U_I3,"File",fullfile('usefulFunctions',"diffUdI3"),"Vars",{params, I1,I2,J, I4,I5});
    matlabFunction(derv_U_I4,"File",fullfile('usefulFunctions',"diffUdI4"),"Vars",{params, I1,I2,J, I4,I5});
    matlabFunction(derv_U_I5,"File",fullfile('usefulFunctions',"diffUdI5"),"Vars",{params, I1,I2,J, I4,I5});

    %% for second derivatives
    
end



