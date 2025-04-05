% output results

figure
pcolor(Data.XSample,Data.YSample, Maps.s11)
colorbar
axis equal
title('S11 original')
colormap('jet')
shading flat
caxis([-1,1])

figure
pcolor(Data.XSample,Data.YSample, Maps.s22)
colorbar
axis equal
title('S22 original')
colormap('jet')
shading flat
caxis([-1,1])


figure
pcolor(Data.XSample,Data.YSample, Maps.s12)
colorbar
axis equal
title('S12 original')
colormap('jet')
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



S11_= zeros(size(Mesh.X,1),size(Mesh.X,2));
% Calculate the values at the element centers
NodeNo=0;
for i=1:size(Mesh.X,1)
    for j=1:size(Mesh.X,2)
    
        % Calculate the node number
        NodeNo=NodeNo+1;
%          if sum(ismembertol(nod30v,NodeNo))==1

            S11_(i,j) = sigma_m(3*NodeNo-2);

%         else
%             S11_(i,j) = NaN;
%         end
%     
    
    end

end


figure
pcolor(Mesh.X,Mesh.Y, S11_)
colorbar
axis equal
title('S11 processed')
colormap('jet')
shading flat
caxis([-1,1])

% 

S22_= zeros(size(Mesh.X,1),size(Mesh.X,2));
% Calculate the values at the element centers
NodeNo=0;
for i=1:size(Mesh.X,1)
    for j=1:size(Mesh.X,2)
    
        % Calculate the node number
        NodeNo=NodeNo+1;

            
        
        S22_(i,j) = sigma_m(3*NodeNo-1);
    
    
    end

end


figure
pcolor(Mesh.X,Mesh.Y, S22_)
colorbar
axis equal
title('S22 processed')
colormap('jet')
shading flat
caxis([-1,1])




S12_= zeros(size(Mesh.X,1),size(Mesh.X,2));
% Calculate the values at the element centers
NodeNo=0;
for i=1:size(Mesh.X,1)
    for j=1:size(Mesh.X,2)
    
        % Calculate the node number
        NodeNo=NodeNo+1;

            
        
        S12_(i,j) = sigma_m(3*NodeNo);
    
    
    end

end


figure
pcolor(Mesh.X,Mesh.Y, S12_)
colorbar
axis equal
title('S12 processed')
colormap('jet')
shading flat
caxis([-1,1])


SeVM_= zeros(size(Mesh.X,1),size(Mesh.X,2));
for i=1:size(Mesh.X,1)
    for j=1:size(Mesh.X,2)
    
          
        
        SeVM_(i,j) = sqrt(S11_(i,j)^2 + S11_(i,j)*S22_(i,j) + S22_(i,j)^2 + 3* S12_(i,j)^2 );
    
    
    end

end



figure
pcolor(Mesh.X,Mesh.Y, SeVM_)
colorbar
axis equal
title('SeVM processed')
colormap('jet')







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
