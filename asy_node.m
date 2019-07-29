function  [DH,SI] = asy_node(lh_ts,rh_ts,thres)
% inputs 
% lh_ts: time series inclding all nodes in left side
% rh_ts: time series inclding all nodes in right side
% thres: weight treshold for the connectivity matrix ()

%outputs
%DH: degree of each node within and cross hemisphere
%SI: indices of each node 

% depend on Brain Connectivity Toolbox (https://sites.google.com/site/bctnet/)
% C.Q.L.
% 08/06/2018

ns = size(lh_ts{1,1},2);  

for n = 1:length(lh_ts)
    % degree of node within left hemisphere
    CM_LL = corr(lh_ts{n,1});CM_LL(1:ns+1:end)=0;   
    CM_LL = threshold_absolute(fisherz(CM_LL),thres);
    ALLsub_LL(n,:) = nansum(CM_LL);
    % LR >> degree of node corss hemisphere
    CM_LR = corr(lh_ts{n,1},rh_ts{n,1});
    CM_LR = threshold_absolute(fisherz(CM_LR),thres);
    ALLsub_LR(n,:) = nansum(CM_LR');
    % RR >> degree of node within right hemisphere
    CM_RR = corr(rh_ts{n,1});CM_RR(1:ns+1:end)=0;   
    CM_RR = threshold_absolute(fisherz(CM_RR),thres);
    ALLsub_RR(n,:) = nansum(CM_RR);
    % LR >> degree of node corss hemisphere
    CM_RL = corr(rh_ts{n,1},lh_ts{n,1}); 
    CM_RL = threshold_absolute(fisherz(CM_RL),thres);
    ALLsub_RL(n,:) = nansum(CM_RL'); 
end

    DH = {ALLsub_LL,ALLsub_LR,ALLsub_RR,ALLsub_RL};
    
    Left_Seg = ALLsub_LL - ALLsub_LR;
    Right_Seg = ALLsub_RR - ALLsub_RL;
    Left_Int = ALLsub_LL + ALLsub_LR;
    Right_Int = ALLsub_RR + ALLsub_RL;
    ASY_Int = (ALLsub_LL+ALLsub_LR) - (ALLsub_RR+ALLsub_RL);
    ASY_Seg = (ALLsub_LL-ALLsub_LR) - (ALLsub_RR-ALLsub_RL);   
    ASY =  (ALLsub_LL - ALLsub_RR)./(ALLsub_LL + ALLsub_RR);
    typ_ASY_Int = ((ALLsub_LL+ALLsub_LR) - (ALLsub_RR+ALLsub_RL))./((ALLsub_LL+ALLsub_LR) + (ALLsub_RR+ALLsub_RL));
    typ_ASY_Seg = ((ALLsub_LL-ALLsub_LR) - (ALLsub_RR-ALLsub_RL))./((ALLsub_LL-ALLsub_LR) + (ALLsub_RR-ALLsub_RL));  
    SI = {Left_Seg Right_Seg Left_Int Right_Int ASY_Seg ASY_Int ASY typ_ASY_Int typ_ASY_Seg};
