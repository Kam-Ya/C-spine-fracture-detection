test(imread("1.png"));
return; 
% load and process fractured images
folder = 'images/fracture';
images = load(folder);
saveList(filter(addNoise(images)), "images/frac", "frac");
clear();

% load and process normal images
folder2 = 'images/normal';
images2 = load(folder2);
saveList(filter(addNoise(images2)), "images/norm", "norm");

return;

function list = load(folder) 
    % define the type of file to be expected
    pattern = fullfile(folder, '*.png');
    files = dir(pattern);
    num = length(files);
    list = cell(num);

    % iterate through each file
    for i = 1:num
        base = files(i).name;
        name = fullfile(files(i).folder, base);
        % fprintf('file name = %s\n', name);
        list{i} = im2gray(imread(name));
    end
end

function list = addNoise(images)
    num = length(images);
    list = cell(num);

    for image = 1:num
        J = images{image};
        
        
        % add noise to image based on a random number, 1 = salt and pepper,
        % 2 = gaussian, 3 = poisson
        choice = rand([1 3]);

        if choice == 1
            list{image} = imnoise(J, "salt & pepper", 0.02);
        elseif choice == 2
            list{image} = imgaussfilt(J, 2);
        else
            list{image} = imnoise(J, "poisson");
        end

    end
end

function list = filter(images)
    num = length(images);
    list = cell(num);
    % apply all filters for my model
    for i = 1:num
        median = medfilt3(images{i});
        se = strel("disk", 4);
        open = imopen(median, se);
        % hist = histeq(open);
        sobel_x = [-1 0 1; -2 0 2; -1 0 1];
        sobel_y = [1 2 1; 0 0 0; -1 -2 -1];
        sobel_mag = abs(imfilter(open, sobel_x)) + abs(imfilter(open, sobel_y));
        list{i} = sobel_mag; 
    end

end


function test(image)
    J = rescale(image);
    gray = im2gray(J);
    noisy = imgaussfilt(gray, 2);

    median = medfilt2(noisy);
    se = strel("disk", 4);
    open = imopen(median, se);
    sobel_x = [-1 0 1; -2 0 2; -1 0 1];
    sobel_y = [1 2 1; 0 0 0; -1 -2 -1];
    sobel_mag = abs(imfilter(open, sobel_x)) + abs(imfilter(open, sobel_y));
    % Display the original and filtered images for comparison
    fig = figure;
    imshow(gray); title("original");
    saveas(fig, "example.png");
    close(fig);

    fig = figure;
    imshow(noisy); title("noisy");
    saveas(fig, "noisy.png");
    close(fig);
    fig = figure;
    imshow(median); title("median");
    saveas(fig, "median.png");
    close(fig);
    fig = figure;
    imshow(open); title("opened");
    saveas(fig, "open.png");
    close(fig);
    fig = figure;
    imshow(sobel_mag); title("edge detection");
    saveas(fig, "edge.png");
    close(fig);
end
    

function saveList(list, folder, named)

    fold = folder;
    if ~exist(fold, 'dir') % make the folder if it doesnt exist
        mkdir(fold);
    end
  
    for i = 1:length(list)
        fig = figure;
        name = sprintf('%s%d.png', named, i);
        full = fullfile(fold, name);
        
        subplot(1,1,1);
        imshow(list{i});

        saveas(fig, full);
        close(fig);
    end
end


