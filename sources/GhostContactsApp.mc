import Toybox.Application;
import Toybox.WatchUi;
import Toybox.Lang;

// Globale Farb-Konstanten
const COLOR_BG          = 0x000000;
const COLOR_NEON_PURPLE = 0xCC00FF;
const COLOR_NEON_CYAN   = 0x00FFFF;
const COLOR_GLOW        = 0x9900CC;
const COLOR_TEXT        = 0xFFFFFF;
const COLOR_DIM         = 0x555555;

// Geheimcode – hier ändern!
const SECRET_CODE = "1337";

class GhostContactsApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    function onStart(state) as Void {}

    function onStop(state) as Void {}

    function getInitialView() as [WatchUi.Views] or [WatchUi.Views, WatchUi.InputDelegates] {
        var mv = new MenuView();
        return [mv, new MenuDelegate(mv)];
    }
}

function getApp() as GhostContactsApp {
    return Application.getApp() as GhostContactsApp;
}
