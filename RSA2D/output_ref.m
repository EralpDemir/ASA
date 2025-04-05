% output results

figure
pcolor(Data.XSample,Data.YSample, Maps.s11)
colorbar
axis equal
colormap jet
title('S11 original')
shading flat
caxis([-1,1])

figure
pcolor(Data.XSample,Data.YSample, Maps.s22)
colorbar
axis equal
colormap jet
title('S22 original')
shading flat
caxis([-1,1])


figure
pcolor(Data.XSample,Data.YSample, Maps.s12)
colorbar
axis equal
colormap jet
title('S12 original')
shading flat
caxis([-1,1])

% vec(1,:)=csig(1,1,:);
% figure
% colormap(jet(256))
% imagesc(Data.elctrx,Data.elctry, vec)
% colorbar
% axis equal
% title('S11 transferred')




sigma_m=sigma;

% Clean the data points
for i=1:size(Data.XSample,1)
    for j=1:size(Data.XSample,2)
     
        % Corresponding element number
        noel=Data.elno(i,j);

        % Find the nodes:
        nodes = np(noel,:);
        

        flag=0;
        if isnan(Maps.s13(i,j))
            flag=1;
        end

        if isfield(Data,'CI')
            if Data.CI(i,j)<minCI
                flag=1;
            end
        end
            
        if isfield(Data,'IQ')
            if Data.IQ(i,j)<minIQ
                flag=1;
            end
        end
        
        if isfield(Data,'NIndexedBands')
            if Data.NIndexedBands(i,j)<minNIndexedBands
                flag=1;
            end
        end

        if flag==1
            sigma_m(3*nodes) = NaN;
            sigma_m(3*nodes-1) = NaN;
            sigma_m(3*nodes-2) = NaN;
        end


    end
end





% Compute reference stresses
Sref=zeros(3,Maps.numref);
for iref=1:Maps.numref
    
    jj=Data.RefPoints(iref,1);
    ii=Data.RefPoints(iref,2);


    iele=Data.elno(ii,jj);

    % Calculate the nodes
    Nodes=Mesh.np(iele,:);
    for k=1:1:Mesh.nnpe

        NodeNo=Nodes(k);
        Sref(1,iref) = Sref(1,iref) +sigma_m(3*NodeNo-2);
        Sref(2,iref) = Sref(2,iref) +sigma_m(3*NodeNo-1);
        Sref(3,iref) = Sref(3,iref) +sigma_m(3*NodeNo);
    end
    Sref(1,iref)=Sref(1,iref)/Mesh.nnpe;
    Sref(2,iref)=Sref(2,iref)/Mesh.nnpe;
    Sref(3,iref)=Sref(3,iref)/Mesh.nnpe;

end

S11_= zeros(size(Data.XSample,1),size(Data.XSample,2));
% Calculate the values at the element centers
for i=1:size(Data.XSample,1)
    for j=1:size(Data.XSample,2)
    
        % Element no
        iele=Data.elno(i,j);


        % Reference point
        iref=Maps.refID_el(iele);
        



    
        % Stress component
        S11_ref=Sref(1,iref);

        % Calculate the nodes
        Nodes=Mesh.np(iele,:);
%          if sum(ismembertol(nod30v,NodeNo))==1
        for k=1:1:Mesh.nnpe

            NodeNo=Nodes(k);
            S11_(i,j) = S11_(i,j) +sigma_m(3*NodeNo-2)-S11_ref;

        end

        S11_(i,j)=S11_(i,j)/Mesh.nnpe;

%         else
%             S11_(i,j) = NaN;
%         end
%     
    
    end

end


figure
pcolor(Data.XSample,Data.YSample, S11_)
colorbar
axis equal
colormap jet
title('S11 processed')
shading flat
caxis([-1,1])
%
%
%
S22_= zeros(size(Data.XSample,1),size(Data.XSample,2));
% Calculate the values at the element centers
for i=1:size(Data.XSample,1)
    for j=1:size(Data.XSample,2)
    
        % Element no
        iele=Data.elno(i,j);


        % Reference point
        iref=Maps.refID_el(iele);
        



    
        % Stress component
        S22_ref=Sref(2,iref);


        % Calculate the nodes
        Nodes=Mesh.np(iele,:);
