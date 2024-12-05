function bf2cwtscg(bfdata, cwtfb, bftype)
    % Parameters
    nos = 100;  % Number of segments per signal
    nol = 5120; % Length of each segment
    colormap = jet(256); % Colormap for visualization
    % Map bearing fault types to folder paths
    bfFolderMap = containers.Map({'BFH', 'BFL', 'BFM', 'IRFH', 'IRFL', 'IRFM', 'N', 'ORFH', 'ORFL', 'ORFM'}, ...
                                 {'bfh', 'bfl', 'bfm', 'irfh', 'irfl', 'irfm', 'n', 'orfh', 'orfl', 'orfm'});
    
    % Check if provided bftype is valid
    if ~isKey(bfFolderMap, bftype)
        error('Invalid bearing fault type. Choose from ''BFH'', ''BFL'', ''BFM'', ''IRFH'', ''IRFL'', ''IRFM'', ''N'', ''ORFH'', ''ORFL'', or ''ORFM''.');
    end
    
    % Get folder path based on bearing fault type
    folderpath = fullfile('C:', 'Users', 'Barat', 'OneDrive - Universiti Teknologi Malaysia (UTM)', ...
                          'Documents', 'MATLAB', 'bfdataset', bfFolderMap(bftype));
    
    % Segment and process the single row of data
    for k = 1:nos
        % Extract bearing fault segment
        bfsignal = bfdata(1, (k-1)*nol+1 : k*nol);
        
        % Perform CWT and get absolute value
        cfs = abs(cwtfb.wt(bfsignal));
        
        % Rescale and convert to RGB image
        im = ind2rgb(im2uint8(rescale(cfs)), colormap);
        
        % Generate filename and save image
        filename = fullfile(folderpath, sprintf('%d.jpg', k));
        imwrite(imresize(im, [227 227]), filename);
    end
end