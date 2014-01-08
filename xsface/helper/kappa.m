function [k, pr_a, pr_e] = kappa(list1,list2)

%initial formats are cell arrays of cell arrays. Flatten down.
%vector
list1 = horzcat(list1{:});
list1 = vertcat(list1{:});

list2 = horzcat(list2{:});
list2 = vertcat(list2{:});

%remove frames where we had disk error issues
list1(list1 > 1) = NaN;
list2(list2 > 1) = NaN;

%compute probability of agreement
pr_a = nanmean(list1 == list2);

%compute probability of chance agreement
pr_e = nanmean(list1)*nanmean(list2) + ...
    (1-nanmean(list1))*(1-nanmean(list2));

k = (pr_a - pr_e)/(1-pr_e);
end