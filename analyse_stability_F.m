function [TT,TR,TI,TS,S,T,AE,Em,Ei,Emi,TT1a,TT1b,TT2a,TT2b,TTundefined,TH] = analyse_stability_F (A,D,Dx,Dy)
    %%% set initial variables to be false%%%
    TT=0; %Turing unstable
    TR=0; % remains unstable with diffusion
    TS=0; % stable without diffusion
    TI=0; % unstable without diffusion
    TH=0; % Turing-Hopf instability
    TT1a=0; % Turing Type 1a
    TT1b=0; % Type 1b
    TT2a=0; % Type 2a
    TT2b=0; % Type 2b
    TTundefined=0;

    S=1; %stability without diffusion
    T=1; %stability with diffusion 
    k=0:0.2:10; %wave length lambda

    % >>>>>> calculate eigenvalue vector AE for without diffusion
    AE=[];
    Em=zeros(numel(k),1); 
    Emi=zeros(numel(k),1); %
    AE=zeros(length(A),numel(k));
    Ei=eig(A);
    if max(real(Ei))<0 %all eigenvalues have negative real parts
        TS=1; %which is stable without diffusion
        
        D(1,1)=Dx; %introduce diffusion
        D(2,2)=Dy;
        
        % >>>>>> calculate eigenvalue vector AE for with diffusion
    
        for i=1:numel(k)
            R=A-D*(k(i)^2);
            eigval=eig(R);
            AE(:,i)=eigval;
            [Em(i),idx_max]=max(real(eigval)); %compile real part of largest eigenvalues for all k
            Emi(i)=imag(eigval(idx_max)); %compile corresponding imaginary part 
        end       

        [a,b]=max(Em);

        if a>0
            T=0;
            if Emi(b) == 0
                TT=1; %Turing unstable
                zcd=dsp.ZeroCrossingDetector;
                numZeroCrossing=zcd(Em); %count interception with x-axis
                numpositivelocalmaxima=sum(Em(find(islocalmax(Em)==1))>0)>0; %count positive local maxima
                
                if numpositivelocalmaxima > 0 && mod(numZeroCrossing, 2)==0
                    TT1a=1;
                elseif numpositivelocalmaxima >0 && numZeroCrossing==1
                    TT1b=1;
                elseif numpositivelocalmaxima == 0 && mod(numZeroCrossing,2)==1
                    TT2a=1;
                elseif numpositivelocalmaxima >0 && mod(numZeroCrossing,2)==1
                    TT2b=1;
                else
                    TTundefined=1;
                end

            else
                TH=1; %Turing-Hopf unstable (TS-TT-TR)
            end
            
        else
            TR=1; %remains stable with diffusion
        end                       
    else
        S=0;
        TI=1; %unstable without diffusion
        T="null";
    end         
end