% script to play back the detectors on a movie

clear all
load mats/all_dets_16-Sep-2012.mat;

%% basic playback loop

figure(1)
clf
cols = {[1 0 0],[0 1 0],[0 0 1],[1 1 0]};
set(gca,'Position',[0 0 1 1]);

% parameters of what to play back
a = 1;
f = 1;
dets = all_dets{a}{f};
i = 1;

  
for i = 1:length(all_dets{a}{f})
  im = imread(['videos/' files{f} '/rot_image' num2str(i,'%05d') '.jpg']);
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
end
  