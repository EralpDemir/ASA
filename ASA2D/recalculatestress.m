function [resdef] = recalculatestress(Data,sigma,np,numel,sfac,nqptv,nnpe,comp)

resdef=zeros(numel,nqptv,9);

% Find the stress at the nodes of each element
for iele=1:numel
    
    % Find the index among the data points
    [a,b] = find(Data.elno==iele);

    
    % Get the Euler angles of the element (radians)
    phi1 = Data.Phi1(a,b);
    PHI= Data.Phi(a,b);
    phi2 = Data.Phi2(a,b); 
    
    % Calculate the sample to crystal transformation matrix
    [g] = Eulerang2ori(phi1, PHI, phi2);

    
    % Nodes of element
    nodes = np(iele,1:nnpe); 
    
    
    % Find the stress results at these nodes
    S11=zeros(nnpe,1);S22=zeros(nnpe,1);S12=zeros(nnpe,1);
    for i=1:nnpe
        
        S11(i)=sigma(3*nodes(i)-2);
        S22(i)=sigma(3*nodes(i)-1);
        S12(i)=sigma(3*nodes(i));
        
    end
    
    
    % Map the stresses tothe quad points
    for iqpt=1:nqptv
        
        % Interpolation functions
        N = sfac(:,iqpt)';
        
        S11q = N * S11;
        
        S22q = N * S22;
        
        S12q = N * S12;
        
        
        % Stress tensor
        S = [S11q, S12q, 0;
            S12q, S22q, 0;
            0, 0, 0;];
        
        % Transform to the crystal reference
        Sc = g * S * g';
        
        scvec = [Sc(1,1); Sc(2,2); Sc(3,3); Sc(1,2); Sc(1,3); Sc(2,3);];
        
        % Find the corresponding elastic strain
        ecvec = comp * scvec;
        
        Ec = [  ecvec(1), ecvec(4), ecvec(5);
                ecvec(4), ecvec(2), ecvec(6);
                ecvec(5), ecvec(6), ecvec(3)];
        
        % Calculate the approximate residual deformation
        Fr = eye(3) + Ec;
        
        
        resdef(iele,iqpt, 1:9)= [Fr(1,1), Fr(1,2), Fr(1,3), Fr(2,1), Fr(2,2), Fr(2,3), Fr(3,1), Fr(3,2), Fr(3,3)]; 
        
        
    end
    
    
    
    
end