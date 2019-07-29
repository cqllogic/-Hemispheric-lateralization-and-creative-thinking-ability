function    [lh_ts,rh_ts] = split_ts(timeSdata)
% seprate ts data to two hemi(right,left)
% data is a cell includes all timeseries of ROIs for each sub
% check the label of nodes for lh or rh 
lh_ts = cell(length(timeSdata),1);
rh_ts = cell(length(timeSdata),1);

nodesize = size(timeSdata{1,1},2)

for i = 1:length(timeSdata)
    rh_ts{i,1} = timeSdata{i,1}(:,1:nodesize/2);
    lh_ts{i,1} = timeSdata{i,1}(:,nodesize/2+1:nodesize);
end
