function derv_U_I4 = diffUdI4(in1,I_1,I_2,J,I_4alpha,I_5alpha)
%diffUdI4
%    derv_U_I4 = diffUdI4(IN1,I_1,I_2,J,I_4alpha,I_5alpha)

%    This function was generated by the Symbolic Math Toolbox version 9.3.
%    17-Dec-2023 22:29:26

params3 = in1(:,3);
params4 = in1(:,4);
derv_U_I4 = params3+params4.*(I_4alpha.*2.0-2.0);
end
