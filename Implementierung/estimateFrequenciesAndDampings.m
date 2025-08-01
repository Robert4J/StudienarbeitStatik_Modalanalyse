function [eFrequencies, dampings] = estimateFrequenciesAndDampings(frequenzGruppen, timeVector, singularValues, frequencies)

    numGroups = length(frequenzGruppen);
    
    % Initialisierung der Ausgabevariablen
    eFrequencies = zeros(numGroups, 1);
    dampings = zeros(numGroups, 1);
    dampingsOld = zeros(numGroups, 1);
    dampingsOld_half = zeros(numGroups, 1);
    reconstructedSignals = zeros(length(timeVector), numGroups);

    % Iteriere über Frequenzgruppen
    for i = 1:numGroups
        % Extrahiere die Indizes für diese Gruppe
        currentGroup = frequenzGruppen{i};
        psd_single_sided = zeros(length(frequencies), 1);
        
        % Erzeuge das PSD-Segment
        for j = 1:length(currentGroup)
            idx = currentGroup{j};
            psd_single_sided(idx) = singularValues(idx);
        end

        % IFFT für das PSD-Segment
        timeSignal = ifft(psd_single_sided, length(timeVector), 'symmetric');
        reconstructedSignals(:,i) = timeSignal;

        % Zählen der Nulldurchgänge
        % Vorzeichen des Signals bestimmen
        sign_changes = diff(sign(timeSignal)); 
        
        % Nulldurchgänge zählen (nicht null in `diff(sign(signal))`)
        num_zero_crossings = sum(sign_changes ~= 0);
        dominantFrequency = num_zero_crossings * 2 / timeVector(end);

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% Hüllkurve mittels Hilbert-Transformation
        analyticSignal = hilbert(timeSignal);         % Analytisches Signal berechnen
        envelope = abs(analyticSignal);               % Hüllkurve (Betrag des analytischen Signals)
        
        %% Logarithmische Hüllkurve und lineare Regression
        logEnvelope = log(envelope);                  % Logarithmierte Hüllkurve
        coeffs = polyfit(timeVector, logEnvelope, 1); % Lineare Regression
        
        % Berechnung des Dämpfungsgrads
        decayRate = coeffs(1);                        % Steigung der Regression (Abklingrate)
        zeta_calculated = -decayRate / (2 * pi * dominantFrequency);  % Umrechnung in Dämpfungsgrad

        %% am halben system

        analyticSignal_half = hilbert(timeSignal(1:end/2));         % Analytisches Signal berechnen
        envelope_half = abs(analyticSignal_half);               % Hüllkurve (Betrag des analytischen Signals)
        
        %% Logarithmische Hüllkurve und lineare Regression
        logEnvelope_half = log(envelope_half);                  % Logarithmierte Hüllkurve
        coeffs_half = polyfit(timeVector(1:end/2), logEnvelope_half, 1); % Lineare Regression
        
        % Berechnung des Dämpfungsgrads
        decayRate_half = coeffs_half(1);                        % Steigung der Regression (Abklingrate)
        zeta_calculated_half = -decayRate_half / (2 * pi * dominantFrequency);  % Umrechnung in Dämpfungsgrad
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % Peaks identifizieren
        [peaks, ~] = findpeaks(timeSignal, timeVector);
        % Logarithmische Dekremente berechnen
        % reduziere Peaks
        peaks_red = peaks(1:end/4);

        delta = log(peaks_red(1:end-1) ./ peaks_red(2:end));
        % Durchschnittliches logarithmisches Dekrement
        delta_avg = mean(delta);
        % Dämpfungsgrad berechnen
        zeta_estimated = delta_avg / sqrt(4 * pi^2 + delta_avg^2);

        % Ergebnisse speichern
        eFrequencies(i) = dominantFrequency;
        % dampings(i) = dampingRatio;
        dampings(i) = zeta_estimated;
        dampingsOld(i) = zeta_calculated;
        dampingsOld_half(i) = zeta_calculated_half;   
    end
end
