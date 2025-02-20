aa=unique(Maps.RefID);

for i=1:length(aa)


    ref=aa(i);

    % x
    j=Data.RefPoints(ref,1);

    % y
    i=Data.RefPoints(ref,2);





    [ii,jj]=find(Maps.RefID==ref);

    picked=int8(rand*length(ii));

    Data.RefPoints(ref,1)=jj(picked);
    Data.RefPoints(ref,2)=ii(picked);







end


clear aa ref i j ii jj picked

