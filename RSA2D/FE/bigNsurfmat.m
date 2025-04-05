function   [bigNsurf] = bigNsurfmat(nnps,nqpts,ssfac)
% compute bigNs matrix 


ndofnps = 3;
numdim = 2;

iend1 =   nnps*ndofnps;


%bigNsurfpost = zeros(6,6*nnps,nqpts);
bigNsurf = zeros(ndofnps,ndofnps*nnps,nqpts);

sfac_onedof    = zeros(1,nnps);
sfac_3dof    = zeros(ndofnps,iend1);


%bigNsurfpre = zeros(3,6*nnps,nqpts);


for k=1:1:nqpts  
       
   
    
    
    for i=1:1:nnps
        sfac_onedof(i)  = ssfac(i,k);
    end



    for  i=1:1:ndofnps 
        for j = 1:1:nnps % 2
            j1=(i-1)*nnps+j; % [N1,0,0, N2, 0, 0] 
            sfac_3dof(i,j1)  = sfac_onedof(j);
        end
    end

%     for  i=1:1:ndofnps 
%         for j = 1:1:nnps % 2
%             j1=(j-1)*ndofnps+i; % [N1,0,0, N2, 0, 0] 
%             sfac_3dof(i,j1)  = sfac_onedof(j);
%         end
%     end

    bigNsurf(:,:,k)=sfac_3dof;

    
    
    
end



return
    
    
end
 

