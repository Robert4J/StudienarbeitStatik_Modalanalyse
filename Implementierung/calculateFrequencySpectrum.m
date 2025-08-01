function [f, amplitude] = calculateFrequencySpectrum(timeVector, dataSensors)
    
    % Parameter
    fs = 1 / (timeVector(2) - timeVector(1)); % Abtastrate basierend auf den Zeitdaten
    N = length(timeVector); % Anzahl der Datenpunkte

    % FFT berechnen
    Y = fft(dataSensors); % Fourier-Transformation
    f = (0:N-1)*(fs/N); % Frequenzachse
    amplitude = abs(Y/N); % Amplitude

    % Nur positive Frequenzen
    f = f(1:int32(N/2)+1);
    amplitude = amplitude(1:int32(N/2)+1);
    amplitude(2:end-1) = 2*amplitude(2:end-1); % Amplitude anpassen
end
