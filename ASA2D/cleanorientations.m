function [Data]=cleanorientations(Data)


nx = size(Data.X,1);
ny = size(Data.X,2);


numel=nx*ny;

for iele=1:numel

    
    hGID=Data.elGrainID(iele);


    if hGID==0

        % Search through neighbors
        
        % Center coordinates of home point
        hcx= Data.elctrx(iele);
        hcy= Data.elctry(iele);
        
        % Other points
        dist=zeros(1,numel);
        for jele=1:numel
            
            % Center coordinates of neighbor point
            ncx= Data.elctrx(jele);
            ncy= Data.elctry(jele);
            
            % Distance to the neighbor point
            dist(jele)=sqrt((hcx-ncx)^2+(hcy-ncy)^2);
            
            

        end
        
        % Sort the distances
        [dis, ind] = sort(dist);
        
        
        % Start from the nearest one
        flag=0;i=1;
        while flag==0
            
            i=i+1;
            
            jele = ind(i);
            
            nGID=Data.elGrainID(jele);
            
            if nGID~=0
                flag=1;
               
                Data.elGrainID(iele) = Data.elGrainID(jele);
                Data.Phi1(iele) = Data.Phi1(jele);
                Data.Phi(iele) = Data.Phi(jele);
                Data.Phi2(iele) = Data.Phi2(jele);
                
            end
               
            
        end


    end
        
            
        

end
