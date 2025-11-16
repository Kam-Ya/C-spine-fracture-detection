
I = dicomread("360.dcm");
figure();
imshow(I);
title('Original DICOM Image');

test(I);

return;

% The next bit is to work on the outline of a model as I am having issues
% with the dataset

% Read data labels from csv file
csv = "some.csv";
labels = readtable(csv);

% get images from file and make folds
rng(0, "twister") % for reproducability 
file = "IMAGE LOCATIONS";
contents = dir(fullfile(file));
c = cvpartition(numel(content), KFold=10);



% work on the model
fractures = labels.patient_overall;
imds = imageDatastore(fractures(:,2:end));
% going to ignore boudning box because im not sure how that would work in
% image slices

% make the options for training
options = trainingOptions('sgdm', 'MiniBatchSize', 10, InitialLearnRate', 1e-3, MaxEpochs', 10,CheckpointPath', tempdir);
% Train the model using the image datastore and specified options
model = trainFastRCNNObjectDetector(imds, layers, options);

function list = load(folder) 
    % define the type of file to be expected
    filepattern = fullfile(folder, "*.dcm");
    files = dir(filepattern);
    
    % iterate through each file
    for i = 1:files
        list(i) = imread(files(i));
    end
end

function list = addNoise(images)
    list = size(sizeof(images));

    for image = 1:sizeof(images)
        J = rescale(images(image));
        
        % add noise to image based on a random number, 1 = salt and pepper,
        % 2 = gaussian, 3 = poisson
        choice = rand([1 3]);

        if choice == 1
            list(image) = imnoise(J, "salt & pepper", 0.02);
        elseif choice == 2
            list(image) = imgaussfilt(J, 2);
        else
            list(image) = imnoise(J, "poisson");
        end

    end
end

function list = filter(images)
    list = size(sizeof(images));
    % apply all filters for my model
    for i = 1:sizeof(images)
        median = medfilt2(images(i));
        se = strel("disk", 4);
        open = imopen(median, se);
        hist = histeq(open);
        list(i) = hist; 
    end

end


function test(image)
    J = rescale(image);
    gray = im2gray(J);
    noisy = imnoise(gray, "salt & pepper", 0.02);

    median = medfilt2(noisy);
    se = strel("disk", 4);
    open = imopen(median, se);
    % Sobel operator (3x3)
    sobel_x = [-1 0 1; -2 0 2; -1 0 1];
    sobel_y = [1 2 1; 0 0 0; -1 -2 -1];
    sobel_mag = abs(imfilter(open, sobel_x)) + abs(imfilter(open, sobel_y));
    % Display the original and filtered images for comparison
    figure;
    subplot(2, 3, 1); imshow(gray); title("original");
    subplot(2, 3, 2); imshow(noisy); title("noisy");
    subplot(2, 3, 3); imshow(median); title("median filtered");
    subplot(2, 3, 4); imshow(open); title("opened");
    subplot(2, 3, 5); imshow(sobel_mag); title("Sobel magnitude");
end
    


