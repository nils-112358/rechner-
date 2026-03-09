import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Lang;

class HiddenView extends WatchUi.View {

    function initialize() {
        View.initialize();
    }

    function onUpdate(dc as Graphics.Dc) as Void {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();

        var img = WatchUi.loadResource(Rez.Drawables.HiddenImage) as Graphics.BitmapResource;
        var iw  = img.getWidth()  as Lang.Number;
        var ih  = img.getHeight() as Lang.Number;
        var sw  = dc.getWidth()   as Lang.Number;
        var sh  = dc.getHeight()  as Lang.Number;

        // Bild passt genau? Direkt zeichnen
        if (iw == sw && ih == sh) {
            dc.drawBitmap(0, 0, img);
            return;
        }

        // Skalierungsfaktor berechnen (Seitenverhältnis beibehalten)
        // Multipliziert mit 1000 um Integer-Arithmetik zu nutzen
        var scaleW = sw * 1000 / iw;
        var scaleH = sh * 1000 / ih;
        var scale  = scaleW < scaleH ? scaleW : scaleH;  // kleinerer Wert = passt rein

        // Zielgröße
        var dw = iw * scale / 1000;
        var dh = ih * scale / 1000;

        // Zentriert
        var ox = (sw - dw) / 2;
        var oy = (sh - dh) / 2;

        // AffineTransform für Skalierung (verfügbar ab API 3.2.0)
        var transform = new Graphics.AffineTransform();

        // Skalierung als Float: scale/1000
        var sf = scale.toFloat() / 1000.0f;
        transform.setMatrix([sf, 0.0f, ox.toFloat(),
                             0.0f, sf, oy.toFloat()] as Lang.Array<Lang.Float>);

        dc.drawBitmap2(0, 0, img, {
            :transform   => transform,
            :filterMode  => Graphics.FILTER_MODE_BILINEAR
        });
    }
}

class HiddenDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onTap(clickEvent as WatchUi.ClickEvent) as Lang.Boolean {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        return true;
    }

    function onSwipe(swipeEvent as WatchUi.SwipeEvent) as Lang.Boolean {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        return true;
    }

    function onKey(evt as WatchUi.KeyEvent) as Lang.Boolean {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        return true;
    }
}
