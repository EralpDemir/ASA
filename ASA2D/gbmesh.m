function [Mesh]=gbmesh(Mesh,Data)

% Loop throgh the nodes


Mesh.GBel=zeros(1,Mesh.numel);



ny = size(Data.X,1);
nx = size(Data.X,2);



% Plot grain boundaries
figure
hold on
Z=zeros(size(Mesh.X));
surf(Mesh.X,Mesh.Y,Z);
axis equal

GBlist=[];

nps=[];

% Flag for the GB of the element
Mesh.GBedge=zeros(Mesh.numel,4);

% This part of the code is not generic
% This strongly depends on how the mesh is constructed
for i=1:ny-1
    
    for j=1:nx-1
    
        % host element number
        hel = (i-1)*nx + j;
        
        hGID = Data.elGrainID(hel);
        
        
        % Check neighbor 2-3
        nel = (i-1)*nx + j + 1;
        
        nGID = Data.elGrainID(nel);
        
        flag23=0;
        
        if hGID~=nGID
            
             Mesh.GBel(hel)=1;
            
             Mesh.GBel(nel)=1;
             
             Mesh.GBedge(nel,2)=1;
             
             plot(Mesh.crds(Mesh.np(hel,2),1),Mesh.crds(Mesh.np(hel,2),2),'ro')
             
             GBlist=[GBlist, Mesh.np(hel,2), Mesh.np(hel,3)];
             
             nps= [nps; Mesh.np(hel,2), Mesh.np(hel,3);];
             
             flag23=1;
             
        end
    
        
        % Check neighbor 3-4
        nel = i*nx + j;
        
        nGID = Data.elGrainID(nel);
        
        
        if hGID~=nGID
            
            Mesh.GBel(hel)=1;
            
            Mesh.GBel(nel)=1;
            
            Mesh.GBedge(nel,3)=1;
            
            plot(Mesh.crds(Mesh.np(hel,3),1),Mesh.crds(Mesh.np(hel,4),2),'ro');
            

             
            
            if flag23==0
                GBlist=[GBlist, Mesh.np(hel,3), Mesh.np(hel,4)];
            else
                GBlist=[GBlist, Mesh.np(hel,4)];
            end
           
            nps = [nps; Mesh.np(hel,3), Mesh.np(hel,4);];
            
        end
    
    end
    
end



% for the last row
i=ny;
for j=1:nx-1
    % host element number
    hel = (i-1)*nx + j;

    hGID = Data.elGrainID(hel);


    % Check neighbor 2-3
    nel = (i-1)*nx + j + 1;

    nGID = Data.elGrainID(nel);
        
    if hGID~=nGID
            
        Mesh.GBel(hel)=1;

        Mesh.GBel(nel)=1;

        Mesh.GBedge(nel,2)=1;

        plot(Mesh.crds(Mesh.np(hel,3),1),Mesh.crds(Mesh.np(hel,4),2),'bo');
        
        GBlist = [GBlist, Mesh.np(hel,2), Mesh.np(hel,3)];
        
        
        nps= [nps; Mesh.np(hel,2), Mesh.np(hel,3);];
        
    end
    
end





% Last column
j=nx;
for i=1:ny-1
    
    % host element number
    hel = (i-1)*nx + j;

    hGID = Data.elGrainID(hel);
    
    
    % Check neighbor 3-4
    nel = i*nx + j;

    nGID = Data.elGrainID(nel);


    if hGID~=nGID

        Mesh.GBel(hel)=1;

        Mesh.GBel(nel)=1;

        Mesh.GBedge(nel,3)=1;

        plot(Mesh.crds(Mesh.np(hel,3),1),Mesh.crds(Mesh.np(hel,4),2),'yo');


        GBlist = [GBlist, Mesh.np(hel,3), Mesh.np(hel,4)];
        
        
        nps = [nps; Mesh.np(hel,3), Mesh.np(hel,4);];
        
    end
    
end

    
    
    
    
    
    
