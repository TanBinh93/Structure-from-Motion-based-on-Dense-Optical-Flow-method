function vectorF = FeatExtraction(I, st)
Descriptor = st.D;
r = (st.dx-1)/2;
[m,n] = size(I);

switch Descriptor
    case 'D_ICIP'
        vectorF = zeros(m,n,8);
        B = zeros(m-2,n-2,9);
        k=0;
        for i = 1:3
            for j = 1:3
                k = k + 1;
                B(:,:,k) = I(i:(i+m-3),j:(j+n-3));
            end
        end
        k = 0;
        for t = 1:9
            if t ~= 5
                k = k+1;
                vectorF(2:end-1,2:end-1,k) = B(:,:,t) - B(:,:,5) ;
            end
        end
        Nor = vectorF(:,:,1).^2 + vectorF(:,:,2).^2 + vectorF(:,:,3).^2+ vectorF(:,:,4).^2 + vectorF(:,:,5).^2+ vectorF(:,:,6).^2+ vectorF(:,:,7).^2+ vectorF(:,:,8).^2;
        Nor = sqrt(Nor) + 1e-09;
        for kk=1:8 
            vectorF(:,:,kk) = vectorF(:,:,kk)./Nor;
        end       

    case  'D1' %% Robinson mask
        vectorF = zeros(m,n,8);
        M1 = [-1 0 1;-2 0 2; -1 0 1]; M2 = [0 1 2; -1 0 1; -2 -1 0];
        M3 = [1 2 1; 0 0 0; -1 -2 -1]; M4 = [2 1 0; 1 0 -1; 0 -1 -2];
        M5 = [1 0 -1; 2 0 -2; 1 0 -1]; M6 = [0 -1 -2; 1 0 -1; 2 1 0];
        M7 = [-1 -2 -1;0 0 0; 1 2 1]; M8 = [-2 -1 0; -1 0 1; 0 1 2];
        F(:,:,1) = imfilter(I,M1);
        F(:,:,2) = imfilter(I,M2);
        F(:,:,3) = imfilter(I,M3);
        F(:,:,4) = imfilter(I,M4);
        F(:,:,5) = imfilter(I,M5);
        F(:,:,6) = imfilter(I,M6);
        F(:,:,7) = imfilter(I,M7);
        F(:,:,8) = imfilter(I,M8);
        vectorF = sign(F);
        %%
    case 'D2'%% Robinson mask
        vectorF = zeros(m,n,8);
        M1 = [-1 0 1;-2 0 2; -1 0 1]; M2 = [0 1 2; -1 0 1; -2 -1 0];
        M3 = [1 2 1; 0 0 0; -1 -2 -1]; M4 = [2 1 0; 1 0 -1; 0 -1 -2];
        M5 = [1 0 -1; 2 0 -2; 1 0 -1]; M6 = [0 -1 -2; 1 0 -1; 2 1 0];
        M7 = [-1 -2 -1;0 0 0; 1 2 1]; M8 = [-2 -1 0; -1 0 1; 0 1 2];
        F(:,:,1) = imfilter(I,M1);
        F(:,:,2) = imfilter(I,M2);
        F(:,:,3) = imfilter(I,M3);
        F(:,:,4) = imfilter(I,M4);
        F(:,:,5) = imfilter(I,M5);
        F(:,:,6) = imfilter(I,M6);
        F(:,:,7) = imfilter(I,M7);
        F(:,:,8) = imfilter(I,M8);
        Nor = F(:,:,1).^2 + F(:,:,2).^2 + F(:,:,3).^2 + F(:,:,4).^2 + F(:,:,5).^2 + F(:,:,6).^2 + F(:,:,7).^2 + F(:,:,8).^2;
        Nor = sqrt(Nor) + 1e-09;
        for k = 1:8
            vectorF(:,:,k) = F(:,:,k)./Nor;
        end
        %%
    case 'D3' %% Kirsch masks
        vectorF = zeros(m,n,8);
        M1 = [-3 -3 5;-3 0 5; -3 -3 5]; M2 = [-3 5 5; -3 0 5; -3 -3 -3];
        M3 = [5 5 5; -3 0 -3; -3 -3 -3]; M4 = [5 5 -3; 5 0 -3; -3 -3 -3];
        M5 = [5 -3 -3; 5 0 -3; 5 -3 -3]; M6 = [-3 -3 -3; 5 0 -3; 5 5 -3];
        M7 = [-3 -3 -3;-3 0 -3; 5 5 5]; M8 = [-3 -3 -3; -3 0 5; -3 5 5];
        F(:,:,1) = imfilter(I,M1);
        F(:,:,2) = imfilter(I,M2);
        F(:,:,3) = imfilter(I,M3);
        F(:,:,4) = imfilter(I,M4);
        F(:,:,5) = imfilter(I,M5);
        F(:,:,6) = imfilter(I,M6);
        F(:,:,7) = imfilter(I,M7);
        F(:,:,8) = imfilter(I,M8);
        Vmax = max(F,[],3);
        Vmin = min(F,[],3);
        Vmax_Vmin = (Vmax - Vmin) +  1e-09;
        for k = 1:8
            vectorF(:,:,k) = F(:,:,k)./Vmax_Vmin;
        end
    case 'D4'
        vectorF = zeros(m,n,9);
        k=0;
        B = zeros(m-2,n-2,9);
        for i = 1:3
            for j = 1:3
                k = k + 1;
                B(:,:,k) = I(i:(i+m-3),j:(j+n-3));
            end
        end
        Vmax = max(B,[],3);
        Vmin = min(B,[],3);
        
        Vmax_Vmin = (Vmax - Vmin) +  1e-09;
        for k = 1:9
            B(:,:,k) = (B(:,:,k) - Vmin)./Vmax_Vmin ;
        end
        vectorF(2:end-1,2:end-1,:)  = exp(B);
        %% Census transform:
    case 'D5'     
        vectorF = zeros(m,n,8);
        B = zeros(m-2,n-2,9);
        k=0;
        for i = 1:3
            for j = 1:3
                k = k + 1;
                B(:,:,k) = I(i:(i+m-3),j:(j+n-3));
            end
        end
        k = 0;
        for t = 1:9
            if t ~= 5
                k = k+1;
                vectorF(2:end-1,2:end-1,k) = B(:,:,t) - B(:,:,5) ;
            end
        end
        vectorF = (vectorF > 0);
        %% CRT transform:
    case 'D6'
        vectorF = zeros(m,n,9);
        B = zeros(m-2,n-2,9);
        k=0;
        for i = 1:3
            for j = 1:3
                k = k + 1;
                B(:,:,k) = I(i:(i+m-3),j:(j+n-3));
            end
        end
        
        for t = 1:9
            M = zeros(m-2,n-2);
            for tt = 1:9
                if tt ~=t
                    D6 = (B(:,:,t) > B(:,:,tt)) ;
                    M = M + D6;
                end
            end
            vectorF(2:end-1,2:end-1,t) = M;
        end
        %% LDP
    case 'D7'
        vectorF = zeros(m,n,8);
        M1 = [-3 -3 5;-3 0 5; -3 -3 5]; M2 = [-3 5 5; -3 0 5; -3 -3 -3];
        M3 = [5 5 5; -3 0 -3; -3 -3 -3]; M4 = [5 5 -3; 5 0 -3; -3 -3 -3];
        M5 = [5 -3 -3; 5 0 -3; 5 -3 -3]; M6 = [-3 -3 -3; 5 0 -3; 5 5 -3];
        M7 = [-3 -3 -3;-3 0 -3; 5 5 5]; M8 = [-3 -3 -3; -3 0 5; -3 5 5];
        F(:,:,1) = imfilter(I,M1);
        F(:,:,2) = imfilter(I,M2);
        F(:,:,3) = imfilter(I,M3);
        F(:,:,4) = imfilter(I,M4);
        F(:,:,5) = imfilter(I,M5);
        F(:,:,6) = imfilter(I,M6);
        F(:,:,7) = imfilter(I,M7);
        F(:,:,8) = imfilter(I,M8);
        
        Fabs = abs(F);
        Fsort = sort(Fabs,3);
        k_largest = Fsort(:,:,3); % k=3
        
        for k = 1:8
            vectorF(:,:,k) = (Fabs(:,:,k) > k_largest);
        end
        %% MLDP:
    case 'D8'
        M1 = [-3 -3 5;-3 0 5; -3 -3 5]; M2 = [-3 5 5; -3 0 5; -3 -3 -3];
        M3 = [5 5 5; -3 0 -3; -3 -3 -3]; M4 = [5 5 -3; 5 0 -3; -3 -3 -3];
        M5 = [5 -3 -3; 5 0 -3; 5 -3 -3]; M6 = [-3 -3 -3; 5 0 -3; 5 5 -3];
        M7 = [-3 -3 -3;-3 0 -3; 5 5 5]; M8 = [-3 -3 -3; -3 0 5; -3 5 5];
        F(:,:,1) = imfilter(I,M1);
        F(:,:,2) = imfilter(I,M2);
        F(:,:,3) = imfilter(I,M3);
        F(:,:,4) = imfilter(I,M4);
        F(:,:,5) = imfilter(I,M5);
        F(:,:,6) = imfilter(I,M6);
        F(:,:,7) = imfilter(I,M7);
        F(:,:,8) = imfilter(I,M8);
        vectorF = sign(F);
        %% Correlation transform
    case 'D9'
        vectorF = zeros(m,n,9);
        B = zeros(m-2,n-2,9);
        k=0;
        for i = 1:3
            for j = 1:3
                k = k + 1;
                B(:,:,k) = I(i:(i+m-3),j:(j+n-3));
            end
        end
        
        Mean = mean(B,3);
        Std  = std(B,1,3) + 1e-09;
        for k = 1:9
            vectorF(2:end-1,2:end-1,k) = (B(:,:,k) - Mean)./Std;
        end
        
        %% NND
    case 'D10'
        vectorF = RF_NND_feature_vector(I,st);
        %%
    case 'D11'
        vectorF = zeros(m,n,8);
        B = zeros(m-2,n-2,9);
        k=0;
        for i = 1:3
            for j = 1:3
                k = k + 1;
                B(:,:,k) = I(i:(i+m-3),j:(j+n-3));
            end
        end
        k = 0;
        for t = 1:9
            if t ~= 5
                k = k+1;
                vectorF(2:end-1,2:end-1,k) = B(:,:,t) - B(:,:,5) ;
            end
        end
        Std  = std(vectorF,1,3) + 1e-09;
        for k = 1:8
            vectorF(:,:,k) = vectorF(:,:,k)./Std;
        end
    otherwise
        disp('Do not know Descriptor!');
end






