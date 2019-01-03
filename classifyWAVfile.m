

addpath(genpath(pwd)); %add current path and subfolders
filename = 'drums1.wav';
windowlength = 1;
window_overlap= 0;
load('TrainedModel10.mat', 'trainedModel10');

[demofile, fs] = audioread(filename);
demofile = sum(demofile, 2) / size(demofile, 2);

ax1 = subplot(3,1,1);
plot(demofile); %plot part of audiofile

filefeatures = extractFeaturesFile(filename,windowlength,window_overlap);
yfit = trainedModel10.predictFcn(filefeatures);

unique_labels= unique(yfit);
n=numel(unique_labels);
cmap= colormap(lines(2));

% keySet = 1:1:n
% valueSet = unique_labels
% labelMap = containers.Map(keySet,valueSet);
labelMap = containers.Map('KeyType','int32','ValueType','char');
keySet = {1, 2};
valueSet = {'Drums','Guitar'};
labelMap = containers.Map(keySet,valueSet);


n_predicts=numel(yfit);
current_y = ones(fs,1);
 

ax2 = subplot(2,1,2);
for ij= 1:n_predicts  %iterate through every window, overlap? ->draw over and over each iteration
   
    current_y2 = demofile((ij-1)*fs+1:ij*fs);
    color_id=0;
    keys=labelMap.keys;
    for j = 1:numel(labelMap.keys)
    key = keys{j};
        if strcmp(labelMap(key), yfit(ij))
            color_id=j;
        end
    end
 
 current_x = (ij-1)*fs+1:1:ij*fs;
 
 stretch=1; %samplerate and windowlength modify this factor

 ax2=subplot(3,1,2);
 plot(current_x*stretch,current_y2,'Color',cmap(color_id ,:),'LineWidth',2);
 hold on

end

ax3=subplot(3,1,3);



linkaxes([ax1,ax2],'x');



for ij= 1:n_predicts  %iterate through every window, overlap? ->draw over and over each iteration
   
    color_id=0;
    keys=labelMap.keys;
    for j = 1:numel(labelMap.keys)
    key = keys{j};
        if strcmp(labelMap(key), yfit(ij))
            color_id=j;
        end
    end 
 current_x = (ij-1)*fs+1:1:ij*fs;
 plot(current_x*stretch,current_y*(1+color_id/n/4),'Color',cmap(color_id ,:),'LineWidth',10);
  
 hold on

end
 ylim([0.5 2])
p1=plot(1,1,'Color',cmap(1 ,:),'LineWidth',10);
hold on
p2=plot(1,1,'Color',cmap(2 ,:),'LineWidth',10);
hold off
legend([p1 p2],{'DRUMS','GUITAR'},'Location','north','NumColumns',2)

