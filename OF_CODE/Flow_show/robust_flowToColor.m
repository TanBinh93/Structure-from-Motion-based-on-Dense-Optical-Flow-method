% extracted from the matlab code of TV-L1 [6] "A duality based approach for realtime TV-L1 optical flow"
function [ flowImg ] = robust_flowToColor( flow )

% find robust max flow for better visualization
M = size(flow, 1); N = size(flow, 2);
u = flow(:, :, 1);
v = flow(:, :, 2);
magnitude = (u.^2 + v.^2).^0.5;
max_flow = prctile(magnitude(:), 95);

tmp = zeros(M,N,2);
tmp(:,:,1) = min(max(u,-max_flow),max_flow);
tmp(:,:,2) = min(max(v,-max_flow),max_flow);

flowImg = uint8(flowToColor(tmp));

end

