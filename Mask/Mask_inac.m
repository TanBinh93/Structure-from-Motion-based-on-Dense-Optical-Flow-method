%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Authors: Tan-Binh Phan, Dinh-Hoan Trinh, Christian Daul, Didier Wolf   %
%  Contact: tan-binh.phan@univ-lorraine.fr                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Mask  = Mask_inac(M,N,u1,v1,u2,v2, occ_thr)
Mask = zeros(M,N);
for i = 1:M
    for j = 1:N
        Pij_0 = [j i];
        P = round(Pij_0 + [u1(i,j) v1(i,j)]);
        if (P(1)>0)&&(P(1) <N)&&(P(2)>0)&&(P(2) < M)
            Pij_1 = P + [u2(P(2),P(1)) v2(P(2),P(1))];
            if (norm(Pij_0 - Pij_1) <=occ_thr)
%                   Mask(i,j) = 0;
                Mask(i,j) = 1;
            end
        end
    end
end

    