%% train HMM on the dataset and decode 
% very simple, just uses gold standard

clear all
addpath('helper')

load mats/xs_VJ_annotation_dets_31-Jan-2013.mat


%% train HMM
%frames = 1:5400; % this is hard coded as the amount being annotated, FIXME
Y = [];
X = [];

for a = 1:length(p_files);
    for p = 1:length(p_files{a})
        frames = annotate_frames{a}{p};
        
        X = [X sum(squeeze(~isnan(VJ_dets{a}{p}(frames,1,:))),2)' + 1];
        Y = [Y; annotations{a}{p}+1];
    end
end

% 
% for c = 1:length(gold_indices)
%   a = gold_indices{c}(1);
%   f = gold_indices{c}(2);
%   
%   X = [X sum(squeeze(~isnan(VJ_dets{a}{f}(frames,1,:))),2)' + 1];
%   Y = [Y gold{c}+1];
% end

% estimate the HMM and decode
[trans_est, emit_est] = hmmestimate(X,Y);
pstates = hmmdecode(X,trans_est,emit_est);
 
% consider various thresholds for decoding and optimize this parameter
for i = 1:99
  tpreds = pstates(1,:) < i/100;
  [p(i) r(i) f(i)] = computeF(tpreds(1:length(Y))',Y);
end

threshold = find(f==max(f))/100;

%% load HMM parameters and run HMM on each file
% load mats/wesse_hmm_params.mat

ages = {'4mo','8mo','12mo','16mo','20mo'};

% for each file, go through and decode for that file
for a = 1:length(VJ_dets)
  disp(ages{a})

  for p = 1:length(VJ_dets{a})    
    Xhmm = sum(squeeze(~isnan(VJ_dets{a}{p}(:,1,:))),2)'+1; 
  
    % decode hmm
    pstates = hmmdecode(Xhmm,trans_est,emit_est);
    preds{a}{p} = pstates(1,:)' < threshold;
  end
end

%% save predictions

save(['mats/preds_xs_VJ_annotations_' datestr(now,1) '.mat'],'preds');