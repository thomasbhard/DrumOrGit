load('TrainedModel10.mat', 'trainedModel10');

fs = 44100; %samplerate for new recording
threshold = 5e-04;


%setup audiorecorder
recObj = audiorecorder(fs, 16, 2);

signal = [0,0];

%record 1 second of audio and classify it
while 1
    recordblocking(recObj, 1); % records one second
    
    % Store data in double-precision array.
    curr_signal = getaudiodata(recObj);
    % add to signal
    signal = [signal; curr_signal];
    % mono signal for plot
    signal_mono = sum(signal,2) / size(signal,2);
    
    % Plot signal
    ax1 = plot((signal_mono - mean(signal_mono))/std(signal_mono));
    axis tight
    ylim([-10 10])
    xticks([])
    yticks([])
    
    %check if signal is above treshhold
    curr_signal_mono = sum(curr_signal, 2) / size(curr_signal, 2);
    level = rms(curr_signal_mono);
    
    if level > threshold
        newfeatures = extractFeaturesSignal(curr_signal, fs, 1, 0); %extract features from recording
        yfit = trainedModel10.predictFcn(newfeatures);

        disp([yfit{1,1}]) %show first entry (window length = 1sec --> 1 result/recording)

        title(yfit{1,1})
    else
        title('Level too low')
    end
end