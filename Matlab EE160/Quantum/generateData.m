function [X,Y] = generateData(numSamples)
    X = zeros(numSamples,2);
    labels = strings(numSamples,1);
    for i = 1:numSamples
        x1 = 2*rand;
        x2 = rand;
        X(i,:) = [x1 x2];
        if (x1 > 1 && x2 > 0.5) || (x1 < 1 && x2 < 0.5)    
            labels(i) = "Blue";
        else
            labels(i) = "Yellow";
        end
    end
    Y = categorical(labels);
end