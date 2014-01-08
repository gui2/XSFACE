clear all;
close all;
load mats/GUIDO-FACE-true-positives-xs_gold_dets_17-Nov-2013.mat;
load mats/GUIDO-FACE-xs_gold_dets_15-Nov-2013.mat;

final_dets = gold_frames;
figure (1);
for age = 1:length(final_dets)
    for p = 1:length(final_dets{age})
      frames = final_dets{age}{p};
     % frames = annotate_frames{1,age};
      file = p_files{age}{p};
      [pathstr,name,ext] = fileparts(file);
     file= name; 
 
     i = 1;
        while i <= length(frames)
            try   
            im = imread(['/Volumes/My Passport/Baby-Cam/headcam-cropped-frames-with-tld/XS_' file  '_objs.mov/' ...
            num2str(frames(i),'%05d') '.png']);
            imshow (im);
            disp ('opened');
            catch
            i=i+1;    
            disp ('not good');
            continue;
            end;
            
        end;
    end;
end;