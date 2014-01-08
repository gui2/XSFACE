% this script is for annotation of detector accuracy
% it's pretty ad-hoc but easy to modify

%clear all
addpath('helper')

load mats/LDT_dets_11-Nov-2013.mat;
LDT_dets = all_dets;

% %fix discrepancy between two detectors
% LDT_dets{4}{4} = LDT_dets{4}{4}(1:17558,:);

FRAME_RATE = 30;
CONT_SECS = 1;
TOT_FRAMES = FRAME_RATE * CONT_SECS;
CODE_AMT = 60; %code 1 minute

detected_LDT = cellfun(@(x) cellfun(@(y) nansum(y(:,end),2) ,x,...
    'UniformOutput', false), LDT_dets,'UniformOutput',false);

density_LDT = cellfun(@(x) cellfun(@(y)  ...
    sum(reshape(y(1:(end-rem(length(y),TOT_FRAMES))),...
    TOT_FRAMES, (numel(y)-rem(length(y),TOT_FRAMES))/TOT_FRAMES),1), x, ...
    'UniformOutput', false), detected_LDT, 'UniformOutput', false);

[density_LDT,inds_LDT] = cellfun(@(x) cellfun(@(y) sort(y,'descend'), x, ...
    'UniformOutput',false), density_LDT, 'UniformOutput',false);

inds_RAND = cellfun(@(x) cellfun(@(y) randperm(length(y)),x,...
   'UniformOutput',false), density_LDT, 'UniformOutput',false); 

%Compute number of segments to grab from each child
ps_per_age = cellfun(@length,density_LDT);
segs_per_age = floor(CODE_AMT./(CONT_SECS*ps_per_age));
segs_per_p = arrayfun(@(x,y) floor(x)*ones(1,y) + mod(floor(x),2), segs_per_age, ps_per_age,...
    'UniformOutput',false);

%deal with nondivisible edge case
nondiv = arrayfun(@(x) rem(CODE_AMT/CONT_SECS,x), ps_per_age);
add_segs = arrayfun(@(x,y) permute_array([ones(1,x) zeros(1,y-x)]), ...
    nondiv, ps_per_age, 'UniformOutput', false);
final_segs_per_p = cellfun(@(x,y) num2cell(x+y),segs_per_p,add_segs,...
    'UniformOutput',false);

%grab top-detection frames for LDT
code_segs_per_p_LDT = cellfun(@(x,y) cellfun(@(a,b) permute_array(a(1:b)), ...
    x, y, 'UniformOutput', false), inds_LDT, final_segs_per_p, ...
    'UniformOutput', false);

%pick random segments for annotation/gold standard
rem_segs_per_p = cellfun(@(x,y) cellfun(@(a,b) ...
    setdiff(b,a,'stable'), x, y, 'UniformOutput', false), ...
    code_segs_per_p_LDT, inds_RAND,'UniformOutput',false);

code_segs_per_p_RAND = cellfun(@(x,y) cellfun(@(a,b) permute_array(a(1:b)), ...
    x, y, 'UniformOutput', false), rem_segs_per_p, final_segs_per_p, ...
    'UniformOutput', false);

%combine segments together for gold coding
gold_segs_per_p = cellfun(@(x,y) cellfun(@(a,b) ...
    [a b], x, y, 'UniformOutput', false), ...
    code_segs_per_p_LDT, code_segs_per_p_RAND,'UniformOutput',false);

%convert the segments back to frames
gold_frames = cellfun(@(x) cellfun(@(y) arrayfun(@(z) ...
    (1+(FRAME_RATE*CONT_SECS*(z-1))):(FRAME_RATE*CONT_SECS*z), y, 'UniformOutput', false), x, ...
    'UniformOutput', false), gold_segs_per_p, 'UniformOutput', false);
gold_frames = cellfun(@(x) cellfun(@(y) horzcat(y{:})', x, 'UniformOutput', false), gold_frames,...
    'UniformOutput',false);

%re-arrange the files by age
    p_files = arrayfun(@(x,y) files(x:y)', 1+[0 cumsum(ps_per_age(1:end-1))], ...
    cumsum(ps_per_age),'UniformOutput',false);

% set up figure
figure(1)
clf
cols = {[1 0 0],[0 1 0],[0 0 1],[1 1 0]};
set(gca,'Position',[0 0 1 1]);

%% do annotation
disp('GOLD');
% 
golds = annotate_gold_preds(LDT_dets,p_files,gold_frames);
`

