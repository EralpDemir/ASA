function [Maps]= synthetic_bending(Data, Maps,num_ref)


% Neutral axis
NA=mean(Data.Y_axis);

% Max y
ymax=max(Data.Y_axis);

% Maximum bending strain on the top surface
epsmax = 0.2/100; % 0.1%


% For Steel
C11=233.5e3; %MPa
C12=135.5e3; %MPa
C44=118.0e3; %MPa



% Stifness Matrix(6x6)
D0=[  C11 C12 C12 0   0    0;
       C12 C11 C12 0   0    0;
       C12 C12 C11 0   0    0;
       0   0   0   C44 0    0;
       0   0   0   0   C44  0;
       0   0   0   0   0    C44 ];



% for each data point
for j=1:1:Data.xpts
    for i=1:1:Data.ypts
        
        ycoord=Data.YSample(i,j);

        eps=epsmax * (ycoord-NA)/(ymax-NA);

        eps6 = zeros(6,1);
        eps6(1) = eps;


        phi1=Data.phi1(i,j);
        phi2=Data.phi2(i,j);
        PHI=Data.PHI(i,j);



        g = Eulerang2ori(phi1, PHI, phi2);

        invg = g';
           
           
           
        % Bond, W.L., 1943. The mathematics of the physical properties of crystals. 
        % The Bell System Technical Journal, 22(1), pp.1-72.
        % Transformation of elasticity
        ROT = [   invg(1,1)^2, invg(1,2)^2, invg(1,3)^2, 2*invg(1,1)*invg(1,2), 2*invg(1,3)*invg(1,1), 2*invg(1,2)*invg(1,3);
            invg(2,1)^2, invg(2,2)^2, invg(2,3)^2, 2*invg(2,1)*invg(2,2), 2*invg(2,3)*invg(2,1), 2*invg(2,2)*invg(2,3);
            invg(3,1)^2, invg(3,2)^2, invg(3,3)^2, 2*invg(3,1)*invg(3,2), 2*invg(3,3)*invg(3,1), 2*invg(3,2)*invg(3,3);
            invg(1,1)*invg(2,1), invg(1,2)*invg(2,2), invg(1,3)*invg(2,3), invg(1,1)*invg(2,2)+invg(1,2)*invg(2,1), invg(1,3)*invg(2,1)+invg(1,1)*invg(2,3), invg(1,2)*invg(2,3)+invg(1,3)*invg(2,2);
            invg(3,1)*invg(1,1), invg(3,2)*invg(1,2), invg(3,3)*invg(1,3), invg(1,1)*invg(3,2)+invg(1,2)*invg(3,1), invg(1,3)*invg(3,1)+invg(1,1)*invg(3,3), invg(1,2)*invg(3,3)+invg(1,3)*invg(3,2);
            invg(2,1)*invg(3,1), invg(2,2)*invg(3,2), invg(2,3)*invg(3,3), invg(2,2)*invg(3,1)+invg(2,1)*invg(3,2), invg(2,1)*invg(3,3)+invg(2,3)*invg(3,1), invg(2,2)*invg(3,3)+invg(2,3)*invg(3,2);];
        
        % Transformed elasticity to the sample reference frame    
        D = ROT * D0 * ROT';


        sig6 = D * eps6;

        Maps.s11(i,j)=sig6(1);
        Maps.s22(i,j)=sig6(2);
        Maps.s33(i,j)=sig6(3);
        Maps.s12(i,j)=sig6(4);
        Maps.s13(i,j)=sig6(5);
        Maps.s23(i,j)=sig6(6);

        
    end
end




grains=unique(Maps.RefID);
% Store the reference point stresses
sig0=zeros(num_ref,6);
for i=1:1:num_ref


        grain=grains(i);
        
        jj=Data.RefPoints(grain,1);
        ii=Data.RefPoints(grain,2);

        sig0(i,1) = Maps.s11(ii,jj);
        sig0(i,2) = Maps.s22(ii,jj);
        sig0(i,3) = Maps.s33(ii,jj);
        sig0(i,4) = Maps.s12(ii,jj);
        sig0(i,5) = Maps.s13(ii,jj);
        sig0(i,6) = Maps.s23(ii,jj);


end



% Subtract the reference points
for j=1:1:Data.xpts
    for i=1:1:Data.ypts

        grain=Maps.RefID(i,j);
        Refpt=find(grains==grain);


        Maps.s11(i,j)=Maps.s11(i,j)-sig0(Refpt,1);
        Maps.s22(i,j)=Maps.s22(i,j)-sig0(Refpt,2);
        Maps.s33(i,j)=Maps.s33(i,j)-sig0(Refpt,3);
        Maps.s12(i,j)=Maps.s12(i,j)-sig0(Refpt,4);
        Maps.s13(i,j)=Maps.s13(i,j)-sig0(Refpt,5);
        Maps.s23(i,j)=Maps.s23(i,j)-sig0(Refpt,6);



    end
end


return
end