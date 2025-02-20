function writefile(filename,numel,nqptv,resdef)

inpFile = fopen(filename,'wt');



for iele=1:numel
    
    for iqpt=1:nqptv
        
        a(1,1:9) = resdef(iele, iqpt, 1:9);
        
        r = [iele, iqpt, a];
        
        fprintf(inpFile,'%d %d \t%e\t%e \t%e \t%e \t%e \t%e \t%e \t%e \t%e \n', r );
        
 
    end
end


% close the file
fclose(inpFile);  


return

end
    