function annotations = annotate_faces(all_dets,p_files,annotate_frames)

annotations = annotate_frames;

ListenChar(2); % disable write to matlab

for age = 1:length(p_files)
    for p = 1:length(p_files{age})
        dets = all_dets{age}{p};
        frames = annotate_frames{age}{p};
        file = p_files{age}{p}(1:4);
        
        i = 1;
        
        while i <= length(frames)
            im = imread(['headcam-cropped-frames/XS_' file '_objs/' ...
                num2str(frames(i),'%06d') '.jpg']);
            imagesc(im)
            ims = imresize(im,[480 720]);
            imwrite(imgMirror,sprintf([directoryout name]));
            imagesc(ims)

            
            %% old code - show all detectors
%             for j = 1:4
%               if ~any(isnan(dets(frames(i),:,j)))
%                 rectangle('Position',dets(frames(i),1:4,j),'EdgeColor',...
%                     [1 0 0],'LineWidth',1);       
%               end
%             end

            %% new code - show biggest detector
            areas = arrayfun(@(j) dets(frames(i),3,j) * ...
                dets(frames(i),4,j), 1:4);
            [~,max_j] = nanmax(areas);
            
            if ~any(isnan(dets(frames(i),:,max_j)))
                rectangle('Position',dets(frames(i),1:4,max_j),...
                    'EdgeColor', [1 0 0],'LineWidth',1);       
            end
                      
            axis off
            drawnow

            in_char = getCharInput;

            fprintf('%s\t%d\tface? ',file,frames(i));
            if strcmp(in_char,' ') % space is yes, enter is no
              annotations{age}{p}(i) = 1;
              fprintf('yes')
            elseif strcmp(in_char,'z') % z is go back
              i = max(i - 2,0);
            else
              annotations{age}{p}(i) = 0;
            end
            fprintf('\n');

            i = i + 1;
        end
    end
    
    if ~exist('tmp','dir')
        mkdir('tmp/');
    end
    save(['tmp/xs_annotation_dets_' datestr(now,1) '_' num2str(age) '.mat'],'annotations');
end

ListenChar(0); % enable