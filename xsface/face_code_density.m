% this script is for annotation of detector accuracy
% it's pretty ad-hoc but easy to modify

clear all
addpath('helper')

load mats/LDT_dets_31-Jan-2013.mat;
LDT_dets = all_dets;

%fix discrepancy between two detectors
LDT_dets{4}{4} = LDT_dets{4}{4}(1:17558,:);

load mats/all_dets_31-Jan-2013.mat;
VJ_dets = all_dets;

FRAME_RATE = 22;
CONT_SECS = 1;
TOT_FRAMES = FRAME_RATE * CONT_SECS;
CODE_AMT = 60; %code 1 minute

%find whether a detector fired on each frame
detected_VJ = cellfun(@(x) cellfun(@(y) nansum(nansum(y(:,end,:),3),2) ,x,...
    'UniformOutput', false), VJ_dets,'UniformOutput',false);

detected_LDT = cellfun(@(x) cellfun(@(y) nansum(y(:,end),2) ,x,...
    'UniformOutput', false), LDT_dets,'UniformOutput',false);

%Now, compute density of detections in 5 sec windows (30*5=150 frames)
%The end-rem stuff deals with non-divisible video lenghts
density_VJ = cellfun(@(x) cellfun(@(y)  ...
    sum(reshape(y(1:(end-rem(length(y),TOT_FRAMES))),...
    TOT_FRAMES, (numel(y)-rem(length(y),TOT_FRAMES))/TOT_FRAMES),1), x, ...
    'UniformOutput', false), detected_VJ, 'UniformOutput', false);

[density_VJ,inds_VJ] = cellfun(@(x) cellfun(@(y) sort(y,'descend'), x, ...
    'UniformOutput',false), density_VJ, 'UniformOutput',false);

density_LDT = cellfun(@(x) cellfun(@(y)  ...
    sum(reshape(y(1:(end-rem(length(y),TOT_FRAMES))),...
    TOT_FRAMES, (numel(y)-rem(length(y),TOT_FRAMES))/TOT_FRAMES),1), x, ...
    'UniformOutput', false), detected_LDT, 'UniformOutput', false);

[density_LDT,inds_LDT] = cellfun(@(x) cellfun(@(y) sort(y,'descend'), x, ...
    'UniformOutput',false), density_LDT, 'UniformOutput',false);

inds_RAND = cellfun(@(x) cellfun(@(y) randperm(length(y)),x,...
   'UniformOutput',false), density_LDT, 'UniformOutput',false); 

%Compute number of segments to grab from each child
ps_per_age = cellfun(@length,density_VJ);
segs_per_age = floor(CODE_AMT./(CONT_SECS*ps_per_age));
segs_per_p = arrayfun(@(x,y) floor(x)*ones(1,y) + mod(floor(x),2), segs_per_age, ps_per_age,...
    'UniformOutput',false);

%deal with nondivisible edge case
nondiv = arrayfun(@(x) rem(CODE_AMT/CONT_SECS,x), ps_per_age);
add_segs = arrayfun(@(x,y) permute_array([ones(1,x) zeros(1,y-x)]), ...
    nondiv, ps_per_age, 'UniformOutput', false);
final_segs_per_p = cellfun(@(x,y) num2cell(x+y),segs_per_p,add_segs,...
    'UniformOutput',false);

%deal with overlap between best VJ and LDT detectors
code_segs_per_p_VJandLDT = cellfun(@(x,y,z) ...
    cellfun(@non_isect_frames, x, y, z, 'UniformOutput', false), ...
    inds_VJ, inds_LDT, final_segs_per_p,'UniformOutput', false);

%pick random segments for annotation/gold standard
rem_segs_per_p = cellfun(@(x,y) cellfun(@(a,b) ...
    setdiff(b,a,'stable'), x, y, 'UniformOutput', false), ...
    code_segs_per_p_VJandLDT, inds_RAND,'UniformOutput',false);

code_segs_per_p_RAND = cellfun(@(x,y) cellfun(@(a,b) permute_array(a(1:b)), ...
    x, y, 'UniformOutput', false), rem_segs_per_p, final_segs_per_p, ...
    'UniformOutput', false);


%pick half for annotation, half for gold
annotate_segs_per_p = cellfun(@(x,y) cellfun(@(a,b) ...
    [a(1:2:end) b(1:2:end)], x, y, 'UniformOutput', false), ...
    code_segs_per_p_VJandLDT, code_segs_per_p_RAND,'UniformOutput',false);

gold_segs_per_p = cellfun(@(x,y) cellfun(@(a,b) ...
    [a(2:2:end) b(2:2:end)], x, y, 'UniformOutput', false), ...
    code_segs_per_p_VJandLDT, code_segs_per_p_RAND,'UniformOutput',false);

%convert the segments back to frames
annotate_frames = cellfun(@(x) cellfun(@(y) arrayfun(@(z) ...
    (1+(FRAME_RATE*CONT_SECS*(z-1))):(FRAME_RATE*CONT_SECS*z), y, 'UniformOutput', false), x, ...
    'UniformOutput', false), annotate_segs_per_p, 'UniformOutput', false);
annotate_frames = cellfun(@(x) cellfun(@(y) horzcat(y{:})', x, 'UniformOutput', false), annotate_frames,...
    'UniformOutput',false);

gold_frames = cellfun(@(x) cellfun(@(y) arrayfun(@(z) ...
    (1+(FRAME_RATE*CONT_SECS*(z-1))):(FRAME_RATE*CONT_SECS*z), y, 'UniformOutput', false), x, ...
    'UniformOutput', false), gold_segs_per_p, 'UniformOutput', false);
gold_frames = cellfun(@(x) cellfun(@(y) horzcat(y{:})', x, 'UniformOutput', false), gold_frames,...
    'UniformOutput',false);

%re-arrange the files by age
p_files = arrayfun(@(x,y) files(x:y)', 1+[0 cumsum(ps_per_age(1:end-1))], ...
    cumsum(ps_per_age),'UniformOutput',false);

%% set up figure
figure(1)
clf
cols = {[1 0 0],[0 1 0],[0 0 1],[1 1 0]};
set(gca,'Position',[0 0 1 1]);

%% do annotation
%disp('ANNOTATIONS');
annotations = annotate_faces(all_dets,p_files,annotate_frames);
save(['mats/xs_VJ_annotation_dets_' datestr(now,1) '.mat'],'LDT_dets','VJ_dets','p_files','annotate_frames','annotations','annotate_segs_per_p');

% disp('GOLD');
% 
golds = annotate_faces(all_dets,p_files,gold_frames);
save(['mats/xs_gold_dets_' datestr(now,1) '.mat'],'LDT_dets','VJ_dets','p_files','gold_frames','golds','gold_segs_per_p');

