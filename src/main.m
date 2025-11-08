



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
        median = medfilt(images(i));
        open = imopen(median);
        hist = histeq(open);
        list(i) = hist; 
    end

end