



function list = load(folder) 
    % define the type of file to be expected
    filepattern = fullfile(folder, "*.dcm");
    files = dir(filepattern);
    
    % iterate through each file
    for i = 1:files

    end
end

function  folds = fold(list)
    
end