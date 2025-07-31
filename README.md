# FDD/eFDD MATLAB-App – Modalanalyse

Diese MATLAB-App ermöglicht die Durchführung einer output-only Modalanalyse auf Basis der Frequency Domain Decomposition (FDD) und der erweiterten Enhanced FDD (eFDD). Ziel ist die Ermittlung modaler Parameter – insbesondere Eigenfrequenzen, Eigenformen und Dämpfungsgrade – aus Messdaten, wie sie typischerweise bei Bauwerksanalysen, Schwingungsuntersuchungen oder Structural Health Monitoring verwendet werden.

Die App unterstützt den gesamten Workflow: vom Import der Messdaten über die Berechnung bis hin zur visuellen Auswertung der Ergebnisse.

---

## 🧩 Funktionsüberblick

Die App besteht aus mehreren modularen Tabs, die den Analyseprozess in drei Hauptabschnitte gliedern:

1. **Import** – Hochladen und visuelle Kontrolle der Eingabedateien  
2. **Berechnung** – Durchführung der Modalanalyse mittels FDD oder eFDD  
3. **Auswertung** – Visualisierung und Validierung der ermittelten Moden und Parameter

Eine Bedienung der App ist über eine intuitive grafische Benutzeroberfläche (GUI) möglich. Die Berechnungen basieren auf bewährten signalverarbeitungstechnischen Verfahren (FFT, CPSD, MAC, SVD etc.).

---

## 🖥️ Tab-Übersicht

### 🔹 Import Files
- Upload von vier erforderlichen Datendateien:
  - Messdaten der Sensoren
  - Sensorpositionen im Raum
  - Verbindungen zwischen Sensoren
  - Zuordnung der Messungen zu Positionen und Richtungen
- Übersichtliche tabellarische Anzeige und grafische Netzstruktur
- Anzeige von Basisinformationen: Anzahl Sensoren, Dauer des Signals, Abtastrate etc.

### 🔹 Grafische Darstellung der Signale
- Zeitdomänenplots für jeden Sensor
- Gruppierung nach Position und Messrichtung
- Interaktive Auswahl des Signalbereichs über Slider
- Frequenzspektrum (FFT) zur Analyse der dominanten Frequenzanteile

### 🔹 Peak Auswahl (Modalanalyse)
- Berechnung der Cross-Power Spectral Density (CPSD)
- Singulärwertzerlegung (SVD) zur Modenidentifikation
- Interaktive Auswahl von Frequenzpeaks
- Umschaltbar zwischen FDD und eFDD
- Anpassbares MAC-Rejection-Level für eFDD

### 🔹 EFDD Details
- Darstellung der Spectral Bells pro Modus
- Visualisierung im Frequenz- und Zeitbereich
- Farbliche Markierung der zugehörigen Frequenzbänder

### 🔹 Dämpfung
- IFFT-Rücktransformation zur Zeitsignal-Darstellung
- Berechnung des logarithmischen Dekrements aus den Peaks
- Lineare Regression zur Bestimmung des Dämpfungsgrads
- Speicherung der Dämpfungswerte pro Modus

### 🔹 Eigenformen
- 3D-Animation der berechneten Schwingungsmoden (FDD und eFDD)
- Visualisierung und Vergleich beider Methoden
- Aktivierung der Differenzdarstellung zwischen FDD- und eFDD-Formen

---

## 📂 Eingabedateien

Für die Nutzung der App werden vier txt-Dateien benötigt:

### 1. **Messdaten** (`measurement_data_*.txt`)
- Enthält Zeitreihen der gemessenen Beschleunigungen (oder anderer dynamischer Größen)
- Aufbau: Jede Spalte entspricht einem Messkanal (z. B. Sensor X-Richtung), jede Zeile einem Zeitschritt

### 2. **Sensorpositionen** (`sensor_positions.txt`)
- Enthält die räumlichen Koordinaten jedes Sensors
- Format: `Sensor-ID, X, Y, Z`

### 3. **Verbindungen zwischen Sensoren** (`sensor_connections.txt`)
- Beschreibt die logische oder physische Vernetzung der Sensoren für die grafische Darstellung
- Format: `Start-Sensor-ID, End-Sensor-ID`

### 4. **Sensorzuordnung** (`sensor_mapping.txt`)
- Ordnet Messkanäle den Sensoren und Messrichtungen zu
- Format: `Sensor-ID, Kanalnummer, Richtung (X/Y/Z)`

👉 Beispielhafte Eingabedateien sind im Ordner `example_data/` enthalten.

---

## 📘 Weitere Informationen

Detaillierte Erklärungen zur Methodik, Implementierung und Validierung findest du in der zugehörigen [Studienarbeit](Link) sowie auf der Projektseite:  
👉 **[www.meineArbeit-Github.de](http://www.meineArbeit-Github.de)**

---

## ⚙️ Systemvoraussetzungen

Um diese App nutzen zu können, müssen auf dem Zielsystem folgende Anforderungen erfüllt sein:

- Eine installierte Version von **MATLAB R2024b oder neuer**
- Die folgenden MATLAB-Toolboxes müssen installiert und lizenziert sein:
  - Signal Processing Toolbox
  - Image Processing Toolbox
  - Statistics and Machine Learning Toolbox

> ℹ️ Hinweis: Diese App wurde als `.mlappinstall`-Datei exportiert. Sie ist **nicht als Standalone-App** ausführbar und benötigt daher eine vollständige MATLAB-Installation mit den oben genannten Toolboxes.

### 📦 Installation der App

- Lade die Datei `DeineApp.mlappinstall` herunter
- Öffne sie per Doppelklick **oder** installiere sie in MATLAB unter:
  `APPS > Install App > Datei auswählen`

Bei fehlenden Toolboxes oder einer veralteten MATLAB-Version kann die App nicht korrekt gestartet werden.
