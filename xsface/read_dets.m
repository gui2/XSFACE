% script that reads in detectors
% takes a huge long CSV file and breaks it up into a cell array of matrices
% by age: all_dets{age}{subject number}
clear all

%% load all data from CSV 
[file frame d1x d1y d1w d1h d1c d2x d2y d2w d2h d2c d3x d3y d3w d3h d3c d4x d4y d4w d4h d4c] = ...
      textread('data/detectors/sorted_2013_1_29.csv','%s%s%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d%d',...
      'delimiter',',','headerlines',1);

%% break up by age

files = unique(file);
a = 1;
c = 1;

ages = {'04','08','12','16','20'};
all_dets = {};

for f = 1:length(files)
  fprintf('%s\n',files{f});
  tf = strcmp(file,files{f}); 
  a = find(strcmp(files{f}(4:5),ages));
  
  if length(all_dets) >= a
    c = length(all_dets{a}) + 1;
  else    
    all_dets{a} = [];
    c = 1;
  end
  
  % convert to a manageable data structure
  for i = 1:4
    all_dets{a}{c}(:,:,i) = eval(['[d' num2str(i) 'x(tf) d' num2str(i) 'y(tf) d' num2str(i) 'w(tf) d' num2str(i) 'h(tf) d' num2str(i) 'c(tf)]']);
  end

  all_dets{a}{c}(all_dets{a}{c}==0) = NaN;  
end

save(['mats/all_dets_' datestr(now,1) '.mat'],'all_dets','files');