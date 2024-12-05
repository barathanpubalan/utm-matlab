% Select data file
[file, path] = uigetfile('*.mat', 'Select the MAT-file');
if isequal(file, 0)
    error('No file selected.');
else
    data = load(fullfile(path, file));
end

% Select output directory
outputDir = uigetdir('Select the output directory');
if isequal(outputDir, 0)
    error('No output directory selected.');
end

% Get variable names
varNames = fieldnames(data);

% Define signal length and filter bank
signallength = 25600;
fb = cwtfilterbank('SignalLength', signallength, 'Wavelet', 'amor', 'VoicesPerOctave', 48);

% Process each timetable variable
for i = 1:length(varNames)
    varName = varNames{i};
    signal = data.(varName).Variables; % Assuming timetable variable contains the signal
    mkdir(fullfile(outputDir, varName)); % Create folder for each variable
    bf2cwtscg(signal, fb, varName, outputDir);
end

% Function definition
function bf2cwtscg(bfdata, cwtfb, bftype, outputDir)
    % Segment parameters
    nos = 20;
    nol = 25600;
    colormap = jet(256);

    % Get folder path based on type
    folderpath = fullfile(outputDir, bftype);

    % Loop through segments and process
    for k = 1:nos
        bfsignal = bfdata((k-1)*nol+1 : k*nol);  % Extract segment
        cfs = abs(cwtfb.wt(bfsignal));        % Perform CWT and get absolute value
        im = ind2rgb(im2uint8(rescale(cfs)), colormap); % Rescale and convert to image
im = im - min(im(:)); % Normalize
im = im / max(im(:)); % Normalize
im = imresize(im, [227 227]); % Resize image
filename = fullfile(folderpath, sprintf('%d.jpg', k)); % Generate filename
imwrite(im, filename); % Save normalized image
        
        
    end
end