import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Lang;

var gSecretView as SecretCodeView? = null;

class SecretCodeView extends WatchUi.View {

    var enteredCode as Lang.String = "";

    static const BTN_LABELS as Lang.Array<Lang.String> = ["1","2","3","4","5","6","7","8","9","<","0",">>"];

    // Neon Lila
    static const COL_NEON   as Lang.Number = 0xCC00FF;
    static const COL_PURPLE as Lang.Number = 0x660099;
    static const COL_DIM    as Lang.Number = 0x220033;
    static const COL_BTN    as Lang.Number = 0x110022;

    // Adaptives Layout: pro Reihe eigene X-Position und Breite
    // [margin, btnW] für jede der 4 Reihen – berechnet für 454px runden Bildschirm
    static const ROW_MARGIN as Lang.Array<Lang.Number> = [52, 15, 31, 95] as Lang.Array<Lang.Number>;
    static const BTN_H      as Lang.Number = 72;
    static const BTN_PAD    as Lang.Number = 6;
    static const TOP_Y      as Lang.Number = 96;

    static function rowBtnW(row as Lang.Number) as Lang.Number {
        var m = ROW_MARGIN[row] as Lang.Number;
        return (454 - m * 2 - BTN_PAD * 2) / 3;
    }

    static function rowX(row as Lang.Number, col as Lang.Number) as Lang.Number {
        var m  = ROW_MARGIN[row] as Lang.Number;
        var bw = rowBtnW(row);
        return m + col * (bw + BTN_PAD);
    }

    static function rowY(row as Lang.Number) as Lang.Number {
        return TOP_Y + row * (BTN_H + BTN_PAD);
    }

    function initialize() {
        View.initialize();
        gSecretView = self;
    }

    function onHide() as Void {
        gSecretView = null;
    }

