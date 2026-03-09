import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Application.Storage;
import Toybox.Lang;

// Scroll-Offset (0 oder 1 – zwei "Seiten")
var gScrollOffset as Lang.Number = 0;

class MainView extends WatchUi.View {

    var contacts as Lang.Array = [];

    // Neon Lila Palette
    static const COL_NEON    as Lang.Number = 0xCC00FF;
    static const COL_PURPLE  as Lang.Number = 0x8800CC;
    static const COL_DIM     as Lang.Number = 0x330044;
    static const COL_GLOW    as Lang.Number = 0x550066;

    function initialize() {
        View.initialize();
        contacts = loadContacts();
    }

    function loadContacts() as Lang.Array {
        var saved = Storage.getValue("contacts");
        if (saved == null) {
            return [
                {"name" => "Lilli",  "number" => "+4915125862455"},
                {"name" => "Mama",   "number" => "+4915254581358"},
                {"name" => "Papa",   "number" => "+491732851009"}
            ] as Lang.Array;
        }
        return saved as Lang.Array;
    }

    function onShow() as Void {
        contacts = loadContacts();
    }

    function onUpdate(dc as Graphics.Dc) as Void {
        var w  = dc.getWidth();
        var h  = dc.getHeight();
        var cx = w / 2;

        // Hintergrund
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();

        // Subtiler Neon-Rand
        dc.setColor(COL_DIM, Graphics.COLOR_TRANSPARENT);
        dc.drawEllipse(cx, h/2, cx - 2, h/2 - 2);

        // 9 Punkte oben – in Neon Lila
        draw9Dots(dc, cx, 14);

        // Trennlinie neon
        dc.setColor(COL_PURPLE, Graphics.COLOR_TRANSPARENT);
        dc.drawLine(40, 56, w - 40, 56);
        // Glow-Linie darunter
        dc.setColor(COL_DIM, Graphics.COLOR_TRANSPARENT);
        dc.drawLine(40, 57, w - 40, 57);

        // Kontakte zeichnen
        // Jede Zeile braucht ~110px für Name + Nummer ohne Überlappung
        // 3 Kontakte = 330px, verfügbar ab Y=62: ~390px → passt
        var areaTop = 62;
        var rowH    = 110;

        for (var i = 0; i < 3; i++) {
            var c      = contacts[i] as Lang.Dictionary;
            var name   = c["name"]   as Lang.String;
            var number = c["number"] as Lang.String;
            var rowTop = areaTop + i * rowH;

            // Zeilen-Hintergrund beim hover / abwechselnd
            if (i % 2 == 0) {
                dc.setColor(0x080008, Graphics.COLOR_TRANSPARENT);
                dc.fillRectangle(0, rowTop, w, rowH);
            }

            // Nummer-Kachel oben in der Zeile
            var nameY   = rowTop + 8;
            var numberY = rowTop + 62;

            // Neon-Akzentlinie links
            dc.setColor(COL_NEON, Graphics.COLOR_TRANSPARENT);
            dc.fillRectangle(0, rowTop + 6, 3, rowH - 12);

            // Name – weiß, groß
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
            dc.drawText(cx, nameY, Graphics.FONT_MEDIUM, name, Graphics.TEXT_JUSTIFY_CENTER);

            // Nummer – neon lila, kleine Schrift, klar darunter
            if (number.equals("")) {
                dc.setColor(COL_DIM, Graphics.COLOR_TRANSPARENT);
                dc.drawText(cx, numberY, Graphics.FONT_SYSTEM_XTINY, "Keine Nummer", Graphics.TEXT_JUSTIFY_CENTER);
            } else {
                dc.setColor(COL_NEON, Graphics.COLOR_TRANSPARENT);
                dc.drawText(cx, numberY, Graphics.FONT_SYSTEM_XTINY, number, Graphics.TEXT_JUSTIFY_CENTER);
            }

            // Trennlinie
            if (i < 2) {
                dc.setColor(COL_GLOW, Graphics.COLOR_TRANSPARENT);
                dc.drawLine(20, rowTop + rowH - 1, w - 20, rowTop + rowH - 1);
            }
        }

        // Scroll-Indikator unten (Swipe-Hinweis)
        dc.setColor(COL_PURPLE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(cx, h - 14, Graphics.FONT_SYSTEM_XTINY, "v  v  v", Graphics.TEXT_JUSTIFY_CENTER);
    }

    function draw9Dots(dc as Graphics.Dc, cx as Lang.Number, topY as Lang.Number) as Void {
        var dotSize = 6;
        var gap     = 6;
        var totalW  = 3 * dotSize + 2 * gap;
        var startX  = cx - totalW / 2;
        for (var row = 0; row < 3; row++) {
            for (var col = 0; col < 3; col++) {
                var x = startX + col * (dotSize + gap);
                var y = topY   + row * (dotSize + gap);
                // Neon Lila Punkte
                dc.setColor(COL_NEON, Graphics.COLOR_TRANSPARENT);
                dc.fillRoundedRectangle(x, y, dotSize, dotSize, 2);
                // Glow
                dc.setColor(COL_DIM, Graphics.COLOR_TRANSPARENT);
                dc.drawRoundedRectangle(x - 1, y - 1, dotSize + 2, dotSize + 2, 3);
            }
        }
    }
}

class MainDelegate extends WatchUi.InputDelegate {

    function initialize() {
        InputDelegate.initialize();
    }

    function onSwipe(swipeEvent as WatchUi.SwipeEvent) as Lang.Boolean {
        var dir = swipeEvent.getDirection();
        if (dir == WatchUi.SWIPE_DOWN) {
            WatchUi.pushView(new SecretCodeView(), new SecretCodeDelegate(), WatchUi.SLIDE_DOWN);
            return true;
        } else if (dir == WatchUi.SWIPE_RIGHT) {
            WatchUi.popView(WatchUi.SLIDE_RIGHT);
            return true;
        }
        return false;
    }
}
