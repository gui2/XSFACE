%% figure showing detections for various frames
% just worth while for exploring

clear all
load mats/all_dets_23-Jan-2013.mat
load mats/preds_xs_annotations_23-Jan-2013.mat
load mats/xs_gold_dets_23-Jan-2013.mat
load mats/final_dets_and_annotations.mat

%% winner figure

clf
gold_files = {'XS_0401','XS_0801','XS_1201',...
  'XS_1602','XS_2008'};
gold_indices = {[1 1],[2 1],[3 1],[4 1],[5 1]};
pos = {[1 2],[3 4],[5 6],[8 9],[10 11]};
frame = [59 1 197 101 137]; % which frames shall we show?
titles = {'4 months','8 months','12 months','16 months','20 months'};

for c = 1:5
 
  a = gold_indices{c}(1);
  f = gold_indices{c}(2);
  
  p = preds{a}{f};
  
  
  i = find(p==1);
  
  i = i(frame(c)); % find the frame with a positive detection

  im = imread(['video_frames/' gold_files{c} '_objs/frame_' num2str(i,'%05d') '.jpg']);

  if size(im,2) ~= 720
    im = imresize(im,[480 720]);
  end    

  subplot(2,6,pos{c});  
  imagesc(im)

  
  rectangle('Position',final_dets{a}{f}(i,1:4),'EdgeColor',[0 1 0],'LineWidth',3);
  
  
  title(titles{c},'FontSize',16);
  axis off
  c = c + 1;  
end

