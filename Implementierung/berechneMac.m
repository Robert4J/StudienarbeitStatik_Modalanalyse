function [frequenzGruppen] = berechneMac(macLevel,selectedFrequencies,eigenvectors)

    % Anzahl der Frequenzen
    n = size(selectedFrequencies,1);
    % Cell-Array für zugehörige Frequenzen
    frequenzGruppen = cell(n,1);
    % sammeln der Indizes, die entsprechende übereinstimmung haben.
    for i = 1:n
        currentMAC = macLevel;
        currentIndex = selectedFrequencies(i,1);
        phi_ref = eigenvectors(:,currentIndex);
        indexVector = {}; 
        % Vergleiche mit vektoren Links vom Peak
        while currentMAC >= macLevel
            phi_i = eigenvectors(:, currentIndex);
            zaehler = abs(phi_ref' * phi_i)^2;                   % mit ' für hermitesches Transponat
            nenner = (phi_ref'*phi_ref) * (phi_i'*phi_i);
            currentMAC = zaehler / nenner;

            if currentMAC > macLevel
                indexVector{end + 1} = currentIndex;
                currentIndex = currentIndex - 1;
            end  
        end
        
        % Reset Index und mac
        currentMAC = macLevel;
        currentIndex = selectedFrequencies(i,1) + 1;
        % Vergleiche mit vektoren Rechts vom Peak
        while currentMAC >= macLevel
            phi_i = eigenvectors(:, currentIndex);
            zaehler = abs(phi_ref' * phi_i)^2;                   % mit ' für hermitesches Transponat
            nenner = (phi_ref'*phi_ref) * (phi_i'*phi_i);
            currentMAC = zaehler / nenner;
            if currentMAC > macLevel
                indexVector{end + 1} = currentIndex;
                currentIndex = currentIndex + 1;
               
            end  
        end
        % Sortiere Indizes (sort funktioniert nur für Matrizen)
        indexVector = sort(cell2mat(indexVector));
        indexVector = num2cell(indexVector);
        frequenzGruppen{i} = indexVector;  
    end
end