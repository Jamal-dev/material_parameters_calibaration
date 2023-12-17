function [I1barList,I2barList, ...
            I3List, ...
            I4barList,I5barList, ...
            Base1List, ...
            Base2List, ...
            Base4List, ...
            Base5List ...
            ] ...
            =get_requiredValues(epsMatrix,ai)
    
        
    km = size(epsMatrix,1);
    I1barList = zeros(km,1);
    I2barList = zeros(km,1);
    I3List = zeros(km,1);
    I4barList = zeros(km,1);
    I5barList = zeros(km,1);
    JList = zeros(km,1);
    Base1List = zeros(km,3,3);
    Base2List = zeros(km,3,3);
    Base4List = zeros(km,3,3);
    Base5List = zeros(km,3,3);
    for k=1:km
        eps11 = epsMatrix(k,1);
        eps22 = epsMatrix(k,2);
        eps33 = epsMatrix(k,3);
        eps12 = epsMatrix(k,4);
        eps13 = epsMatrix(k,5);
        eps23 = epsMatrix(k,6);
   
        [b,bbar,J,Fbar,F]=get_F_from_nominalstrain([eps11,eps22,eps33,eps12,eps13,eps23]);
        
        a_bar = Fbar * ai;
        a_bar_dash = bbar * a_bar;
        
        bbar_squared = bbar * bbar;
        % calculating invariances
        I1bar = trace(bbar);
        I2bar = 0.5*(I1bar*I1bar - trace(bbar_squared));
        I3 = J;
        Cbar = Fbar'*Fbar;
        a0xa0 = get_dyad(ai,ai);
        I4alpha = double_dotProd(Cbar,a0xa0);
        I5alpha = double_dotProd(Cbar*Cbar,a0xa0);
        
        % calculating bases
        base1 = bbar;
        base2 = bbar_squared;

        base4 = 2*get_dyad(a_bar,a_bar);
        base5 = 2*get_dyad(a_bar_dash,a_bar) + 2*get_dyad(a_bar,a_bar_dash);
        
            
        I1barList(k) = I1bar;
        I2barList(k) = I2bar;
        I3List(k) = I3;
        I4barList(k) = I4alpha;
        I5barList(k) = I5alpha;
        JList(k)     = J;
        
        Base1List(k,:,:) = deviatoric(base1);
        Base2List(k,:,:) = deviatoric(base2);
        Base4List(k,:,:) = deviatoric(base4);
        Base5List(k,:,:) = deviatoric(base5);
        
    end
    
end