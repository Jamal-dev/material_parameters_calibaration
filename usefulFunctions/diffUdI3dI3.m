function derv_U_dI3_dI3 = diffUdI3dI3(in1,I_1,I_2,J,I_4alpha,I_5alpha)
%diffUdI3dI3
%    derv_U_dI3_dI3 = diffUdI3dI3(IN1,I_1,I_2,J,I_4alpha,I_5alpha)

%    This function was generated by the Symbolic Math Toolbox version 9.3.
%    17-Dec-2023 22:29:25

params1 = in1(:,1);
derv_U_dI3_dI3 = 2.0./params1;
end
