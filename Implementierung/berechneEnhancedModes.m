function [eModes] = berechneEnhancedModes(frequenzGruppen, singularValues, eigenvectors)

    eModes = zeros(size(eigenvectors, 1), length(frequenzGruppen));
    for i = 1:length(frequenzGruppen)
        currentGroup = frequenzGruppen{i};
        enhancedEigenvector = zeros(size(eigenvectors, 1), 1);
        sumAmplitude = 0;
        for j = 1:length(currentGroup)
            index = currentGroup{j};
            enhancedEigenvector = enhancedEigenvector + singularValues(index) * eigenvectors(:,index);
            sumAmplitude = sumAmplitude + singularValues(index);
        end
        enhancedEigenvector = enhancedEigenvector / sumAmplitude;
        % Normalize Vector
        enhancedEigenvector = real(enhancedEigenvector(:,1)) / norm(real(enhancedEigenvector(:,1)));   % Normalisierung der Moden (Euklidische Norm -> norm(v) = Länge v)
        eModes(:,i) = enhancedEigenvector;
    end
end