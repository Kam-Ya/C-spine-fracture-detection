
% Read data labels from csv file
csv = "some.csv";
labels = readtable(csv);

% get images from file and make folds
rng(0, "twister") % for reproducability 
file = "IMAGE LOCATIONS";
contents = dir(fullfile(file));
c = cvpartition(numel(content), KFold=10);



% work on the model
fractures = labels.fracture;
imds = imageDatastore(fractures(:,2:end));
% going to ignore boudning box because im not sure how that would work in
% image slices

% make the options for training
options = trainingOptions('sgdm', 'MiniBatchSize', 10, InitialLearnRate', 1e-3, MaxEpochs', 10,CheckpointPath', tempdir);
% Train the model using the image datastore and specified options
mod = trainFastRCNNObjectDetector(imds, layers, options);
