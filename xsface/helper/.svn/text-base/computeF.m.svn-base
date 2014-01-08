function [p r f] = computeF(eval,gold,true_pos)

hits = gold == 1 & eval == 1;
misses = gold == 1 & eval == 0;
fas = gold == 0 & eval == 1;
p = sum(hits) / (sum(hits) + sum(fas));
r = sum(hits) / (sum(hits) + sum(misses));
f = harmmean([p r]);
 