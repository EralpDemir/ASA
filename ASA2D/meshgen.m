% Eralp Demir
% 16.09.2021

clear
close all
clc



% Load data file
load data_cropped_R2.mat



% Create mesh
% Nodes per element
nnpe=4;

% total number of nodes
sy = size(X,1);
sx = size(X,2);
totnodes = sx * sy;

% node coordinates
x = reshape(X,totnodes,1);
y = reshape(Y,totnodes,1);
crds = [ x, y];

% connectivity
iele=0;
for i=1:sx-1
    for j=1:sy-1
        iele = iele + 1;
        conn(iele,1:4) = [ (i-1)*sy + j, (i-1)*sy + j + 1, ...
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

        


save mesh.mat crds conn




