import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Timer;

var gEarthView as EarthView? = null;

class EarthView extends WatchUi.View {

    var satAngle as Lang.Number = 0;
    var timer    as Timer.Timer? = null;

    static const COL_OCEAN  as Lang.Number = 0x001833;
    static const COL_LAND   as Lang.Number = 0x00CCFF;
    static const COL_BRIGHT as Lang.Number = 0x00FFFF;
    static const COL_DIM    as Lang.Number = 0x003355;
    static const COL_ORBIT  as Lang.Number = 0x004466;
    static const COL_SAT    as Lang.Number = 0x00FFFF;
    static const COL_PANEL  as Lang.Number = 0x0044AA;
    static const COL_GLOW   as Lang.Number = 0x001122;

    // Küstenpunkte aller Kontinente (orthografische Projektion, Zentrum Europa 15°E 50°N, R=110)
    static const LAND_PTS as Lang.Array<Lang.Array<Lang.Number>> = [
[191,245],[191,243],[192,243],[192,241],[192,239],[193,237],[194,236],[194,235],[195,233],[196,233],[196,231],[197,229],
[198,229],[200,228],[202,228],[202,227],[204,227],[206,226],[208,226],[209,225],[210,225],[211,223],[212,223],[213,221],
[214,221],[216,219],[218,218],[218,217],[220,217],[222,216],[223,215],[224,215],[226,214],[226,213],[228,213],[230,213],
[230,214],[231,216],[232,216],[233,218],[234,218],[236,218],[237,221],[237,222],[238,223],[238,224],[238,226],[239,228],
[239,230],[240,232],[240,234],[241,237],[241,238],[242,240],[242,243],[244,242],[244,244],[243,245],[243,246],[242,248],
[242,250],[241,250],[240,249],[239,249],[238,250],[237,250],[236,249],[235,249],[235,247],[234,245],[233,245],[231,245],
[231,246],[230,243],[230,241],[229,240],[229,239],[229,237],[228,235],[227,234],[226,236],[225,236],[225,238],[223,238],
[223,240],[224,241],[224,242],[225,244],[225,246],[225,248],[223,249],[221,249],[219,248],[218,247],[217,247],[217,245],
[216,243],[215,243],[215,241],[214,239],[213,239],[211,239],[209,238],[207,238],[205,238],[205,237],[203,235],[201,235],
[199,234],[198,236],[197,237],[197,238],[195,240],[194,242],[192,244],[201,223],[202,223],[203,224],[203,221],[204,219],
[206,217],[207,215],[208,215],[209,213],[210,212],[210,211],[212,212],[212,214],[212,216],[211,218],[211,220],[211,222],
[209,223],[207,223],[205,222],[198,218],[198,217],[200,216],[200,215],[202,213],[203,214],[204,214],[204,216],[204,218],
[203,218],[201,219],[216,211],[217,209],[217,207],[217,205],[217,203],[218,203],[219,201],[220,201],[221,202],[222,202],
[222,201],[223,199],[224,199],[226,198],[226,197],[227,195],[227,193],[228,192],[228,191],[229,189],[230,189],[232,189],
[234,188],[234,187],[236,187],[236,188],[237,190],[237,192],[238,193],[238,194],[238,196],[237,197],[237,198],[236,200],
[236,202],[235,203],[235,204],[234,206],[233,207],[233,208],[231,209],[229,209],[229,210],[227,211],[226,212],[225,212],
[223,213],[221,213],[219,213],[217,212],[196,192],[197,191],[198,191],[199,189],[200,189],[200,190],[202,190],[203,192],
[204,193],[204,194],[204,196],[203,196],[201,197],[199,196],[199,195],[197,195],[170,269],[171,267],[172,266],[172,265],
[173,263],[174,261],[176,260],[177,259],[178,259],[180,258],[182,258],[184,258],[185,257],[186,257],[188,256],[189,255],
[190,255],[192,254],[192,253],[194,252],[195,251],[196,251],[198,251],[199,252],[200,252],[202,252],[204,253],[206,253],
[208,253],[208,254],[210,254],[212,254],[212,253],[214,253],[216,252],[218,251],[220,251],[222,251],[224,251],[226,251],
[228,251],[230,251],[232,251],[234,251],[235,252],[236,252],[238,253],[239,254],[240,254],[242,256],[244,256],[246,257],
[246,258],[248,258],[250,259],[250,260],[252,260],[254,261],[255,262],[256,262],[258,263],[260,263],[260,264],[262,265],
[263,266],[264,266],[266,267],[266,268],[268,269],[268,270],[270,271],[270,272],[271,274],[272,275],[272,276],[273,278],
[274,279],[274,280],[275,282],[275,284],[275,286],[276,287],[276,288],[275,289],[275,290],[275,292],[274,294],[273,295],
[273,296],[272,298],[272,300],[271,300],[271,302],[270,304],[269,304],[268,306],[267,307],[267,308],[265,310],[264,312],
[263,312],[262,314],[261,315],[261,316],[259,317],[259,318],[260,319],[260,320],[262,321],[263,322],[264,322],[266,323],
[267,324],[265,325],[265,326],[263,327],[263,328],[261,329],[261,330],[259,330],[257,331],[256,332],[255,332],[253,333],
[251,333],[250,334],[249,334],[247,334],[245,334],[243,334],[241,334],[239,334],[239,333],[237,333],[235,332],[234,331],
[233,331],[231,330],[231,329],[229,328],[229,327],[227,326],[227,325],[225,324],[225,323],[224,321],[223,321],[223,319],
[221,317],[220,315],[219,314],[219,313],[217,311],[216,309],[215,308],[215,307],[214,305],[213,304],[213,303],[211,301],
[210,299],[209,298],[208,297],[207,296],[207,295],[206,293],[205,292],[205,291],[204,289],[203,289],[202,287],[201,286],
[201,285],[200,283],[199,282],[197,283],[195,283],[194,284],[193,284],[191,284],[189,284],[187,284],[186,283],[185,283],
[183,283],[181,282],[180,281],[179,281],[177,280],[175,279],[173,279],[171,278],[171,277],[169,277],[169,275],[169,273],
[170,272],[170,271],[237,197],[238,196],[238,195],[239,193],[240,193],[240,191],[242,190],[244,190],[244,189],[246,188],
[246,187],[247,185],[248,185],[248,183],[249,181],[250,181],[250,179],[251,177],[252,176],[252,175],[253,173],[253,171],
[254,171],[254,169],[254,167],[254,165],[255,163],[256,163],[258,163],[260,162],[261,161],[262,160],[262,159],[264,158],
[264,157],[266,157],[268,157],[270,157],[272,156],[274,157],[275,158],[276,158],[278,159],[278,160],[280,160],[281,162],
[282,162],[284,164],[286,165],[286,166],[288,167],[289,168],[290,169],[291,170],[292,171],[293,172],[294,173],[294,174],
[296,175],[296,176],[296,178],[295,178],[294,180],[293,180],[291,180],[289,181],[287,181],[286,182],[285,182],[283,183],
[281,183],[279,183],[277,183],[275,183],[274,184],[273,184],[271,184],[269,184],[267,184],[265,184],[263,185],[262,186],
[261,186],[259,188],[258,190],[257,191],[257,192],[257,194],[256,196],[256,198],[255,198],[255,200],[254,202],[253,203],
[253,204],[252,206],[251,206],[250,208],[249,208],[247,208],[245,208],[244,207],[243,207],[241,206],[240,205],[240,203],
[239,203],[239,201],[238,199],[237,198],[242,243],[244,242],[246,242],[246,241],[248,240],[249,239],[250,239],[252,239],
[254,238],[256,238],[258,239],[258,240],[260,241],[261,242],[262,242],[264,243],[266,242],[267,241],[268,241],[270,240],
[270,239],[271,237],[272,236],[272,235],[274,235],[276,234],[276,233],[278,233],[280,233],[280,234],[282,234],[284,235],
[286,235],[286,236],[288,236],[288,238],[288,240],[288,242],[287,244],[286,246],[285,247],[285,248],[284,250],[283,250],
[282,252],[281,253],[281,254],[279,256],[279,258],[279,260],[278,262],[277,263],[277,264],[277,266],[276,268],[276,270],
[275,270],[275,272],[274,274],[274,276],[273,277],[273,278],[272,280],[271,282],[271,284],[270,286],[269,286],[269,288],
[268,284],[267,282],[267,281],[267,279],[266,277],[266,275],[265,273],[265,271],[264,269],[264,267],[263,265],[263,263],
[262,261],[261,259],[261,257],[260,255],[260,253],[259,251],[258,249],[257,248],[255,248],[253,249],[253,250],[251,249],
[249,248],[249,247],[247,247],[245,246],[244,248],[243,248],[243,247],[243,245]
    ] as Lang.Array<Lang.Array<Lang.Number>>;

