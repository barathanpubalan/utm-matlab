DatasetPath = uigetdir('Select the dataset folder');
if isequal(DatasetPath, 0)
    error('No folder selected.');
end

% Load images from the dataset
images = imageDatastore(DatasetPath, 'IncludeSubfolders', true, 'LabelSource', 'foldernames');

% Split data into training and testing sets
numTrainFiles = 97;
[TrainImages, TestImages] = splitEachLabel(images, numTrainFiles, 'randomize');

% Load the pre-trained AlexNet model
net = alexnet;

% Extract layers from the pre-trained network, excluding the last 3 layers
layersTransfer = net.Layers(1:end-3);

% Set the number of output classes (10 classes in your case)
numClasses = 10;

% Define the new layers for the classification task
layers = [
    layersTransfer
    fullyConnectedLayer(numClasses, 'WeightLearnRateFactor', 20, 'BiasLearnRateFactor', 20)
    softmaxLayer
    classificationLayer
];

% Specify options for fine-tuning the network
options = trainingOptions('sgdm', ...
    'MiniBatchSize',10, ...
    'MaxEpochs', 8, ...
    'InitialLearnRate', 1e-4, ...
    'Shuffle', 'every-epoch', ...
    'ValidationData', TestImages, ...
    'ValidationFrequency', 10, ...
    'Verbose', false, ...
    'Plots', 'training-progress');

% Train the network
netTransfer = trainNetwork(TrainImages, layers, options); % Corrected typo here

% Evaluate the model
YPred = classify(netTransfer, TestImages);
YValidation = TestImages.Labels;
accuracy = sum(YPred == YValidation) / numel(YValidation); % Calculate accuracy

% Display confusion matrix
plotconfusion(YValidation, YPred);