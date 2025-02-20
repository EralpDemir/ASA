function [csig] = assignstress(Maps,Data,numel,nqptv,minCI,minIQ,minNIndexedBands)

csig = zeros(3,nqptv,numel);

% Stress data
%S11 = Maps.S11_2(st_x:nd_x,st_y:nd_y);
%S12 = Maps.S12_2(st_x:nd_x,st_y:nd_y);
% Data.S13 = Maps.S13_2(st_x:nd_x,st_y:nd_y);
%S22 = Maps.S22_2(st_x:nd_x,st_y:nd_y);
% Data.S23 = Maps.S23_2(st_x:nd_x,st_y:nd_y);
% Data.S33 = Maps.S33_2(st_x:nd_x,st_y:nd_y);


for i=1:size(Data.XSample,1)
    
    for j=1:size(Data.XSample,2)
        
        iele=Data.elno(i,j);

        flag=0;
        if isnan(Maps.s11(i,j))
            flag=1;
        end

        if isnan(Maps.s22(i,j))
            flag=1;
        end

        if isnan(Maps.s12(i,j))
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
        

        if flag==0
            for k=1:nqptv
                csig(1,k,iele) = Maps.s11(i,j);
                csig(2,k,iele) = Maps.s22(i,j);
                csig(3,k,iele) = Maps.s12(i,j);
                
            end
        end

        
    end
    
end