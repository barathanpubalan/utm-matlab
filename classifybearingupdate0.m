% Load data
load('BFData.mat');

% Extract signals and define types
signals = data; % Assuming data is a matrix with signals in rows
bftype = {'BFH', 'BFL', 'BFM', 'IRFH', 'IRFL', 'IRFM', 'N', 'ORFH', 'ORFL', 'ORFM'};

% Define signal length and filter bank
signallength = 25600;
fb = cwtfilterbank('SignalLength', signallength, 'Wavelet', 'amor', 'VoicesPerOctave', 48);

% Create directories for each bearing fault type
bf_folders = lower(bftype);  % Convert type names to lowercase for folder names
for i = 1:length(bf_folders)
    mkdir(['bfdataset\' bf_folders{i}]);
end

% Process each signal
for i = 1:length(signals)
    bf2cwtscg(signals(i, :), fb, bftype{i});
end

% Function definition
function bf2cwtscg(bfdata, cwtfb, bftype)
    % Segment parameters
    nos = 20;
    nol = 25600;
    colormap = jet(256);

    % Check for valid type
    if ~any(strcmp(bftype, {'BFH', 'BFL', 'BFM', 'IRFH', 'IRFL', 'IRFM', 'N', 'ORFH', 'ORFL', 'ORFM'}))
        error('Invalid bearing fault type provided.');
    end

    % Get folder path based on type
    folderpath = fullfile('C:', 'Users', 'Barat', 'OneDrive - Universiti Teknologi Malaysia (UTM)', ...
                          'Documents', 'MATLAB', 'bfdataset', lower(bftype));

    % Loop through segments and process
    for k = 1:nos
        bfsignal = bfdata((k-1)*nol+1 : k*nol);  % Extract segment
        cfs = abs(cwtfb.wt(bfsignal));        % Perform CWT and get absolute value
        im = ind2rgb(im2uint8(rescale(cfs)), colormap); % Rescale and convert to image
        filename = fullfile(folderpath, sprintf('%d.jpg', k)); % Generate filename
        imwrite(imresize(im, [227 227]), filename); % Save resized image
    end
end