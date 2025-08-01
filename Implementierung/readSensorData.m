% Methode gibt einen Vector mit dem Zeitpunkt der Messwerte Seit
function [timeVector, dataSensors] = readSensorData(filePath)
    % Lade die Daten aus der Datei (mit Kopfzeile)
    data = readtable(filePath,'HeaderLines', 4);

    % Zeit- und Messdaten extrahieren
    timeVector = data{:, 1}; % Erste Spalte (Zeit)
    dataSensors = data{:, 2:end}; % Zweite Spalte (Messung)
end