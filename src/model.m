
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
options = trainingOptions('sgdm', 'InitialLearnRate', 1e-3, 'MaxEpochs', 10,'CheckpointPath', "checkpoint");

layers1 = [
        imageInputLayer([1124 1866 3])
        convolution2dLayer(3,8, "Padding","same")
        batchNormalizationLayer
        reluLayer
        maxPooling2dLayer(2, "Stride", 2)
        fullyConnectedLayer(2)
        softmaxLayer
        classificationLayer];

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
    trainCell = change(trainSub, [555 555], rows);
    valSub = change(valSub, [555 555], numel(valSub.Files));
    

    disp("training");
    mod = trainNetwork(trainSub, layers1, options); % program breaks here, (invalud network error)

    predictedLabels = detect(mod, valSub);
    % Calculate the accuracy of the model
    accuracy = mean(predictedLabels == valSub.Labels);
    disp(['Model Accuracy: ', num2str(accuracy)]);

end

function cells = change(x, size, rows)
    V = cell(rows);
    label = cell(rows);
    for image = 1:rows
        V{image} = imresize(readimage(x, image), size);
        label = x.Labels(image);
    end
    cells = {V, label};
end
