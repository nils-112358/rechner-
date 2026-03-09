# Rechner+ 🌍

Eine Garmin Connect IQ App für die **Fenix 8 (47mm)** – kombiniert Taschenrechner, Notfallkontakte und Orbit-Tracker in einer App mit versteckten Easter Eggs.

---

## Features

### 📱 Hauptmenü
- **Kontakte** – Schnellzugriff auf 3 Notfallkontakte (Lilli, Mama, Papa)
- **Rechner** – Vollwertiger Taschenrechner mit den 4 Grundrechenarten
- **Orbit** – Animierter Wire-Globe mit Satellit auf Umlaufbahn

### 🔢 Taschenrechner
- Addition, Subtraktion, Multiplikation, Division
- Kettenrechnung möglich
- `C` zum Zurücksetzen

### 🌍 Orbit Tracker
- Erde mit echten Küstenlinien (orthografische Projektion, Europa zentriert)
- Gitternetz mit Tiefen-Shading
- Animierter Satellit auf geneigter Umlaufbahn
- Tippen oder Swipe-Right zum Zurückgehen

---

## Easter Eggs 🥚

### 1. Anonymous / Hacker Screen
Im **Hauptmenü**: **Swipe-Down** öffnet einen geheimen PIN-Dialer.  
Code eingeben: **`1337`** → grünen Anruf-Button drücken → Anonymous-Maske erscheint.

### 2. Verstecktes Bild im Rechner
Im **Rechner**: **`1337`** eintippen → **`=`** drücken → dein persönliches Bild erscheint.

---

## Installation

### Voraussetzungen
- [Visual Studio Code](https://code.visualstudio.com/)
- [Monkey C Extension](https://marketplace.visualstudio.com/items?itemName=garmin.monkey-c) von Garmin
- Java Temurin 17+
- Garmin Connect IQ SDK

### Setup
```bash
git clone https://github.com/DEIN_USERNAME/rechner-plus.git
cd rechner-plus
```
1. In VS Code öffnen
2. `Ctrl+Shift+P` → **Monkey C: Edit Products** → `fenix847mm` auswählen
3. `Ctrl+F5` → startet den Simulator

### Auf die Uhr übertragen
1. Fenix 8 per USB verbinden
2. Kompilierte `.prg`-Datei nach `GARMIN/APPS/` kopieren

---

## Eigenes Bild hinzufügen (Hidden Easter Egg)

1. Bild vorbereiten: **beliebige Größe** – wird automatisch skaliert
2. Als **`Hidden.png`** in `resources/drawables/` ablegen
3. Neu kompilieren
4. Im Rechner `1337` + `=` drücken

---

## Projektstruktur

```
rechner-plus/
├── source/
│   ├── GhostContactsApp.mc   ← Einstiegspunkt, Geheimcode
│   ├── MenuView.mc           ← Hauptmenü
│   ├── MainView.mc           ← Kontaktliste
│   ├── CalcView.mc           ← Taschenrechner
│   ├── EarthView.mc          ← Orbit Tracker
│   ├── HiddenView.mc         ← Verstecktes Bild
│   ├── SecretCodeView.mc     ← PIN-Dialer Easter Egg
│   └── GhostView.mc          ← Anonymous-Maske
├── resources/
│   ├── drawables/
│   │   ├── drawables.xml
│   │   ├── launcher_icon.png
│   │   └── Hidden.png        ← hier dein Bild einfügen
│   └── strings/
│       └── strings.xml
├── manifest.xml
├── monkey.jungle
└── README.md
```

---

## Farb-Schema

| Farbe | Hex | Verwendung |
|-------|-----|------------|
| Neon-Lila | `#CC00FF` | Rechner, Kontakte, Menü |
| Neon-Blau | `#00CCFF` | Orbit Tracker |
| Neon-Grün | `#00EE00` | Anruf-Button |
| Rot | `#FF4444` | Clear-Button |

---

## Geheimcode ändern

In `source/GhostContactsApp.mc`:
```javascript
const SECRET_CODE = "1337";  // ← hier ändern
```

---

## Kompatibilität

| Gerät | Status |
|-------|--------|
| Fenix 8 47mm | ✅ Getestet |
| Fenix 8 43mm | ⚠️ Ungetestet |
| Andere Garmin | ⚠️ Layout ggf. anpassen |

---

## Lizenz

MIT License – frei verwendbar und anpassbar.

---

*Entwickelt mit ❤️ und Claude AI*
