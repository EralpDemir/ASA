%% Plotting - All stresses are in GPa
% imagesc(Maps.S11_2);
% caxis([-0.5 0.5]);

clear
load Deformed_FullMaps.mat

%% Crop data
xlim = [75, 125];
ylim = [200, 250];

% [i,j] = find(Data.X>xlim(1) &  Data.X<xlim(2) & Data.Y>ylim(1) &  Data.Y<ylim(2)); 
% 
% i = unique(i);
% j = unique(j);
% 
% 
% llx=min(j);
% urx=max(j);
% 
% lly=min(i);
% ury=max(i);


% Plot original data





figure
pcolor(Data.X,Data.Y,Data.GrainID)
axis equal
title('cropped')
line([Data.X(ylim(1), xlim(1)), Data.X(ylim(1), xlim(2)); 
    Data.X(ylim(1), xlim(2)), Data.X(ylim(2), xlim(2));
    Data.X(ylim(2), xlim(2)),  Data.X(ylim(1), xlim(2));
     Data.X(ylim(1), xlim(2)), Data.X(ylim(1), xlim(1))], ...
    [Data.Y(ylim(1), xlim(1)), Data.Y(ylim(1), xlim(2));
    Data.Y(ylim(1), xlim(2)), Data.Y(ylim(2), xlim(2));
    Data.Y(ylim(2), xlim(2)), Data.Y(ylim(1), xlim(2));
    Data.Y(ylim(1), xlim(2)), Data.Y(ylim(1), xlim(1))], ...
    'color', 'y')



Data.X = Data.X(ylim(1):ylim(2),xlim(1):xlim(2));
Data.Y = Data.Y(ylim(1):ylim(2),xlim(1):xlim(2));
A = Data.GrainID(ylim(1):ylim(2),xlim(1):xlim(2));

% 
% for a=1:urx-llx+1
%     
%     jj= llx + (a-1);
%     
%     for b=1:ury-lly+1
%         
%         ii = lly + (b-1);
%         
%         B(a,b)=A(ii,jj);
%         
%     end
% end
figure
pcolor(Data.X,Data.Y,A)
axis equal
title('cropped')
