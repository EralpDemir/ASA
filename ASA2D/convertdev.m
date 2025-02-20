function [Maps] = convertdev(Maps)


ni=size(Maps.S11_2,1);
nj=size(Maps.S11_2,2);

for i=1:ni
    for j=1:nj
        s11d =Maps.S11_2(i,j);
        s22d =Maps.S22_2(i,j);
        s12d =Maps.S12_2(i,j);
        
        
        s = [   2, 1, 0;
                1, 2, 0;
                0, 0, 1] * [s11d;s22d;s12d];
            
            
        Maps.s11(i,j)=s(1);     
        Maps.s22(i,j)=s(2);
        Maps.s12(i,j)=s(3);
    end
end


% nk=size(Maps.StressRef,1);
% for k=1:nk
%     
%     s11d=Maps.StressRef(k,1);
%     s22d=Maps.StressRef(k,2);
%     s12d=Maps.StressRef(k,4);
%     
%     
% s = [   2, 1, 0;
%                 1, 2, 0;
%                 0, 0, 1] * [s11d;s22d;s12d];
%             
%             
%         Maps.s11ref(k)=s(1);     
%         Maps.s22ref(k)=s(2);
%         Maps.s12ref(k)=s(3);    
%     
% end






return
end