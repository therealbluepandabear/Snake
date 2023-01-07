module theme;

import sfmlextensions;
import bindbc.sfml;
import std.stdio;

private interface ITheme {
    sfColor primaryBackground();
    sfColor secondaryBackground();
    sfColor buttonBackground();
    sfColor buttonHoverBackground();
}

class Theme {
    shared static this() {
        _currentTheme = new RedTheme();
    }

    @property static {
        ITheme currentTheme() {
            return _currentTheme;
        }
    }

    private static {
        ITheme _currentTheme;
    }
}

private class GreenTheme : ITheme {
    override {
        sfColor primaryBackground() {
            return sfColor_fromRGB(189, 183, 107);
        }

        sfColor secondaryBackground() {
            return sfColor_fromRGB(64, 190, 92);
        }

        sfColor buttonBackground() {
            return sfColor_fromRGB(189, 183, 107);
        }

        sfColor buttonHoverBackground() {
            return sfColor_fromRGB(166, 159, 74);
        }
    }
}

private class RedTheme : ITheme {
    override {
        sfColor primaryBackground() {
            return sfColor_fromRGB(232, 93, 4);
        }

        sfColor secondaryBackground() {
            return sfColor_fromRGB(220, 47, 2);
        }

        sfColor buttonBackground() {
            return sfColor_fromRGB(188, 57, 8);
        }

        sfColor buttonHoverBackground() {
            return sfColor_fromRGB(157, 2, 8);
        }
    }
}
