%% a variety of basic analyses for the XS FACE experiment
% requires the detectors and also the predictions of the HMM model
% (or whatever other model)

clear all
load mats/all_dets_16-Sep-2012.mat
load mats/preds_xsgold_16-Sep-2012.mat

%% analyze data

ages = {'04','08','12','16','20'};

means = nan(15,length(ages));
means_all = nan(15,length(ages));

% loop through and get the proportion face detections.
for a = 1:length(preds)
  for f = 1:length(preds{a})
    means(f,a) = mean(preds{a}{f});
    means_all(f,a) = mean(sum(sum(~isnan(all_dets{a}{f}),2)/5,3)/4);
  end
end

% plot these
figure(1)
x_ages = repmat(4:4:20,15,1);
jit = rand(size(x_ages))*.2;

% filtered detections
subplot(2,1,1)
plot(x_ages+jit,means,'.')
axis([3 21 0 .2])
title('model filtered detections')
xlabel('age')
ylabel('face proportion')

% unfiltered detections
subplot(2,1,2)
plot(x_ages+jit,means_all,'.')
axis([3 21 0 .2])
title('all detections')
xlabel('age')
ylabel('face proportion')

%% gather the faces
% this plot is like the Frank (2012) paper, heatmaps of detections

screen_size = [720 480];

means = NaN(15,length(ages));
c =1;
for a = 1:length(preds)
  disp(ages{a})

  for f = 1:length(preds{a}) 
    disp(['    ' files{c}])
    screen{a}{f} = zeros(screen_size);
    means(f,a) = mean(preds{a}{f});
    
    for i = 1:length(all_dets{a}{f})
      for j = 1:4
        if ~any(isnan(all_dets{a}{f}(i,:,j))) && preds{a}{f}(i);
          d = all_dets{a}{f}(i,:,j);
          screen{a}{f}(d(1):d(1)+d(3),d(2):d(2)+d(4)) = screen{a}{f}(d(1):d(1)+d(3),d(2):d(2)+d(4)) + 1;
        end
      end
    end
    
    screen{a}{f} = screen{a}{f};
    c = c+1;
  end
end

% now average these into single age frames
for a = 1:length(ages)
  disp(ages{a});
  screens{a} = zeros(screen_size);
  for f = 1:length(preds{a})
%     disp(['   file ' files{a}{f}])
    if ~isnan(screen{a}{f}(1,1))
      screens{a} = screens{a} + screen{a}{f}/length(preds{a}{f}); 
    else
      disp(['       ' num2str(a) ':' num2str(f) ' is NaN'])
    end
  end
end

%% plot the heatmaps

figure(2)
clf
for i = 1:length(ages)
  subplot(1,length(ages),i)
  imagesc(screens{i}')
  axis off
  max_pt(i) = find(mean(screens{i}',2)==max(mean(screens{i}',2)));
  line([0 720],[max_pt(i) max_pt(i)],'Color',[1 1 1],'LineStyle','--','LineWidth',3)
end

max_pt = (screen_size(2) -max_pt) ./ screen_size(2);

%% find all face detector sizes

mean_size = NaN(20,5);
msize = prod(screen_size);
sizes = {};

for a = 1:5
  disp(ages{a})
  sizes{a} = {};
  
  for f = 1:length(preds{a}) 
%     disp(['    ' files{f}])
    sizes{a}{f} = [];
    sizes{a}{f} = NaN(size(all_dets{a}{f},1),4);
        
    for i = 1:length(all_dets{a}{f})
      for j = 1:4
        if ~any(isnan(all_dets{a}{f}(i,:,j))) && preds{a}{f}(i);
          d = all_dets{a}{f}(i,:,j);
          sizes{a}{f}(i,j) = prod(d(3:4)) / msize; 
        end
      end
    end
    
    mean_size(f,a) = nanmean(nanmean(sizes{a}{f}));
  end
end

%% aggregate and plot sizes
% this figure has some binning and can be a little unreliable, not sure how
% to do this best.

for a = 1:5
  disp(ages{a})
  all_sizes{a} = [];
  
  for f = 1:length(preds{a}) 
%     disp(['    ' files{a}{f}])
    
    all_sizes{a} = [all_sizes{a}; sizes{a}{f}];
  end
end

figure(3)

clear n
bins = [-8:1:0];

for a = 1:5
  xs = log(reshape(all_sizes{a},numel(all_sizes{a}),1));
  n(a,:) = hist(xs,bins);
  mean_sizes(a) = nanmean(xs);
end

n = n ./ repmat(sum(n,2),1,size(n,2));

clf
set(gca,'FontSize',16)
hold on
col = {'r','g','b','c','m'};
for a = 1:3
  plot(bins,n(a,:),[col{a} '.'])
end

cols = {[1 0 0],[0 1 0],[0 0 1],[0 1 1],[1 0 1]};
for a = 1:5
  line([mean_sizes(a) mean_sizes(a)],[0 1],'Color',cols{a},'LineStyle','--');
  h(a) = plot(bins,smooth(bins,n(a,:),.3,'loess'),[col{a}]);
end

legend(h,{'4 months','8 month','12 months','16 months','20 months'})

ticks = [-7:2:-1];
% axis([min(ticks)-.3 max(ticks)+.3 0 .075])

set(gca,'XTick',ticks,'XTickLabel',round(exp(ticks)*1000)/1000)
set(gca,'YTick',[0:.025:.075])
xlabel('Percentage of visual field (log scale)')
ylabel('Porportion of faces')




