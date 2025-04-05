% Eralp Demir
% Sept. 16th, 2021

clear
close all
clc



% Load data file
load data_cropped_R2.mat



% Create mesh
% Nodes per element
nnpe = 4;

% Nodes for surfaces (edges)
nnps = 2;

% Element type (4 noded quadrilateral)
meltyp = 4;

% total number of nodes
sy = size(X,1);
sx = size(X,2);
numnp = sx * sy;

% node coordinates
x = reshape(X,numnp,1);
y = reshape(Y,numnp,1);
crds = [ x, y];


% connectivity
iele=0;
for i=1:sx-1
    for j=1:sy-1
        iele = iele + 1;
        np(iele,1:4) = [ (i-1)*sy + j, (i-1)*sy + j + 1, ...
                           i*sy + j + 1,  i*sy + j ];
    end
end
numel = iele;

% % Check mesh
% figure
% hold on
% for i=1:numel
%     
%     nodes = conn(i,:);
%     
%     % 1-2
%     line([crds(nodes(1),1), crds(nodes(2),1)] , ...
%         [crds(nodes(1),2), crds(nodes(2),2)  ] ,'Color','b')
%     
%     
%     % 2-3
%     line([crds(nodes(2),1), crds(nodes(3),1)] , ...
%         [crds(nodes(2),2), crds(nodes(3),2)  ] ,'Color','b')
%     
%     % 3-4
%     line([crds(nodes(3),1), crds(nodes(4),1)] , ...
%         [crds(nodes(3),2), crds(nodes(4),2)  ] ,'Color','b')
%     
%     
%     % 4-1
%     line([crds(nodes(4),1), crds(nodes(1),1)] , ...
%         [crds(nodes(4),2), crds(nodes(1),2)  ] ,'Color','b')
%     pause
% end

        



% Sort the stress at the nodes
Sxx = reshape(Sxx,numnp,1);
Syy = reshape(Syy,numnp,1);
% Szz = reshape(Szz,numnp,1);
Sxy = reshape(Sxy,numnp,1);
% Sxz = reshape(Sxz,numnp,1);
% Syz = reshape(Syz,numnp,1);

% Vectorize stress components
S = zeros(3*numnp,1);
for i=1:numnp
   
%     S(6*i) = Syz(i);
%     S(6*i-1) = Sxz(i);
%     S(6*i-2) = Sxy(i);
%     S(6*i-3) = Szz(i);
%     S(6*i-4) = Syy(i);
%     S(6*i-5) = Sxx(i);
    

    S(3*i) = Sxy(i);
    S(3*i-1) = Syy(i);
    S(3*i-2) = Sxx(i);    
    
    
end





save stress.mat S

save mesh.mat crds np numel numnp meltyp nnpe nnps




