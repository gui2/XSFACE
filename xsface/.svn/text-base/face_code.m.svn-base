% this script is for annotation of detector accuracy
% it's pretty ad-hoc but easy to modify

clear all
addpath('helper')
load mats/all_dets_27-Dec-2012.mat;

%% match file names to detectors
gold_files = {'XS_0401','XS_0801','XS_1201',...
  'XS_1602','XS_2001'};
gold_indices = {[1 1],[2 1],[3 1],[4 1],[5 1]};

%% set up figure
figure(1)
clf
cols = {[1 0 0],[0 1 0],[0 0 1],[1 1 0]};
set(gca,'Position',[0 0 1 1]);

annotation_amount = 30 * 60;  % annotate one minute

%% do annotation

ListenChar(2); % disable write to matlab

for f = 1:length(gold_indices)
  dets = all_dets{gold_indices{f}(1)}{gold_indices{f}(2)};
  i = 1;
  
  while i <= annotation_amount 
    im = imread(['videos/' gold_files{f} '/rot_image' num2str(i,'%05d') '.jpg']);
    imagesc(im)
    ims = imresize(im,[480 720]);
    imagesc(ims)

    for j = 1:4
      if ~any(isnan(dets(i,:,j)))
        rectangle('Position',dets(i,1:4,j),'EdgeColor',[1 0 0],'LineWidth',1);       
      end
    end
    
    axis off
    drawnow

    in_char = getCharInput;

    fprintf('%d face? ',i);
    if strcmp(in_char,' ') % space is yes, enter is no
      gold{f}(i) = 1;
      fprintf('yes')
    elseif strcmp(in_char,'z') % z is go back
      i = max(i - 2,1);
    else
      gold{f}(i) = 0;
    end
    fprintf('\n');
    
    i = i + 1;
  end
  
  save(['mats/xs_gold_dets_' datestr(now,1) '.mat'],'gold_files','gold_indices','gold');
end

ListenChar(0); % enable

