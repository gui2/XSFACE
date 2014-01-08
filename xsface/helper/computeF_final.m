% Computes Final F score for the detectors given the hmm-trained output,
% gold yes/no data for a subset of the corpus, and manually coded
% true/false positives for detector output
function [p, r, f] = computeF_final(eval,gold,true_pos,gold_frames)


subs = cellfun(@(x,y) cellfun(@(a,b) a(b,:), x, y, 'UniformOutput', false), ...
    eval, gold_frames, 'UniformOutput', false);

subs = horzcat(subs{:});

% 
% %Deal with mother/father detectors
% for i = 1:length(subs)
%     if size(subs{i},2) > 6
%         subs{i} = nanmax(subs{i}(:,1:6), subs{i}(:,7:12));
%     end
% end

subs = vertcat(subs{:});
subs = ~isnan(sum(subs,2));

gold = horzcat(gold{:});
gold = vertcat(gold{:});

true_pos = horzcat(true_pos{:});
true_pos = vertcat(true_pos{:});

% %drop frames where there was an error
% keep_frames = (gold <= 1 & true_pos <= 1);
% subs = subs(keep_frames);
% gold = gold(keep_frames);

hits = subs == 1 & true_pos == 1;
misses = gold == 1 & true_pos == 0;
fas = subs == 1 & true_pos == 0;

p(1) = sum(hits(1:length(hits)/2)) / (sum(hits(1:length(hits)/2)) + sum(fas(1:length(fas)/2)));
r(1) = sum(hits(1:length(hits)/2)) / (sum(hits(1:length(hits)/2)) + sum(misses(1:length(misses)/2)));
f(1) = harmmean([p(1) r(1)]);
 
p(2) = sum(hits(((length(hits)/2+1):end))) / (sum(hits(((length(hits)/2+1):end))) + sum(fas(((length(fas)/2+1):end))));
r(2) = sum(hits(((length(hits)/2+1):end))) / (sum(hits(((length(hits)/2+1):end))) + sum(misses(((length(misses)/2+1):end))));
f(2) = harmmean([p(2) r(2)]);