import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Lang;

class MenuView extends WatchUi.View {

    var selectedIdx as Lang.Number = 0;

    static const COL_NEON   as Lang.Number = 0xCC00FF;
    static const COL_PURPLE as Lang.Number = 0x660099;
    static const COL_DIM    as Lang.Number = 0x220033;
    static const COL_BTN    as Lang.Number = 0x110022;

    function initialize() {
        View.initialize();
    }

    function onUpdate(dc as Graphics.Dc) as Void {
        var w  = dc.getWidth();
        var h  = dc.getHeight();
        var cx = w / 2;
        var cy = h / 2;

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();

        // Neon-Rand
        dc.setColor(COL_DIM, Graphics.COLOR_TRANSPARENT);
        dc.drawEllipse(cx, cy, cx - 2, cy - 2);

        // 9 Punkte oben – neon lila
        draw9Dots(dc, cx, 14);

        // Titel
        dc.setColor(COL_NEON, Graphics.COLOR_TRANSPARENT);
        dc.drawLine(60, 56, w - 60, 56);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(cx, 60, Graphics.FONT_SMALL, "RECHNER+", Graphics.TEXT_JUSTIFY_CENTER);
        dc.setColor(COL_PURPLE, Graphics.COLOR_TRANSPARENT);
        dc.drawLine(60, 86, w - 60, 86);

        // Menü-Einträge
        var items = ["Kontakte", "Rechner", "Orbit"] as Lang.Array<Lang.String>;
        var icons = [">>", "##", "**"] as Lang.Array<Lang.String>;
        var itemH = 80;
        var startY = 92;

        for (var i = 0; i < 3; i++) {
            var y     = startY + i * itemH;
            var isSelected = (i == selectedIdx);

            // Hintergrund
            if (isSelected) {
                dc.setColor(COL_DIM, Graphics.COLOR_TRANSPARENT);
                dc.fillRoundedRectangle(30, y, w - 60, itemH - 8, 12);
                dc.setColor(COL_NEON, Graphics.COLOR_TRANSPARENT);
                dc.drawRoundedRectangle(30, y, w - 60, itemH - 8, 12);
                dc.setColor(COL_PURPLE, Graphics.COLOR_TRANSPARENT);
                dc.drawRoundedRectangle(31, y+1, w - 62, itemH - 10, 11);
            } else {
                dc.setColor(COL_BTN, Graphics.COLOR_TRANSPARENT);
                dc.fillRoundedRectangle(30, y, w - 60, itemH - 8, 12);
                dc.setColor(0x330044, Graphics.COLOR_TRANSPARENT);
                dc.drawRoundedRectangle(30, y, w - 60, itemH - 8, 12);
            }

            // Neon-Akzentlinie links
            dc.setColor(isSelected ? COL_NEON : COL_PURPLE, Graphics.COLOR_TRANSPARENT);
            dc.fillRoundedRectangle(30, y + 10, 4, itemH - 28, 2);

            // Label
            dc.setColor(isSelected ? Graphics.COLOR_WHITE : 0x888888, Graphics.COLOR_TRANSPARENT);
            dc.drawText(cx, y + 16, Graphics.FONT_MEDIUM, items[i], Graphics.TEXT_JUSTIFY_CENTER);

            // Subtext
            dc.setColor(isSelected ? COL_NEON : COL_DIM, Graphics.COLOR_TRANSPARENT);
            if (i == 0) {
                dc.drawText(cx, y + 50, Graphics.FONT_SYSTEM_XTINY, "Lilli · Mama · Papa", Graphics.TEXT_JUSTIFY_CENTER);
            } else if (i == 1) {
                dc.drawText(cx, y + 50, Graphics.FONT_SYSTEM_XTINY, "+ - * /", Graphics.TEXT_JUSTIFY_CENTER);
            } else {
                dc.drawText(cx, y + 50, Graphics.FONT_SYSTEM_XTINY, "Live Satellit", Graphics.TEXT_JUSTIFY_CENTER);
            }
        }

        // Swipe-Hinweis unten
        dc.setColor(COL_PURPLE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(cx, h - 16, Graphics.FONT_SYSTEM_XTINY, "Tippen zum Öffnen", Graphics.TEXT_JUSTIFY_CENTER);
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
                dc.setColor(0xCC00FF, Graphics.COLOR_TRANSPARENT);
                dc.fillRoundedRectangle(x, y, dotSize, dotSize, 2);
                dc.setColor(0x220033, Graphics.COLOR_TRANSPARENT);
                dc.drawRoundedRectangle(x-1, y-1, dotSize+2, dotSize+2, 3);
            }
        }
    }
}

class MenuDelegate extends WatchUi.InputDelegate {

    var menuView as MenuView;

    function initialize(v as MenuView) {
        InputDelegate.initialize();
        menuView = v;
    }

    function onTap(clickEvent as WatchUi.ClickEvent) as Lang.Boolean {
        var pos = clickEvent.getCoordinates();
        var ty  = pos[1] as Lang.Number;

        // Kontakte: Y=98-190, Rechner: Y=198-290
        if (ty >= 92 && ty <= 164) {
            menuView.selectedIdx = 0;
            WatchUi.requestUpdate();
            WatchUi.pushView(new MainView(), new MainDelegate(), WatchUi.SLIDE_LEFT);
        } else if (ty >= 172 && ty <= 244) {
            menuView.selectedIdx = 1;
            WatchUi.requestUpdate();
            WatchUi.pushView(new CalcView(), new CalcDelegate(), WatchUi.SLIDE_LEFT);
        } else if (ty >= 252 && ty <= 324) {
            menuView.selectedIdx = 2;
            WatchUi.requestUpdate();
            WatchUi.pushView(new EarthView(), new EarthDelegate(), WatchUi.SLIDE_LEFT);
        }
        return true;
    }

    function onSwipe(swipeEvent as WatchUi.SwipeEvent) as Lang.Boolean {
        if (swipeEvent.getDirection() == WatchUi.SWIPE_DOWN) {
            WatchUi.pushView(new SecretCodeView(), new SecretCodeDelegate(), WatchUi.SLIDE_DOWN);
            return true;
        }
        return false;
    }
}
