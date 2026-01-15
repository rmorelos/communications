clear

% Generate the training data with 200 data points using the generateData 
% supporting function. The network classifies the data into the "Blue" 
% and "Yellow" classes
numSamples = 200;
[X,Y] = generateData(numSamples);
classNames = ["Blue", "Yellow"];

% The input for each data point has the form of 2-D coordinates. 
% Specify the number of classes in the training data.
inputSize = size(X,2);
numClasses = numel(classNames);

layers = [
    featureInputLayer(inputSize,Normalization="none")
    PQCLayer
    fullyConnectedLayer(numClasses)
    softmaxLayer
    classificationLayer];

options = trainingOptions("sgdm", ...
    MiniBatchSize=20, ...
    InitialLearnRate=0.1, ...
    Momentum=0.9, ...
    ExecutionEnvironment="cpu", ...
    Plots="training-progress", ...
    Verbose=false);

% Train the QNN. The result shows an excellent accuracy above 90% for 
% classifying the XOR problem.
net = trainNetwork(X,Y,layers,options)

% Test the classification accuracy of the network by comparing the 
% predictions on the test data with the true labels.
%
% Generate new test data not used during training.
[XTest,trueLabels] = generateData(numSamples);

% Find the predicted classification for the test data.
predictedLabels = classify(net,XTest);

% Plot the predicted classification for the test data.
figure(1)
gscatter(XTest(:,1),XTest(:,2),predictedLabels,"by")


% Visualize the accuracy of the predictions in a confusion chart. Large 
% values on the diagonal indicate accurate predictions for the 
% corresponding class. Large values on the off-diagonal indicate 
% strong confusion between the corresponding classes. Here, the 
% confusion chart shows very small errors in classifying the test data.
figure(2)
confusionchart(trueLabels,predictedLabels)



