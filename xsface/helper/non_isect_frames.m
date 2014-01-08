function frames = non_isect_frames(frames1,frames2,num_frames)

frames = zeros(1,num_frames/2);

f1_i = 1;
f2_i = 1;
pick_arr = 1;
for num_chosen = 1:num_frames
    if pick_arr == 1
        while(sum(frames == frames1(f1_i)) > 0)
            f1_i = f1_i + 1;
        end
        frames(num_chosen) = frames1(f1_i);
        pick_arr = 2; 
    else
        while(sum(frames == frames2(f2_i)) > 0)
            f2_i = f2_i + 1;
        end
        frames(num_chosen) = frames2(f2_i);
        pick_arr = 1; 
    end
end

frames = frames(randperm(length(frames)));
end