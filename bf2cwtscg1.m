% Load data
load('BFData.mat');

% Extract signals
signals = {data(1, :), data(2, :), data(3, :), data(4, :), data(5, :), ...
           data(6, :), data(7, :), data(8, :), data(9, :), data(10, :)};
       
% Define signal types
bftype = {'BFH', 'BFL', 'BFM', 'IRFH', 'IRFL', 'IRFM', 'N', 'ORFH', 'ORFL', 'ORFM'};

% Signal length and filter bank
signallength = 5120;
fb = cwtfilterbank('SignalLength', signallength, 'Wavelet', 'amor', 'VoicesPerOctave', 48);

% Create directories
mkdir('bfdataset');
for i = 1:length(bftype)
    mkdir(['bfdataset\' lower(bftype{i})]);
end

% Process each signal
for i = 1:length(signals)
    bf2cwtscg(signals{i}, fb, bftype{i});
end