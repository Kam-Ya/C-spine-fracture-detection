
% Read data labels from csv file
csv = "labels.csv";
labels = readtable(csv);

% get images from file and make folds
rng(0, "twister") % for reproducability 
file = "images/real";
contents = fullfile(file);

disp(contents);

% work on the model
fractures = labels.fracture;
imds = imageDatastore(contents, 'includeSubFolders', true, 'LabelSource', 'folderNames');

images = numel(imds.Files);

disp(images)

k = 10;

indices = randperm(images);
perFold = floor(images / k );
options = trainingOptions('sgdm', 'InitialLearnRate', 1e-3, 'MaxEpochs', 10,'CheckpointPath', tempdir);

layers1 = fasterRCNNLayers([555 555 3], 1, [1 1], "resnet50", "activation_40_relu");

for i = 1:k
   start = (i - 1) * perFold + 1;

    if i == k
        final = images;
    else
        final = i * perFold;
    end

    ind = indices(start:final);

    train = setdiff(indices, ind);

    trainSub = subset(imds, train);
    rows = numel(trainSub.Files);
    valSub = subset(imds, ind);
    cell = table(trainSub.Files, trainSub.Labels);
    trainSub = transform(trainSub,@(x) imresize(x, [555 555]));
    valSub = transform(valSub,@(x) imresize(x, [555 555]));
    


    mod = trainFastRCNNObjectDetector(cell, layers1, options); % program breaks here, (invalud network error)

    predictedLabels = detect(mod, valSub);
    % Calculate the accuracy of the model
    accuracy = mean(predictedLabels == valSub.Labels);
    disp(['Model Accuracy: ', num2str(accuracy)]);

end
