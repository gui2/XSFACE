%annotates final, hmm trained output. Want to label the true vs. false
%postiives
function annotations = annotate_gold_preds(final_dets,p_files,annotate_frames)

annotations = annotate_frames;

ListenChar(2); % disable write to matlab

for age = 1:length(final_dets)
    for p = 1:length(final_dets{age})
      dets = final_dets{age}{p};
      frames = annotate_frames{age}{p};
      file = p_files{age}{p};
      [pathstr,name,ext] = fileparts(file);
     file= name; 
     i = 1;
        
        while i <= length(frames)
            try   
            im = imread(['headcam-cropped-frames-with-tld/XS_' file  '_objs.mov/' ...
            num2str(frames(i),'%05d') '.png']);
            catch
            i=i+1;    
            disp ('not good');
            continue;
            end
             
            %disp (im);  
            % im = flipdim(im,2);
            
            % for LDT
            imagesc(ims);     
            ims = imresize(im,[480 720]);
            imagesc(ims);

            %for LDT
            if ~any(isnan(dets(frames(i),2:end,1)))
                rectangle('Position',dets(frames(i),2:5,1),...
                    'EdgeColor', [1 0 0],'LineWidth',1);       
            end
            if size(dets,3) > 1
                 if ~any(isnan(dets(frames(i),2:end,2)))
                    rectangle('Position',dets(frames(i),2:5,2),...
                    'EdgeColor', [0 1 0],'LineWidth',1);  
                 end
            end
       
%             %for VJ
%             if ~any(isnan(dets(frames(i),:)))
%                 rectangle('Position',dets(frames(i),1:4),...
%                     'EdgeColor', [1 0 0],'LineWidth',1);       
%             end
                      
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

%save(['mats/xs_VJ_gold_annotations_' datestr(now,1) '.mat'],'annotations');
save(['mats/xs_LDT_gold_annotations_' datestr(now,1) '.mat'],'annotations');

ListenChar(0); % enable