    function initialize() {
        View.initialize();
        gEarthView = self;
    }

    function onShow() as Void {
        timer = new Timer.Timer();
        timer.start(method(:onTick), 80, true);
    }

    function onHide() as Void {
        if (timer != null) { timer.stop(); timer = null; }
        gEarthView = null;
    }

    function onTick() as Void {
        satAngle = (satAngle + 3) % 360;
        WatchUi.requestUpdate();
    }

    function onUpdate(dc as Graphics.Dc) as Void {
        var w  = dc.getWidth();
        var h  = dc.getHeight();
        var cx = w / 2;
        var cy = h / 2;

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();

        // Äußerer Neon-Ring
        dc.setColor(0x001122, Graphics.COLOR_TRANSPARENT);
        dc.drawEllipse(cx, cy, cx - 2, cy - 2);

        // Orbit Hintergrund (hinter Erde)
        drawOrbitBack(dc, cx, cy);

        // Ozean-Kugel
        dc.setColor(COL_OCEAN, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(cx, cy, 112);
        dc.setColor(COL_DIM, Graphics.COLOR_TRANSPARENT);
        dc.drawCircle(cx, cy, 112);
        dc.drawCircle(cx, cy, 110);

        // Küstenlinien als Punkte
        drawContinents(dc);

        // Breitengrad-Linien (gestrichelt, dezent)
        drawLatLines(dc, cx, cy);

        // Satellit vorne
        drawOrbitFront(dc, cx, cy);
        drawSatellite(dc, cx, cy);

        // Titel
        dc.setColor(COL_LAND, Graphics.COLOR_TRANSPARENT);
        dc.drawText(cx, 6, Graphics.FONT_SYSTEM_XTINY, "ORBIT TRACKER", Graphics.TEXT_JUSTIFY_CENTER);
    }

    function drawContinents(dc as Graphics.Dc) as Void {
        var pts = LAND_PTS;
        var n   = pts.size();
        for (var i = 0; i < n; i++) {
            var p  = pts[i] as Lang.Array<Lang.Number>;
            var px = p[0] as Lang.Number;
            var py = p[1] as Lang.Number;
            // Helligkeit: Punkte nahe Zentrum (227,227) heller
            var dx = px - 227;
            var dy = py - 227;
            var d2 = dx * dx + dy * dy;
            if (d2 < 1500) {
                dc.setColor(COL_BRIGHT, Graphics.COLOR_TRANSPARENT);
                dc.fillCircle(px, py, 2);
            } else if (d2 < 5000) {
                dc.setColor(COL_LAND, Graphics.COLOR_TRANSPARENT);
                dc.fillCircle(px, py, 2);
            } else {
                dc.setColor(COL_DIM, Graphics.COLOR_TRANSPARENT);
                dc.fillCircle(px, py, 1);
            }
        }
    }

    function drawLatLines(dc as Graphics.Dc, cx as Lang.Number, cy as Lang.Number) as Void {
        // Äquator
        dc.setColor(0x002244, Graphics.COLOR_TRANSPARENT);
        dc.drawEllipse(cx, cy, 110, 110);
        // Wendekreis N (~23°) und S, Polarkreis (~66°)
        // Ellipsen-Radien berechnet für orthografische Projektion (Zentrum 50°N)
        // Nur dekorativer Hinweis
        dc.setColor(0x001833, Graphics.COLOR_TRANSPARENT);
        dc.drawEllipse(cx, cy - 40, 101, 60);  // ~30°N Ring
        dc.drawEllipse(cx, cy + 30, 95, 50);   // ~30°S Ring
    }

    function sinApp(deg as Lang.Number) as Lang.Number {
        deg = ((deg % 360) + 360) % 360;
        if (deg == 0 || deg == 180) { return 0; }
        if (deg == 90)  { return 1000; }
        if (deg == 270) { return -1000; }
        var q = deg / 90;
        var r = deg % 90;
        if (q == 0) { return r * 1000 / 90; }
        if (q == 1) { return 1000 - r * 1000 / 90; }
        if (q == 2) { return -(r * 1000 / 90); }
        return -(1000 - r * 1000 / 90);
    }

    function cosApp(deg as Lang.Number) as Lang.Number {
        return sinApp((deg + 90) % 360);
    }

    function drawOrbitBack(dc as Graphics.Dc, cx as Lang.Number, cy as Lang.Number) as Void {
        dc.setColor(COL_ORBIT, Graphics.COLOR_TRANSPARENT);
        var orx = 160;
        var ory = 78;
        for (var a = 100; a <= 260; a += 4) {
            var c  = cosApp(a);
            var s  = sinApp(a);
            var x  = cx + orx * c / 1000;
            var tilt = -(orx * c / 1000) * 18 / 100;
            var y  = cy + ory * s / 1000 + tilt;
            if (a % 8 < 4) {
                dc.fillCircle(x, y, 1);
            }
        }
    }

    function drawOrbitFront(dc as Graphics.Dc, cx as Lang.Number, cy as Lang.Number) as Void {
        dc.setColor(COL_SAT, Graphics.COLOR_TRANSPARENT);
        var orx = 160;
        var ory = 78;
        for (var a = -80; a <= 80; a += 3) {
            var an = (a + 360) % 360;
            var c  = cosApp(an);
            var s  = sinApp(an);
            var x  = cx + orx * c / 1000;
            var tilt = -(orx * c / 1000) * 18 / 100;
            var y  = cy + ory * s / 1000 + tilt;
            dc.fillCircle(x, y, 1);
        }
    }

    function drawSatellite(dc as Graphics.Dc, cx as Lang.Number, cy as Lang.Number) as Void {
        var behind = (satAngle > 98 && satAngle < 262);
        if (behind) { return; }

        var orx  = 160;
        var ory  = 78;
        var c    = cosApp(satAngle);
        var s    = sinApp(satAngle);
        var sx   = cx + orx * c / 1000;
        var tilt = -(orx * c / 1000) * 18 / 100;
        var sy   = cy + ory * s / 1000 + tilt;

        // Body
        dc.setColor(COL_SAT, Graphics.COLOR_TRANSPARENT);
        dc.fillRoundedRectangle(sx - 5, sy - 4, 10, 8, 2);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawRoundedRectangle(sx - 5, sy - 4, 10, 8, 2);

        // Solar Panels
        dc.setColor(COL_PANEL, Graphics.COLOR_TRANSPARENT);
        dc.fillRectangle(sx - 17, sy - 2, 11, 5);
        dc.fillRectangle(sx + 6,  sy - 2, 11, 5);
        dc.setColor(COL_SAT, Graphics.COLOR_TRANSPARENT);
        dc.drawRectangle(sx - 17, sy - 2, 11, 5);
        dc.drawRectangle(sx + 6,  sy - 2, 11, 5);
        dc.drawLine(sx - 6, sy, sx - 17, sy);
        dc.drawLine(sx + 6, sy, sx + 17, sy);

        // Antenne
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawLine(sx, sy - 4, sx - 3, sy - 9);
        dc.fillCircle(sx - 3, sy - 9, 2);
    }
}

class EarthDelegate extends WatchUi.InputDelegate {

    function initialize() {
        InputDelegate.initialize();
    }

    function onTap(clickEvent as WatchUi.ClickEvent) as Lang.Boolean {
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
        return true;
    }

    function onSwipe(swipeEvent as WatchUi.SwipeEvent) as Lang.Boolean {
        if (swipeEvent.getDirection() == WatchUi.SWIPE_RIGHT) {
            WatchUi.popView(WatchUi.SLIDE_RIGHT);
            return true;
        }
        return false;
    }

    function onKey(evt as WatchUi.KeyEvent) as Lang.Boolean {
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
        return true;
    }
}
