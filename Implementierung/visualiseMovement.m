function visualiseMovement(app, positions, connections, eigenVectors, uiAxes, iFreq, skalierung)
    

    % Parameter definieren
    frames = 100; % Anzahl der Frames in der Animation
    knoten = positions; % Format: [KnotenNr, x, y, z]
    koordinaten = knoten(:, 2:4); % Ursprüngliche Knotenkoordinaten
    kanten = connections; % Format: [KnotenNr1, KnotenNr2]
    
    % Bringe Vektor in Matrix Format
    verschiebungen = eigenVectors(:, iFreq);
    
    % Erstelle leere Matrix für die Verschiebungen
    V = zeros(size(koordinaten));
    
    map = app.getSensorToNodeMap;
    % Extrahiere Schlüssel und Werte
    keys = map.keys();

    % Extrahiere die Knoten und Richtungen aus den Strukturen
    for i = 1:length(keys)
        key = keys{i};  % Wähle den entsprechenden key aus der Zelle
        value = map(key);
        knotenNr = value.Knoten;
        richtung = value.Richtung;
        
        % Zuweisung von Koordinate zu zahl
        richtungZahl = app.mapZuweisungRichtung(richtung);
        V(knotenNr,richtungZahl) = verschiebungen(key);
    end

    % Skaliere V
    V = skalierung * V;
    
    % Berechnnuing der Miminal- und Maximalwerte während des Animationsprozesses.
    % Grenzen für die Achsen mit Skalierung t
    minCoords = min(min(real(koordinaten + V), [], 1), min(real(koordinaten - V), [], 1)); % Minimum in jeder Dimension (spaltenweise)
    maxCoords = max(max(real(koordinaten + V), [], 1), max(real(koordinaten - V), [], 1)); % Maximum in jeder Dimension (spaltenweise)

    % Puffer für extra Platz zum Rand
    factor = 0.05;
    distanceCoords = (maxCoords - minCoords)*factor;

    
    xlim_ = [minCoords(1)-distanceCoords(1), maxCoords(1)+distanceCoords(1)];
    ylim_ = [minCoords(2)-distanceCoords(2), maxCoords(2)+distanceCoords(2)];
    zlim_ = [minCoords(3)-distanceCoords(3), maxCoords(3)+distanceCoords(3)];

    % Zeitvektor und Skalierungsfunktion für Verschiebung
    t = linspace(0, 2 * pi, frames); % Beispiel: sinusförmige Variation der Verschiebung
    
    % Vorberechnete Verschiebungen für jedes Frame (frames * n * 3)
    verschiebungen = zeros(frames, length(koordinaten), 3);
    for i = 1:frames
        verschiebungen(i, :, :) = koordinaten + sin(t(i)) * real(V); % Verschiebung berechnen
    end
    
    % Setup für den Plot
    cla(uiAxes);
    hold(uiAxes, 'on');
    axis(uiAxes, 'equal');
    xlabel(uiAxes,'X');
    ylabel(uiAxes,'Y');
    zlabel(uiAxes,'Z');
    view(uiAxes, 3);
    grid(uiAxes, 'on');
    
    % Setze die Achsenbeschränkungen (nur reelle teile werden
    % berücksichtigt und nur wenn Ausdehnung in diese Dimension vorhanden
    % ist)
    if xlim_(1) ~= xlim_(2)
        xlim(uiAxes, real(xlim_));
    end
    if ylim_(1) ~= ylim_(2)
        ylim(uiAxes, real(ylim_));
    end
    if zlim_(1) ~= zlim_(2)
        zlim(uiAxes, real(zlim_));
    end

    
    % Geometrie zeichnen
    hold(uiAxes, 'on');
    perspective = app.getPerspective;           % Auslesen der Richtung aus App
    view(uiAxes,perspective(1),perspective(2)); % Einstellen der Richtung
    knotenPlot = plot3(uiAxes, koordinaten(:, 1), koordinaten(:, 2), koordinaten(:, 3), 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r');
    kantenLines = gobjects(size(kanten, 1), 1);
    
    for i = 1:size(kanten, 1)
        kantenLines(i) = plot3(uiAxes, ...
            [koordinaten(kanten(i, 1), 1), koordinaten(kanten(i, 2), 1)], ...
            [koordinaten(kanten(i, 1), 2), koordinaten(kanten(i, 2), 2)], ...
            [koordinaten(kanten(i, 1), 3), koordinaten(kanten(i, 2), 3)], 'b-', 'LineWidth', 2);
    end
    
    % Animation starten
    while app.getAnimationStatus == true
            % disp("animation läuft");
            for frame = 1:frames

                % Auslesen des Perspektive, falls von Benutzer mit Rotate3D
                % geändert
                app.setPerspective(uiAxes.View);

                aktuelleKoordinaten = squeeze(verschiebungen(frame, :, :)); % Verschiebungen für aktuelles Frame
                
                % Update der Knotenpositionen
                set(knotenPlot, 'XData', aktuelleKoordinaten(:, 1), 'YData', aktuelleKoordinaten(:, 2), 'ZData', aktuelleKoordinaten(:, 3));
                
                % Update der Kantenpositionen
                for i = 1:size(kanten, 1)
                    set(kantenLines(i), 'XData', [aktuelleKoordinaten(kanten(i, 1), 1), aktuelleKoordinaten(kanten(i, 2), 1)], ...
                                        'YData', [aktuelleKoordinaten(kanten(i, 1), 2), aktuelleKoordinaten(kanten(i, 2), 2)], ...
                                        'ZData', [aktuelleKoordinaten(kanten(i, 1), 3), aktuelleKoordinaten(kanten(i, 2), 3)]);
                end
    
                % Zeichnen und aktualisieren des Plots
                perspective = app.getPerspective;           % Auslesen der Richtung aus App
                view(uiAxes,perspective(1),perspective(2)); % Einstellen der Richtung
                drawnow;
    
                % Pause für die Animation
                pause(0.05); % Geschwindigkeit der Animation anpassen
                
                
                if ~isvalid(app) || app.getAnimationStatus == false
                    break;
                    % return;
                end
            end

            if ~isvalid(app) || app.getAnimationStatus == false
                break;
            end
    end
end