%          if sum(ismembertol(nod30v,NodeNo))==1
        for k=1:1:Mesh.nnpe

            NodeNo=Nodes(k);
            S22_(i,j) = S22_(i,j) +sigma_m(3*NodeNo-1)-S22_ref;

        end

        S22_(i,j)=S22_(i,j)/Mesh.nnpe;

%         else
%             S11_(i,j) = NaN;
%         end
%     
    
    end

end


figure
pcolor(Data.XSample,Data.YSample, S22_)
colorbar
axis equal
colormap jet
title('S22 processed')
shading flat
caxis([-1,1])




S12_= zeros(size(Data.XSample,1),size(Data.XSample,2));
% Calculate the values at the element centers
for i=1:size(Data.XSample,1)
    for j=1:size(Data.XSample,2)
    
        % Element no
        iele=Data.elno(i,j);


        % Reference point
        iref=Maps.refID_el(iele);
        



    
        % Stress component
          S12_ref=Sref(3,iref);

        % Calculate the nodes
        Nodes=Mesh.np(iele,:);
%          if sum(ismembertol(nod30v,NodeNo))==1
        for k=1:1:Mesh.nnpe

            NodeNo=Nodes(k);
            S12_(i,j) = S12_(i,j) +sigma_m(3*NodeNo)-S12_ref;

        end

        S12_(i,j)=S12_(i,j)/Mesh.nnpe;

%         else
%             S11_(i,j) = NaN;
%         end
%     
    
    end

end


figure
pcolor(Data.XSample,Data.YSample, S12_)
colorbar
axis equal
colormap jet
title('S12 processed')
shading flat
caxis([-1,1])


SeVM_= zeros(size(Data.XSample,1),size(Data.XSample,2));
for i=1:size(Data.XSample,1)
    for j=1:size(Data.XSample,2)
    
          
        
        SeVM_(i,j) = sqrt( 0.5*(S11_(i,j)-S22_(i,j))^2 ...
           + 0.5*S11_(i,j)^2 + 0.5*S22_(i,j)^2 + ...
           3*S12_(i,j)^2 );
    
    
    end

end



figure
pcolor(Data.XSample,Data.YSample, SeVM_)
colorbar
axis equal
title('SeVM processed')







divsig = zeros(numel,1);
for iele=1:numel
    bmat=Bmat{iele};

    nodes=np(iele,:);
    
    
    sigel=[];
    for inod=1:nnpe
        sigel = [sigel; sigma(3*nodes(inod)-2:1:3*nodes(inod))];
    end

     a = bmat *  sigel;
     
    
    divsig(iele) = sqrt(a'*a);
end



Divergence=zeros(size(Data.X,1),size(Data.X,2));
for i=1:size(Data.X,1)
    for j=1:size(Data.X,2)
    
        iele=Data.elno(i,j);

        Divergence(i,j) = divsig(iele);
        
    end
end


figure
pcolor(Data.X,Data.Y, Divergence)
colorbar
axis equal
title('Divergence')



% figure
% pcolor(Data.X,Data.Y, S22)
% colorbar
% axis equal
% title('S22 original')
% 
% 
% 
% 
% S22_c= zeros(size(Data.X,1),size(Data.X,2));
% % Calculate the values at the element centers
% for i=1:size(Data.X,1)
%     for j=1:size(Data.X,2)
%     
%         iele=Data.elno(i,j);
%     
%         av=0;
%         for inod=1:nnpe
% 
%             NodeNo=np(iele,inod);
% 
%             av = av + sigma(3*NodeNo-1)/nnpe;
% 
%         end
%         
%         S22_c(i,j) = av;
%     
%     
%     end
% 
% end
% 
% 
% figure
% pcolor(Data.X,Data.Y, S22_c)
% colorbar
% axis equal
% title('S22 processed')
%     
