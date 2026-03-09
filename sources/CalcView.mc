import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Math;

var gCalcView as CalcView? = null;

class CalcView extends WatchUi.View {

    var display    as Lang.String  = "0";
    var operand1   as Lang.Float   = 0.0f;
    var operator   as Lang.String  = "";
    var waitNext   as Lang.Boolean = false;
    var hasDecimal as Lang.Boolean = false;

    // Neon Lila Palette
    static const COL_NEON   as Lang.Number = 0xCC00FF;
    static const COL_PURPLE as Lang.Number = 0x660099;
    static const COL_DIM    as Lang.Number = 0x220033;
    static const COL_BTN    as Lang.Number = 0x110022;
    static const COL_OP     as Lang.Number = 0x330044;

    // Labels: 4 Spalten x 4 Reihen
    static const LABELS as Lang.Array<Lang.String> = [
        "7", "8", "9", "/",
        "4", "5", "6", "*",
        "1", "2", "3", "-",
        "C", "0", "=", "+"
    ] as Lang.Array<Lang.String>;

    // Adaptiver Rand pro Reihe (runder Bildschirm, berechnet)
    static const ROW_MARGIN as Lang.Array<Lang.Number> = [63, 20, 28, 83] as Lang.Array<Lang.Number>;
    static const BTN_H      as Lang.Number = 72;
    static const BTN_PAD    as Lang.Number = 5;
    static const TOP_Y      as Lang.Number = 86;

    static function rowBtnW(row as Lang.Number) as Lang.Number {
        var m = ROW_MARGIN[row] as Lang.Number;
        return (454 - m * 2 - BTN_PAD * 3) / 4;
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
        gCalcView = self;
    }

    function onHide() as Void {
        gCalcView = null;
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

        // Display-Bereich
        dc.setColor(COL_BTN, Graphics.COLOR_TRANSPARENT);
        dc.fillRoundedRectangle(30, 10, w - 60, 60, 10);
        dc.setColor(COL_PURPLE, Graphics.COLOR_TRANSPARENT);
        dc.drawRoundedRectangle(30, 10, w - 60, 60, 10);
        dc.setColor(COL_NEON, Graphics.COLOR_TRANSPARENT);
        dc.drawRoundedRectangle(31, 11, w - 62, 58, 9);

        // Operator-Anzeige klein links
        if (!operator.equals("")) {
            dc.setColor(COL_PURPLE, Graphics.COLOR_TRANSPARENT);
            dc.drawText(50, 18, Graphics.FONT_SMALL, operator, Graphics.TEXT_JUSTIFY_LEFT);
        }

        // Zahl rechtsbündig im Display
        var dispFont = display.length() > 8 ? Graphics.FONT_SMALL : Graphics.FONT_MEDIUM;
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(w - 42, 20, dispFont, display, Graphics.TEXT_JUSTIFY_RIGHT);

        // Trennlinie
        dc.setColor(COL_PURPLE, Graphics.COLOR_TRANSPARENT);
        dc.drawLine(50, TOP_Y - 8, w - 50, TOP_Y - 8);

        // Buttons
        for (var i = 0; i < 16; i++) {
            var col  = i % 4;
            var row  = i / 4;
            var x    = rowX(row, col);
            var y    = rowY(row);
            var bw   = rowBtnW(row);
            var lbl  = LABELS[i];
            var isOp = lbl.equals("/") || lbl.equals("*") || lbl.equals("-") || lbl.equals("+");
            var isEq = lbl.equals("=");
            var isC  = lbl.equals("C");

            // Hintergrund
            if (isEq) {
                dc.setColor(0x004400, Graphics.COLOR_TRANSPARENT);
            } else if (isOp) {
                dc.setColor(COL_OP, Graphics.COLOR_TRANSPARENT);
            } else if (isC) {
                dc.setColor(0x220000, Graphics.COLOR_TRANSPARENT);
            } else {
                dc.setColor(COL_BTN, Graphics.COLOR_TRANSPARENT);
            }
            dc.fillRoundedRectangle(x, y, bw, BTN_H, 8);

            // Rahmen
            if (isEq) {
                dc.setColor(0x00AA00, Graphics.COLOR_TRANSPARENT);
                dc.drawRoundedRectangle(x, y, bw, BTN_H, 8);
                dc.setColor(0x00DD00, Graphics.COLOR_TRANSPARENT);
                dc.drawRoundedRectangle(x+1, y+1, bw-2, BTN_H-2, 7);
            } else if (isOp) {
                dc.setColor(COL_NEON, Graphics.COLOR_TRANSPARENT);
                dc.drawRoundedRectangle(x, y, bw, BTN_H, 8);
            } else if (isC) {
                dc.setColor(0xAA0000, Graphics.COLOR_TRANSPARENT);
                dc.drawRoundedRectangle(x, y, bw, BTN_H, 8);
            } else {
                dc.setColor(0x440055, Graphics.COLOR_TRANSPARENT);
                dc.drawRoundedRectangle(x, y, bw, BTN_H, 8);
            }

            // Label
            if (isEq) {
                dc.setColor(0x00FF44, Graphics.COLOR_TRANSPARENT);
            } else if (isOp) {
                dc.setColor(COL_NEON, Graphics.COLOR_TRANSPARENT);
            } else if (isC) {
                dc.setColor(0xFF4444, Graphics.COLOR_TRANSPARENT);
            } else {
                dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
            }
            dc.drawText(x + bw/2, y + BTN_H/2 - 18, Graphics.FONT_MEDIUM, lbl, Graphics.TEXT_JUSTIFY_CENTER);
        }
    }
}

class CalcDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onTap(clickEvent as WatchUi.ClickEvent) as Lang.Boolean {
        var v = gCalcView;
        if (v == null) { return true; }

        var pos = clickEvent.getCoordinates();
        var tx  = pos[0] as Lang.Number;
        var ty  = pos[1] as Lang.Number;

        for (var i = 0; i < 16; i++) {
            var col = i % 4;
            var row = i / 4;
            var bx  = CalcView.rowX(row, col);
            var by  = CalcView.rowY(row);
            var bw  = CalcView.rowBtnW(row);

            if (tx >= bx && tx <= bx + bw && ty >= by && ty <= by + CalcView.BTN_H) {
                handlePress(v, CalcView.LABELS[i]);
                WatchUi.requestUpdate();
                return true;
            }
        }
        return true;
    }

    function handlePress(v as CalcView, lbl as Lang.String) as Void {
        if (lbl.equals("C")) {
            v.display    = "0";
            v.operand1   = 0.0d;
            v.operator   = "";
            v.waitNext   = false;
            v.hasDecimal = false;
        } else if (lbl.equals("=")) {
            // Easter Egg: 1337 eingegeben -> verstecktes Bild
            if (v.display.equals("1337") && v.operator.equals("")) {
                WatchUi.pushView(new HiddenView(), new HiddenDelegate(), WatchUi.SLIDE_DOWN);
                return;
            }
            calculate(v);
        } else if (lbl.equals("+") || lbl.equals("-") || lbl.equals("*") || lbl.equals("/")) {
            if (!v.operator.equals("") && !v.waitNext) {
                calculate(v);
            }
            v.operand1   = v.display.toFloat();
            v.operator   = lbl;
            v.waitNext   = true;
            v.hasDecimal = false;
        } else {
            // Ziffer
            if (v.waitNext) {
                v.display    = lbl;
                v.waitNext   = false;
                v.hasDecimal = false;
            } else {
                if (v.display.equals("0")) {
                    v.display = lbl;
                } else if (v.display.length() < 10) {
                    v.display = v.display + lbl;
                }
            }
        }
    }

    function calculate(v as CalcView) as Void {
        if (v.operator.equals("")) { return; }
        var a = v.operand1;
        var b = v.display.toFloat();
        var result = 0.0f;

        if (v.operator.equals("+")) {
            result = a + b;
        } else if (v.operator.equals("-")) {
            result = a - b;
        } else if (v.operator.equals("*")) {
            result = a * b;
        } else if (v.operator.equals("/")) {
            if (b == 0.0f) {
                v.display  = "Fehler";
                v.operator = "";
                v.waitNext = false;
                return;
            }
            result = a / b;
        }

        // Ergebnis formatieren: ganzzahlig oder mit Dezimalstellen
        var asLong = result.toLong();
        var diff = result - asLong.toFloat();
        if (diff < 0.0f) { diff = diff * -1.0f; }
        if (diff < 0.0001f) {
            v.display = asLong.toString();
        } else {
            // Auf 2 Dezimalstellen runden
            var shifted = result * 100.0f;
            var rounded = shifted.toLong();
            var intPart = asLong.toString();
            var fracLong = rounded - (asLong * 100l);
            if (fracLong < 0l) { fracLong = fracLong * -1l; }
            var frac = fracLong.toString();
            if (frac.length() < 2) { frac = "0" + frac; }
            v.display = intPart + "." + frac;
            if (v.display.length() > 9) {
                v.display = v.display.substring(0, 9) as Lang.String;
            }
        }

        v.operand1 = result;
        v.operator = "";
        v.waitNext = true;
    }

    function onKey(evt as WatchUi.KeyEvent) as Lang.Boolean {
        if (evt.getKey() == WatchUi.KEY_ESC) {
            WatchUi.popView(WatchUi.SLIDE_UP);
        }
        return true;
    }

    function onSwipe(swipeEvent as WatchUi.SwipeEvent) as Lang.Boolean {
        if (swipeEvent.getDirection() == WatchUi.SWIPE_UP) {
            WatchUi.popView(WatchUi.SLIDE_UP);
            return true;
        }
        return false;
    }
}
