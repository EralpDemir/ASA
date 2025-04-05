function [Maps] = assignrefpoints(Maps,Data,Mesh)

num_ref=size(Data.RefPoints,1);

Maps.numref = num_ref;

Maps.ref_el = zeros(Maps.numref,1);

Maps.refID_el = zeros(Mesh.numel,1);

Maps.np_RefPoints = zeros(Maps.numref,Mesh.nnpe);

% no=0;

iref=0;
for i=1:size(Maps.RefID,1)
    
    for j=1:size(Maps.RefID,2)
        
        iele = Data.elno(i,j);
        
        iref = Maps.RefID(i,j);
        
        if isnan(iref)
            iref=0;
        end
        
        Maps.refID_el(iele) = iref;

        if ~(iref==0)
            % Reference point element number
            if Data.RefPoints(iref,1)==j
                if Data.RefPoints(iref,2)==i
                    % no=no+1;
                    % disp([num2str(no), ' th reference point assigned!'])
                    Maps.np_RefPoints(iref,:) = Mesh.np(iele,:);
                    Maps.ref_el(iref)=iele;
                end
            end
        end
        
        
    end
    
end

aa =isnan(Maps.RefID);

Maps.numelwithRefID = Mesh.numel-sum(sum(aa));

return
end