    function onUpdate(dc as Graphics.Dc) as Void {
        var w  = dc.getWidth();
        var h  = dc.getHeight();
        var cx = w / 2;

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();

        // Neon-Rand
        dc.setColor(COL_DIM, Graphics.COLOR_TRANSPARENT);
        dc.drawEllipse(cx, h/2, cx - 2, h/2 - 2);

        // Eingabefeld
        dc.setColor(COL_BTN, Graphics.COLOR_TRANSPARENT);
        dc.fillRoundedRectangle(30, 12, w - 60, 54, 10);
        dc.setColor(COL_PURPLE, Graphics.COLOR_TRANSPARENT);
        dc.drawRoundedRectangle(30, 12, w - 60, 54, 10);
        dc.setColor(COL_NEON, Graphics.COLOR_TRANSPARENT);
        dc.drawRoundedRectangle(31, 13, w - 62, 52, 9);

        if (enteredCode.length() > 0) {
            var display = "";
            for (var i = 0; i < enteredCode.length(); i++) {
                if (i > 0) { display = display + "  "; }
                display = display + enteredCode.substring(i, i + 1);
            }
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
            dc.drawText(cx, 20, Graphics.FONT_MEDIUM, display, Graphics.TEXT_JUSTIFY_CENTER);
        } else {
            dc.setColor(0x553366, Graphics.COLOR_TRANSPARENT);
            dc.drawText(cx, 24, Graphics.FONT_SMALL, "Nummer eingeben", Graphics.TEXT_JUSTIFY_CENTER);
        }

        // Trennlinie
        dc.setColor(COL_PURPLE, Graphics.COLOR_TRANSPARENT);
        dc.drawLine(50, TOP_Y - 8, w - 50, TOP_Y - 8);

        // Buttons – adaptiv pro Reihe
        var subLabels = ["", "ABC", "DEF", "GHI", "JKL", "MNO", "PQRS", "TUV", "WXYZ", "", "+", ""];
        for (var i = 0; i < 12; i++) {
            var col  = i % 3;
            var row  = i / 3;
            var x    = rowX(row, col);
            var y    = rowY(row);
            var bw   = rowBtnW(row);
            var lbl  = BTN_LABELS[i];
            var isDel  = lbl.equals("<");
            var isCall = lbl.equals(">>");

            if (isCall) {
                // Grüner Anruf-Button
                dc.setColor(0x004400, Graphics.COLOR_TRANSPARENT);
                dc.fillRoundedRectangle(x, y, bw, BTN_H, 8);
                dc.setColor(0x00AA00, Graphics.COLOR_TRANSPARENT);
                dc.drawRoundedRectangle(x, y, bw, BTN_H, 8);
                dc.setColor(0x00EE00, Graphics.COLOR_TRANSPARENT);
                dc.drawRoundedRectangle(x + 1, y + 1, bw - 2, BTN_H - 2, 7);
                // Telefonhörer
                var hx = x + bw / 2;
                var hy = y + BTN_H / 2;
                dc.setColor(0x00FF44, Graphics.COLOR_TRANSPARENT);
                dc.fillEllipse(hx - 10, hy - 9, 9, 7);
                dc.fillEllipse(hx + 10, hy + 9, 9, 7);
                dc.fillRoundedRectangle(hx - 12, hy - 4, 24, 8, 4);
            } else {
                // Normaler Button
                dc.setColor(COL_BTN, Graphics.COLOR_TRANSPARENT);
                dc.fillRoundedRectangle(x, y, bw, BTN_H, 8);
                dc.setColor(isDel ? COL_NEON : 0x440055, Graphics.COLOR_TRANSPARENT);
                dc.drawRoundedRectangle(x, y, bw, BTN_H, 8);

                // Ziffer
                dc.setColor(isDel ? COL_NEON : Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
                dc.drawText(x + bw / 2, y + 6, Graphics.FONT_MEDIUM, lbl, Graphics.TEXT_JUSTIFY_CENTER);

                // Buchstaben
                var sub = subLabels[i];
                if (!sub.equals("")) {
                    dc.setColor(COL_PURPLE, Graphics.COLOR_TRANSPARENT);
                    dc.drawText(x + bw / 2, y + BTN_H - 20, Graphics.FONT_SYSTEM_XTINY, sub, Graphics.TEXT_JUSTIFY_CENTER);
                }
            }
        }
    }
}

class SecretCodeDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onTap(clickEvent as WatchUi.ClickEvent) as Lang.Boolean {
        var v = gSecretView;
        if (v == null) { return true; }

        var pos = clickEvent.getCoordinates();
        var tx  = pos[0] as Lang.Number;
        var ty  = pos[1] as Lang.Number;

        for (var i = 0; i < 12; i++) {
            var col = i % 3;
            var row = i / 3;
            var bx  = SecretCodeView.rowX(row, col);
            var by  = SecretCodeView.rowY(row);
            var bw  = SecretCodeView.rowBtnW(row);

            if (tx >= bx && tx <= bx + bw && ty >= by && ty <= by + SecretCodeView.BTN_H) {
                handlePress(v, SecretCodeView.BTN_LABELS[i]);
                WatchUi.requestUpdate();
                return true;
            }
        }
        return true;
    }

    function handlePress(v as SecretCodeView, label as Lang.String) as Void {
        if (label.equals("<")) {
            var len = v.enteredCode.length();
            if (len > 0) {
                v.enteredCode = v.enteredCode.substring(0, len - 1) as Lang.String;
            }
        } else if (label.equals(">>")) {
            checkCode(v);
        } else {
            if (v.enteredCode.length() < 8) {
                v.enteredCode = v.enteredCode + label;
            }
        }
    }

    function checkCode(v as SecretCodeView) as Void {
        if (v.enteredCode.equals(SECRET_CODE)) {
            WatchUi.pushView(new GhostView(), new GhostDelegate(), WatchUi.SLIDE_UP);
        } else {
            v.enteredCode = "";
        }
    }

    function onKey(evt as WatchUi.KeyEvent) as Lang.Boolean {
        if (evt.getKey() == WatchUi.KEY_ESC) {
            WatchUi.popView(WatchUi.SLIDE_UP);
        }
        return true;
    }
}
