function [A,D] = gen_matrix_F (n,vr)
        % >>>> generate random matrix without diffusion%%
         
        I=eye(n); %identity matrix representing degradation
        mu = 0; %mean
        B= mu + sqrt(vr)*randn(n); %random matrix generator. allow diagonal term to be non-zero
        A=-I+B; %modified May's matrix form 
        D=eye(n)*0; %initiate diffusion matrix
           
end