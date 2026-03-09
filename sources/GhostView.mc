import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Lang;

class GhostView extends WatchUi.View {

    function initialize() {
        View.initialize();
    }

    function onUpdate(dc as Graphics.Dc) as Void {
        var w  = dc.getWidth();
        var h  = dc.getHeight();
        var cx = w / 2;

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();

        drawHacker(dc, cx, w, h);

        dc.setColor(0x660099, Graphics.COLOR_TRANSPARENT);
        dc.drawText(cx, h - 18, Graphics.FONT_SYSTEM_XTINY, "WE ARE ANONYMOUS", Graphics.TEXT_JUSTIFY_CENTER);
    }

    // Skaliert 612→454
    function s(v as Lang.Number) as Lang.Number {
        return (v * 454) / 612;
    }

    function drawHacker(dc as Graphics.Dc, cx as Lang.Number, w as Lang.Number, h as Lang.Number) as Void {

        // =====================
        // KAPUZE – gefüllt
        // =====================
        dc.setColor(0x444444, Graphics.COLOR_TRANSPARENT);
        // Kapuze mit horizontalen Linien füllen (links/rechts Konturen aus Pixel-Analyse)
        // Format: [y, x_links, x_rechts]
        var kapuze = [
            [92,  289, 322], [96,  277, 334], [100, 269, 342],
            [104, 262, 349], [108, 256, 354], [112, 247, 364],
            [116, 243, 367], [120, 240, 371], [124, 236, 374],
            [128, 233, 377], [132, 231, 380], [136, 228, 383],
            [140, 225, 385], [144, 223, 388], [148, 221, 390],
            [152, 219, 392], [156, 217, 394], [160, 216, 395],
            [164, 214, 397], [168, 213, 398], [172, 211, 400],
            [176, 210, 401], [180, 208, 403], [184, 207, 404],
            [188, 206, 405], [192, 205, 406], [196, 204, 407],
            [200, 204, 407], [204, 204, 408], [208, 204, 408],
            [212, 204, 408], [216, 204, 408], [220, 203, 408]
        ] as Lang.Array;

        for (var i = 0; i < kapuze.size(); i++) {
            var row = kapuze[i] as Lang.Array;
            var y  = s(row[0] as Lang.Number);
            var x1 = s(row[1] as Lang.Number);
            var x2 = s(row[2] as Lang.Number);
            dc.drawLine(x1, y, x2, y);
        }

        // Kapuze Außenkontur
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        var kl = [[289,92],[247,116],[228,140],[213,172],[210,200],[204,212],[204,220]] as Lang.Array;
        var kr = [[322,92],[364,116],[383,140],[398,172],[406,200],[407,212],[408,220]] as Lang.Array;
        for (var i = 0; i < kl.size()-1; i++) {
            var a = kl[i]   as Lang.Array;
            var b = kl[i+1] as Lang.Array;
            dc.drawLine(s(a[0] as Lang.Number), s(a[1] as Lang.Number), s(b[0] as Lang.Number), s(b[1] as Lang.Number));
            var c = kr[i]   as Lang.Array;
            var d = kr[i+1] as Lang.Array;
            dc.drawLine(s(c[0] as Lang.Number), s(c[1] as Lang.Number), s(d[0] as Lang.Number), s(d[1] as Lang.Number));
        }

        // Innere Kapuzenkontur
        dc.drawLine(s(256), s(108), s(233), s(132));
        dc.drawLine(s(233), s(132), s(214), s(168));
        dc.drawLine(s(214), s(168), s(207), s(196));
        dc.drawLine(s(207), s(196), s(204), s(220));
        dc.drawLine(s(354), s(108), s(377), s(132));
        dc.drawLine(s(377), s(132), s(395), s(168));
        dc.drawLine(s(395), s(168), s(403), s(196));
        dc.drawLine(s(403), s(196), s(408), s(220));

        // Kapuzen-Innenbogen
        dc.drawEllipse(s(305), s(176), s(36), s(42));

        // =====================
        // GESICHT
        // =====================
        dc.setColor(0x999999, Graphics.COLOR_TRANSPARENT);
        dc.fillEllipse(s(305), s(270), s(100), s(90));
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawEllipse(s(305), s(270), s(100), s(90));
        dc.drawEllipse(s(305), s(270), s(99),  s(89));

        // =====================
        // AUGENMASKE
        // =====================
        dc.setColor(0x111111, Graphics.COLOR_TRANSPARENT);
        // Maske füllen
        var maske = [
            [208,204,407],[212,204,407],[216,204,407],[220,203,408],
            [224,203,408],[228,203,408],[232,204,407],[236,204,407],
            [240,205,406],[244,206,405],[248,207,404],[252,208,403],
            [256,210,401],[260,211,400],[264,213,398],[268,215,396],
            [272,218,393],[276,205,406],[280,199,412]
        ] as Lang.Array;
        for (var i = 0; i < maske.size(); i++) {
            var row = maske[i] as Lang.Array;
            dc.drawLine(s(row[1] as Lang.Number), s(row[0] as Lang.Number),
                        s(row[2] as Lang.Number), s(row[0] as Lang.Number));
        }
        // Masken-Kontur
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawRoundedRectangle(s(200), s(207), s(212), s(76), s(18));
        dc.drawRoundedRectangle(s(201), s(208), s(210), s(74), s(17));

        // Augen-Öffnungen
        dc.setColor(0x888888, Graphics.COLOR_TRANSPARENT);
        dc.fillEllipse(s(252), s(244), s(36), s(20));
        dc.fillEllipse(s(360), s(244), s(36), s(20));
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawEllipse(s(252), s(244), s(36), s(20));
        dc.drawEllipse(s(360), s(244), s(36), s(20));

        // =====================
        // MUND
        // =====================
        dc.setColor(0x222222, Graphics.COLOR_TRANSPARENT);
        dc.fillRoundedRectangle(s(268), s(294), s(78), s(20), s(8));
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawRoundedRectangle(s(268), s(294), s(78), s(20), s(8));

        // =====================
        // SCHULTERN / ARME
        // =====================
        dc.setColor(0x444444, Graphics.COLOR_TRANSPARENT);
        // Linke Schulter/Arm
        var arm_l = [
            [300,177],[308,170],[316,165],[324,162],[332,159],
            [340,156],[348,154],[356,151],[364,148],[372,146],
            [380,143],[388,140],[396,138],[404,137],[412,137],
            [420,138],[428,140],[436,144],[442,148]
        ] as Lang.Array;
        for (var i = 0; i < arm_l.size()-1; i++) {
            var a = arm_l[i]   as Lang.Array;
            var b = arm_l[i+1] as Lang.Array;
            // Füllung: von linker Kontur bis Mitte (Laptop-Rand)
            var y1 = s(a[0] as Lang.Number);
            var y2 = s(b[0] as Lang.Number);
            var lx1 = s(a[1] as Lang.Number);
            var lx2 = s(b[1] as Lang.Number);
            for (var y = y1; y <= y2; y++) {
                var t  = (y2 > y1) ? (y - y1) * 100 / (y2 - y1) : 0;
                var lx = lx1 + (lx2 - lx1) * t / 100;
                dc.drawLine(lx, y, s(190), y);
            }
        }
        // Rechte Schulter/Arm (gespiegelt)
        var arm_r = [
            [300,434],[308,441],[316,446],[324,449],[332,452],
            [340,455],[348,457],[356,460],[364,463],[372,465],
            [380,468],[388,471],[396,473],[404,474],[412,474],
            [420,473],[428,471],[436,467],[442,463]
        ] as Lang.Array;
        for (var i = 0; i < arm_r.size()-1; i++) {
            var a = arm_r[i]   as Lang.Array;
            var b = arm_r[i+1] as Lang.Array;
            var y1 = s(a[0] as Lang.Number);
            var y2 = s(b[0] as Lang.Number);
            var rx1 = s(a[1] as Lang.Number);
            var rx2 = s(b[1] as Lang.Number);
            for (var y = y1; y <= y2; y++) {
                var t  = (y2 > y1) ? (y - y1) * 100 / (y2 - y1) : 0;
                var rx = rx1 + (rx2 - rx1) * t / 100;
                dc.drawLine(s(421), y, rx, y);
            }
        }

        // Arm-Konturen weiß
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        for (var i = 0; i < arm_l.size()-1; i++) {
            var a = arm_l[i]   as Lang.Array;
            var b = arm_l[i+1] as Lang.Array;
            dc.drawLine(s(a[1] as Lang.Number), s(a[0] as Lang.Number),
                        s(b[1] as Lang.Number), s(b[0] as Lang.Number));
        }
        for (var i = 0; i < arm_r.size()-1; i++) {
            var a = arm_r[i]   as Lang.Array;
            var b = arm_r[i+1] as Lang.Array;
            dc.drawLine(s(a[1] as Lang.Number), s(a[0] as Lang.Number),
                        s(b[1] as Lang.Number), s(b[0] as Lang.Number));
        }

        // =====================
        // LAPTOP DECKEL
        // =====================
        dc.setColor(0x444444, Graphics.COLOR_TRANSPARENT);
        for (var y = s(352); y <= s(440); y++) {
            dc.drawLine(s(192), y, s(420), y);
        }
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawRoundedRectangle(s(192), s(350), s(228), s(92), s(6));
        dc.drawRoundedRectangle(s(193), s(351), s(226), s(90), s(6));
        // Deckel-Oberlinie Reflex
        dc.setColor(0x777777, Graphics.COLOR_TRANSPARENT);
        dc.drawLine(s(200), s(358), s(410), s(358));

        // Scharnier-Linie
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawLine(s(149), s(442), s(463), s(442));
        dc.drawLine(s(149), s(443), s(463), s(443));

        // =====================
        // LAPTOP UNTERTEIL
        // =====================
        dc.setColor(0x444444, Graphics.COLOR_TRANSPARENT);
        var laptop_ut = [
            [442,149,463],[448,153,458],[454,160,451],
            [460,171,440],[466,183,428],[472,194,417],
            [478,199,412],[484,200,411],[490,203,408],
            [496,205,406],[502,203,408],[508,200,411],
            [514,201,410],[520,207,404]
        ] as Lang.Array;
        for (var i = 0; i < laptop_ut.size(); i++) {
            var row = laptop_ut[i] as Lang.Array;
            dc.drawLine(s(row[1] as Lang.Number), s(row[0] as Lang.Number),
                        s(row[2] as Lang.Number), s(row[0] as Lang.Number));
        }
        // Unterteil Kontur
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawLine(s(149), s(442), s(149+8),  s(520));
        dc.drawLine(s(463), s(442), s(463-8),  s(520));
        dc.drawLine(s(157), s(520), s(455), s(520));

        // Laptop-Logo Kreis
        dc.setColor(0x777777, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(s(305), s(412), s(13));
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawCircle(s(305), s(412), s(13));
        dc.drawCircle(s(305), s(412), s(12));
    }
}

class GhostDelegate extends WatchUi.InputDelegate {

    function initialize() {
        InputDelegate.initialize();
    }

    function onTap(clickEvent as WatchUi.ClickEvent) as Lang.Boolean {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        return true;
    }

    function onKey(evt as WatchUi.KeyEvent) as Lang.Boolean {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        return true;
    }
}
