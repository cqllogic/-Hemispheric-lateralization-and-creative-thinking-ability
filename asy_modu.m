function   [DM, SI] = asy_modu(lh_ts,rh_ts,m,thres)
% inputs 
% lh_ts: time series inclding all nodes in left side
% rh_ts: time series inclding all nodes in right side
% m: a list of networks with relevant nodes
% thres: weight treshold for the connectivity matrix ()

%outputs
%DM: degree of each modularity within and cross hemisphere
%SI: indices of each m 

% depend on Brain Connectivity Toolbox (https://sites.google.com/site/bctnet/)
% C.Q.L.
% 08/06/2018


for n =1:length(lh_ts);
    for k = 1:size(m,2)
    for i = 1:size(m{1,k},2)
        roiID = m{1,k}(1,i);
        ml_ts{n,k}(:,i)= lh_ts{n,1}(:,roiID);
        mr_ts{n,k}(:,i)= rh_ts{n,1}(:,roiID);
    end
    end
end
clear('n','k','roiID')
%% Analysis of degree with each modu for each hemi
k = size(ml_ts,2);
subsize = size(ml_ts,1);

for n = 1 : subsize
    for moduID = 1 : k 
        CM_LL = corr(ml_ts{n,moduID});CM_LL(1:size(CM_LL,1)+1:end)=0;   
        CM_LL_thresz = threshold_absolute(fisherz(CM_LL),thres);
        DoM_LL(n,moduID) = sum(nansum(CM_LL_thresz))/2;

        CM_LR= corr(ml_ts{n,moduID},mr_ts{n,moduID});
        CM_LR_thresz = threshold_absolute(fisherz(CM_LR),thres);
        DoM_LR(n,moduID) = sum(nansum(triu(CM_LR_thresz)));
    
        CM_RR =corr(mr_ts{n,moduID});CM_RR(1:size(CM_RR,2)+1:end)=0;   
        CM_RR_thresz = threshold_absolute(fisherz(CM_RR),thres);
        DoM_RR(n,moduID) = sum(nansum(CM_RR_thresz))/2;
        
        CM_RL = corr(mr_ts{n,moduID},ml_ts{n,moduID});
        CM_RL_thresz = threshold_absolute(fisherz(CM_RL),thres);
        DoM_RL(n,moduID) = sum(nansum(triu(CM_RL_thresz)));
    end
end

DM = {DoM_LL DoM_LR DoM_RR DoM_RL};
LS = DoM_LL - DoM_LR;
RS = DoM_RR - DoM_RL;
LI = DoM_LL + DoM_LR;
RI = DoM_RR + DoM_RL;
AST_I = (DoM_LL+DoM_LR) - (DoM_RR+DoM_RL);
AST_S = (DoM_LL-DoM_LR) - (DoM_RR-DoM_RL);
ASY = (DoM_LL-DoM_RR)./(DoM_LL+DoM_RR);
typ_AST_I = ((DoM_LL+DoM_LR) - (DoM_RR+DoM_RL))./((DoM_LL+DoM_LR) + (DoM_RR+DoM_RL));
typ_AST_S = ((DoM_LL-DoM_LR) - (DoM_RR-DoM_RL))./(((DoM_LL-DoM_LR) +(DoM_RR-DoM_RL)));
SI ={LS RS LI RI AST_I AST_S ASY typ_AST_I typ_AST_S};

  
  
 