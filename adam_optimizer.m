function [theta, J_history,theta_best] = adam_optimizer(theta,obj, learning_rate, num_iterations, ...
                                                         print_every,model_data, ...
                                                         epsMatrix,sigMatrix, ...
                                                         ai,parameter_file_name)
%     m = length(y); % Number of training examples
    if nargin<5
        print_every = 50;
        ai = [1;0;0];
        parameter_file_name='theta.mat';
    end
    J_history = zeros(num_iterations, 1); % Array to store the cost function values over iterations
    f = figure('Name','plotResults');
    beta1 = 0.9; % Exponential decay rate for the first moment estimate
    beta2 = 0.999; % Exponential decay rate for the second moment estimate
    epsilon = 1e-8; % Small constant to prevent division by zero

    m_t = zeros(size(theta)); % Initialize first moment vector
    v_t = zeros(size(theta)); % Initialize second moment vector
    t = 0; % Initialize time step
    min_error = 10e22;
    theta_best = zeros(size(theta));
    tol=1e-5;
    stop_delay = 10;
    stop_delay_iter = 1;
    weights = [1,1,1,1,1,1];
    for i = 1:num_iterations
        t = t + 1;
        weights = rand(1,6);
        [error_struct,grad_struct,L2erros,L2error_combined]=obj(theta);
        error1 = error_struct.sig11;
        grad1 = grad_struct.sig11;
        error2 = error_struct.sig22;
        grad2 = grad_struct.sig22;
        error3 = error_struct.sig33;
        grad3 = grad_struct.sig33;
        error4 = error_struct.sig12;
        grad4 = grad_struct.sig12;
        error5 = error_struct.sig13;
        grad5 = grad_struct.sig13;
        error6 = error_struct.sig23;
        grad6 = grad_struct.sig23;
        
        grad = [weights(1)*grad1; ...
                weights(2)*grad2;...
                weights(3)*grad3; ...
                weights(4)*grad4; ...
                weights(5)*grad5; ...
                weights(6)*grad6];
        grad = mean(grad,1);
        
        
        
        m_t = beta1 * m_t + (1 - beta1) * grad; % Update first moment estimate
        v_t = beta2 * v_t + (1 - beta2) * (grad.^2); % Update second moment estimate

        m_t_hat = m_t / (1 - beta1^t); % Bias-corrected first moment estimate
        v_t_hat = v_t / (1 - beta2^t); % Bias-corrected second moment estimate
        prev_theta = theta;

        theta = theta - (learning_rate ./ (sqrt(v_t_hat) + epsilon)) .* m_t_hat; % Update parameters

        % Calculate the cost function and store it in the history
        J_history(i) =  L2error_combined;
        if abs(theta-prev_theta)<=tol 
            stop_delay_iter = stop_delay_iter +1;
            if stop_delay_iter<stop_delay
                disp(['theta is not changing since last ' num2str(stop_delay) ' iterations']);
                break;
            end
        else
            stop_delay_iter = 1;
            
        end
        if L2error_combined<min_error
            theta_best = theta;
        end
        if ~ rem(i,print_every)
            fprintf('Errors in sig11=%1.2e,sig22=%1.2e,sig33=%1.2e,sig12=%1.2e,sig13=%1.2e,sig23=%1.2e\n', ...
                L2erros.sig11,L2erros.sig22,L2erros.sig33,L2erros.sig12,L2erros.sig13, ...
                L2erros.sig23);
            fprintf('iteration=%i, Model error=%1.2e\n',i,L2error_combined)
        end
        if ~ rem(i,20*print_every)
            
            plotResults(theta,sigMatrix,epsMatrix,ai)
            sgtitle(model_data.title,'FontSize',16,'interpreter','latex')
            file_path = fullfile('figures',model_data.folder_name ,['model_' num2str(i) '.fig']);
            savefig(f,file_path)
        end
        if ~ rem(i,2*print_every)
            file_path = fullfile('figures',model_data.folder_name ,parameter_file_name);
            save(file_path,"theta")
        end
    end
end
