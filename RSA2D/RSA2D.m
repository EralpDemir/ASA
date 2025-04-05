% Program residual_stress_2d
% Eralp Demir
% Sept. 16th, 2021
% March 31st, 2022

%  driver program for 2-d residual stress determination
clear
clc
close all


inputs

addpath('FE')


tic



% Load the given data file
load(filename)


% % Crop the data
% [Data,Maps] = crop(Data,Maps,st_x,nd_x,st_y,nd_y);

% Synthetic uniform bending strains
[Maps]= synthetic_bending(Data, Maps, num_ref);


% % Add the reference stresses 
% [Maps] = addrefstress(Maps,Data);

% 
% % Convert deviatoric stresses stresses
% [Maps] = convertdev(Maps);





% Take out elements in the mesh

% Create mesh
[Mesh,Data]=generatemesh(Data);


% % Assign orientations with grainID=0
% [Data]=cleanorientations(Data);

% % Find grain boundary nodes
% [MeshGB]=gbmesh(Mesh,Data);
% 
% % Set the stresses at the GBs to zero!
% [MapsGB] = cleanGBs(Maps, Data, thres);
% 


numel=Mesh.numel;
meltyp=Mesh.meltyp;
nnpe=Mesh.nnpe;
nnps=Mesh.nnps;
crds=Mesh.crds;
np=Mesh.np;
numnp=Mesh.numnp;
% numels=Mesh.numels;
% nps=Mesh.nps;


%evaluates elemental information: shape function derivatives etc at the
%quadrature points
[nqptv,wtq,sfac,dndxi,dndet,nqpts,swt,ssfac,dnds] = shafac(meltyp,nnpe,nnps);


% Assign the given stresses to the quadrature points
[csig] = assignstress(Maps,Data,numel,nqptv,minCI,minIQ,minNIndexedBands);



% Reference point corresponding to each element
[Maps] = assignrefpoints(Maps,Data,Mesh);


numelwithRefID = Maps.numelwithRefID;

% now start the computation of the global stress  
%  the global stress is found by fitting it to the experimental diffracton
%  stresses using a consistent resultant integral.  This is penalized with
%  the equilibrium equation.    We're assuming 2D stress fields.

Fsr=zeros(numel*3*nnpe,1);
Fsv=zeros(numel*3*nnpe,1); 
Qsr=zeros(numelwithRefID*9*nnpe*nnpe,1); 
Qsc=zeros(numelwithRefID*9*nnpe*nnpe,1); 
Qsv=zeros(numelwithRefID*9*nnpe*nnpe,1);
Rsr=zeros(numelwithRefID*9*nnpe*nnpe,1); 
Rsc=zeros(numelwithRefID*9*nnpe*nnpe,1); 
Rsv=zeros(numelwithRefID*9*nnpe*nnpe,1);
Msr=zeros(numel*9*nnpe*nnpe,1); 
Msc=zeros(numel*9*nnpe*nnpe,1); 
Msv=zeros(numel*9*nnpe*nnpe,1);
Csr=zeros(numel*9*nnpe*nnpe,1); 
Csc=zeros(numel*9*nnpe*nnpe,1); 
Csv=zeros(numel*9*nnpe*nnpe,1);
fc=1; mc=1; cc=1; qc=1; rc=1;

% Bmat=zeros(2,3*nnpe,numel);



numgdof = 3*numnp;
% gsig = zeros(1,numgdof); 

% loop over the elements to set up matrices
x = crds(:,1);
y = crds(:,2);


[dndx,dndy,detj] = sfder(1,nnpe,nqptv,dndxi,dndet,np,x,y);
[se,ce] = elstif_residual(nnpe,nqptv,wtq,sfac,dndx,dndy,detj);
[fe_coeff] = elforc_residual_coeff(nnpe,nqptv,wtq,sfac,detj);




for iele =1:1:numel
   
  
    
  
    sig = zeros(3,nqptv);
    for j = 1:1:nqptv
      
        sig(1,j) = csig(1,j,iele);
        sig(2,j) = csig(2,j,iele);
        sig(3,j) = csig(3,j,iele);
      
    end
  
    fe = zeros(3*nnpe,1);
    for i=1:3
        for j=1:nqptv
            fe = fe + fe_coeff(:,i,j) * sig(i,j);
        end
    end
    

  
    % Assemble pseudo-force vector
    [Fsr,Fsv,fc] = assmbl_vec(iele,nnpe,np,fe,Fsr,Fsv,fc);
  
   
  
    % Assemble least squares constraint to the reference stresses
    iref = Maps.refID_el(iele);


    %iref_el = Maps.ref_el(iref);
%     % Do not assemble if the element is the same
%     if ~(iref_el==iele)
% 

    np_RefPoints=Maps.np_RefPoints(iref,1:nnpe);
    [Qsr,Qsc,Qsv,qc] = assmbl_qmat_new(iele,nnpe,numnp,np,iref,-se,Qsr,Qsc,Qsv,qc);
    [Rsr,Rsc,Rsv,rc] = assmbl_qmat_new(iele,nnpe,numnp,np,iref,-ce,Rsr,Rsc,Rsv,rc);

        
%     end


    if ~(iele==iref)
        % Assemble least squares constraint
        [Msr,Msc,Msv,mc] = assmbl_mat(iele,nnpe,np,se,Msr,Msc,Msv,mc);
    
        % Assemble equilibrium constraint
        [Csr,Csc,Csv,cc] = assmbl_mat(iele,nnpe,np,ce,Csr,Csc,Csv,cc);
    end
  
    
  
    disp([ num2str(iele/numel*100) '  % of the constraints applied!'])
  
end




% Overall stiffness
aa=find(Msr==0);
Msr(aa)=[];Msc(aa)=[];Msv(aa)=[];
Ms=sparse(Msr,Msc,Msv);
clear Msr Msc Msv

aa=find(Csr==0);
Csr(aa)=[];Csc(aa)=[];Csv(aa)=[];
Cs=sparse(Csr,Csc,Csv);
clear Csr Csc Csv

% Qs=sparse(Qsr,Qsc,Qsv);
% clear Qsr Qsc Qsv

Fs=sparse(Fsr,1,Fsv);
clear Fsr Fsv





% Overall stiffness
Qs=sparse(Qsr,Qsc,Qsv);
clear Qsr Qsc Qsv

Rs=sparse(Rsr,Rsc,Rsv);
clear Rsr Rsc Rsv

Ks= [Ms, Qs; Cs, Rs];




Ts=[Fs; zeros(numnp*3,1)];


% solve 
sigma = full(Ks\Ts);


sigma_ref = sigma(numnp*3+1:1:end);

sigma = sigma(1:1:numnp*3);





toc




