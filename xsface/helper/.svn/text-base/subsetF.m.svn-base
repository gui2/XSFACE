function [p, r, f] = subsetF(eval,gold,gold_frames)

subs = cellfun(@(x,y) cellfun(@(a,b) a(b), x, y, 'UniformOutput', false), ...
    eval, gold_frames, 'UniformOutput', false);

subs = horzcat(subs{:});
subs = vertcat(subs{:});

gold = horzcat(gold{:});
gold = vertcat(gold{:});

size(subs)
size(gold)

[p, r, f] = computeF(subs,gold);

end