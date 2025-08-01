function visualiseSensors(app, positions, connections, uiAxes)
    
    knoten = positions; % Format: [KnotenNr, x, y, z]
    koordinaten = knoten(:, 2:4); % Ursprüngliche Knotenkoordinaten
    
    kanten = connections; % Format: [KnotenNr1, KnotenNr2]
    
    % Berechnnuing der Miminal- und Maximalwerte während des Animationsprozesses.
    % Grenzen für die Achsen mit Skalierung t
    minCoords = min(koordinaten , [], 1); % Minimum in jeder Dimension (spaltenweise)
    maxCoords = max(koordinaten , [], 1); % Maximum in jeder Dimension (spaltenweise)
    
    % Puffer für extra Platz zum Rand
    factor = 0.05;
    distanceCoords = (maxCoords - minCoords)*factor;
    
    xlim_ = [minCoords(1)-distanceCoords(1), maxCoords(1)+distanceCoords(1)];
    ylim_ = [minCoords(2)-distanceCoords(2), maxCoords(2)+distanceCoords(2)];
    zlim_ = [minCoords(3)-distanceCoords(3), maxCoords(3)+distanceCoords(3)];
       
    % Setup für den Plot
    cla(uiAxes);
    hold(uiAxes, 'on');
    axis(uiAxes, 'equal');
    xlabel(uiAxes,'X');
    ylabel(uiAxes,'Y');
    zlabel(uiAxes,'Z');
    view(uiAxes, 3);
    grid(uiAxes, 'on');
    
    % Setze die Achsenbeschränkungen (nur wenn Ausdehnung in diese
    % Dimension vorhanden)
    if xlim_(1) ~= xlim_(2)
        xlim(uiAxes, xlim_);
    end
    if ylim_(1) ~= ylim_(2)
        ylim(uiAxes, ylim_);
    end
    if zlim_(1) ~= zlim_(2)
        zlim(uiAxes, zlim_);
    end
    
    % Geometrie zeichnen
    hold(uiAxes, 'on');
    plot3(uiAxes, koordinaten(:, 1), koordinaten(:, 2), koordinaten(:, 3), 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r');
    kantenLines = gobjects(size(kanten, 1), 1);
    
    for i = 1:size(kanten, 1)
        kantenLines(i) = plot3(uiAxes, ...
            [koordinaten(kanten(i, 1), 1), koordinaten(kanten(i, 2), 1)], ...
            [koordinaten(kanten(i, 1), 2), koordinaten(kanten(i, 2), 2)], ...
            [koordinaten(kanten(i, 1), 3), koordinaten(kanten(i, 2), 3)], 'b-', 'LineWidth', 2);
    end

end