%     % For all of the elements add a new node to the list except the host
%     % element (that is why -1 is subtracted!)
%     if size(elno,1)-1>0
%         
%         % Flag for plotting nodes
%         for j=1:size(elno,1)-1
% 
% 
% 
% 
% 
% 
%            iele=elno(j+1);
%            inode=nodeno(j+1);
%             
%            
%            if Data.GrainID(iele)~=hgrainId
% 
%                 plot(Mesh.crds(i,1),Mesh.crds(i,2),'ro')
%                 
%           
%                
%                 GBlist=[GBlist, i];
% 
%                 Mesh.GBel(i)=1;
%                 
% 
%            end
% 
% 
% 
% 
%         end
%         
%     end
    
    
    






% 
% 
% 
% for iele=1:Mesh.numel
%    
%     
%     % Nodes 1-2
%     flag1=0;flag2=0;
%     for j=1:size(GBlist,2)
%         
%        if GBlist(j)==Mesh.np(iele,1)
%            flag1=1;
%        end
%        
%        if GBlist(j)==Mesh.np(iele,2)
%            flag2=1;
%        end
%         
%     end
%     
%     Mesh.GBedge(iele,1)=flag1*flag2;
%     
%     
%     
%     % Nodes 2-3
%     flag1=0;flag2=0;
%     for j=1:size(GBlist,2)
%         
%        if GBlist(j)==Mesh.np(iele,2)
%            flag1=1;
%        end
%        
%        if GBlist(j)==Mesh.np(iele,3)
%            flag2=1;
%        end
%         
%     end
%     
%     Mesh.GBedge(iele,2)=flag1*flag2;    
%     
%     
%     
%     
%     % Nodes 3-4
%     flag1=0;flag2=0;
%     for j=1:size(GBlist,2)
%         
%        if GBlist(j)==Mesh.np(iele,3)
%            flag1=1;
%        end
%        
%        if GBlist(j)==Mesh.np(iele,4)
%            flag2=1;
%        end
%         
%     end
%     
%     Mesh.GBedge(iele,3)=flag1*flag2;    
%     
%     
%     % Nodes 4-1
%     flag1=0;flag2=0;
%     for j=1:size(GBlist,2)
%         
%        if GBlist(j)==Mesh.np(iele,4)
%            flag1=1;
%        end
%        
%        if GBlist(j)==Mesh.np(iele,1)
%            flag2=1;
%        end
%         
%     end
%     
%     Mesh.GBedge(iele,4)=flag1*flag2;    
%      
%     
% end
    



% 
% nps=[];
% % find the grain boundary segments
% for iele=1:Mesh.numel
%     
% 
%     for j=1:4
%     
%         if Mesh.GBedge(iele,j)==1
%     
%             
%             if j== 1
% 
%                 dum=[ Mesh.np(iele,1),Mesh.np(iele,2);];
%                 
%             elseif j== 2
%                 
%                 dum=[ Mesh.np(iele,2),Mesh.np(iele,3);];
%                 
%             elseif j== 3
%                 
%                 dum=[ Mesh.np(iele,3),Mesh.np(iele,4);];
%         
%             elseif j== 4
%                 
%                 dum=[ Mesh.np(iele,4),Mesh.np(iele,1);];
%                 
%                 
%             end
%            
%             
%             % Check if it is not already assigned
%             flag=0;
%             
%             for iels=1:size(nps,1)
%         
%                 if dum(1)==nps(iels,1) && dum(2)==nps(iels,2)
%                     flag=1;
%                 end
%                 
%                 if dum(1)==nps(iels,2) && dum(2)==nps(iels,1)
%                     flag=1;
%                 end
%                 
%             end
%             
%             
%             if flag==0
%        
%                 nps= [nps; dum];
%         
%             end
%             
%             
% 
% 
%             
%         end
% 
%     end
%         
% 
%     
%     
%         
% 
%     
%     
%     
% end





Mesh.numels=size(nps,1);
Mesh.nps=nps;




return

end
