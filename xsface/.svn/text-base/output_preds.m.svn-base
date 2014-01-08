clear all
load mats/preds_xs_VJ_annotations_31-Jan-2013.mat
load mats/xs_VJ_annotation_dets_31-Jan-2013.mat

%% output
files = p_files;

frame_size = [720 480];
total_pixels = prod(frame_size);
frames_per_day = 24*60*60*30; % hours * minutes * seconds * frames/sec

ages = {'4','8','12','16','20'};

fid = fopen('data/face_presence_VJ.csv','w');
fprintf(fid,'subid,age.grp,frame,face\n');

final_dets = cell(size(VJ_dets));

for a = 1:length(ages)
    disp(strcat('---', ages(a)))
    for c = 1:length(preds{a})
        disp(c)
        areas = arrayfun(@(j) VJ_dets{a}{c}(:,3,j) .* ...
            VJ_dets{a}{c}(:,4,j), 1:4, 'UniformOutput',false);
        areas = horzcat(areas{:});
        [~,max_j] = nanmax(areas,[],2);
      
      %  sizes = zeros(size(VJ_dets{a}{c}));
      %  xcenters = zeros(size(VJ_dets{a}{c}));
      %  ycenters = zeros(size(VJ_dets{a}{c}));
        
        final_dets{a}{c} = zeros(size(VJ_dets{a}{c},1),...
            size(VJ_dets{a}{c},2));
        
        for frame = 1:length(VJ_dets{a}{c})
            mpos = VJ_dets{a}{c}(frame,:,max_j(frame));
        
            final_dets{a}{c}(frame,:) = ...
                VJ_dets{a}{c}(frame,:,max_j(frame));
            
       %     sizes(frame) = mpos(3) * mpos(4) / total_pixels;
       %     xcenters(frame) = (mpos(1) + mpos(3)/2) /frame_size(1); 
       %     ycenters(frame) = (mpos(2) + mpos(4)/2) ./frame_size(2); 
        end

        % NaN out un-predicted (spurious?) faces
     %   sizes(~preds{a}{c}) = NaN;
     %   xcenters(~preds{a}{c}) = NaN;
     %   ycenters(~preds{a}{c}) = NaN;

        final_dets{a}{c}(~preds{a}{c},:) = NaN;
        
        % now output
        for d = 1:length(preds{a}{c})
          fprintf(fid,'%s,%d,%s,%d\n',....
            p_files{a}{c},a,num2str(d),preds{a}{c}(d));
        end    
    end
end

fclose(fid);
save(['mats/xs_hmm_dets_' datestr(now,1) '.mat'],'final_dets');