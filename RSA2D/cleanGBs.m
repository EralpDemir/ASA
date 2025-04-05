function [MapsGB] = cleanGBs(Maps, Data, thres)

MapsGB = Maps;

for i=1:size(Data.X,1)
    for j=1:size(Data.X,2)
%         iele=Data.elno(i,j);
%         
%         if Mesh.GBel(iele)==1
%             MapsGB.S11_2(i,j) = 0;
%             MapsGB.S22_2(i,j) = 0;
%             MapsGB.S12_2(i,j) = 0;
%         end
        

        
        if abs(MapsGB.S11_2(i,j))>thres
            MapsGB.S11_2(i,j) = 0;
            MapsGB.S22_2(i,j) = 0;
            MapsGB.S12_2(i,j) = 0;
        end


        if abs(MapsGB.S22_2(i,j))>thres
            MapsGB.S11_2(i,j) = 0;
            MapsGB.S22_2(i,j) = 0;
            MapsGB.S12_2(i,j) = 0;
        end




        if abs(MapsGB.S12_2(i,j))>thres
            MapsGB.S11_2(i,j) = 0;
            MapsGB.S22_2(i,j) = 0;
            MapsGB.S12_2(i,j) = 0;
        end

    end
end
