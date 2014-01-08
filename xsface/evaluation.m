clear all
load mats/GUIDO-FACE-xs_gold_dets_15-Nov-2013.mat
facesgold = golds;

clear golds;
load mats/GUIDO-FACE-true-positives-xs_gold_dets_17-Nov-2013.mat
truepositivesgold = golds; 

more= length (facesgold) ;
total =0; 
fn =0;
tn = 0;
tp =0;
fp =0;

for i = 1 : length (facesgold) ;
    fuck1= length (facesgold{1,i});
    for q =1: fuck1;
       % access to each one of the annotations 
        % facesgold{1,i}{1,q} ;
         fuck2=  length (facesgold{1,i}{1,q})
          
         for s =1: fuck2;
               facesdet=  facesgold{1,i}{1,q};
               fd= facesdet(s,1);
              
               trueposdet=  truepositivesgold{1,i}{1,fuck1};
               td= trueposdet(s,1);
               
              if  (fd>1) 
                   disp (['bad frame' num2str(s)]); 
               end; 
              % count  false negatives = facedet - truepos 
           
               if  ( fd ==1  &  1==td  )
                     tp = tp +1; % true positive 
               end
               
                if  ( fd ==0 & td ==0)
                   tn = tn+1; % true negative
                end
                
                if  ( fd ==0 & td ==1)
                    fn = fn+1; % false negative 
                end
               
                if  ( fd ==1 & td ==0)
                   fp = fp+1; % false positive 
                 end
                
               total = total +1;
           end;
    end
end

disp(sprintf (' true positive %d\n', tp));
disp(sprintf (' false positive  %i \n', fp));
disp(sprintf (' true  negative %i \n', tn));
disp(sprintf (' false  negative %i \n', fn));

precision= tp / (tp+fp);
recall= tp / (tp+fn);
TNR= tn/(tn+fp);
Accuracy = (tp+tn)/(tp+tn+fp+fn);

disp(sprintf (' precision %i \n', precision));
disp(sprintf (' recall %i \n', recall));
disp(sprintf (' True-Negative-Rate %i \n', TNR));
disp(sprintf ('Accuracy %i \n', Accuracy));
