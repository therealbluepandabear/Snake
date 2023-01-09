module theme;

import sfmlextensions;
import bindbc.sfml;
import std.stdio;
import std.typecons;

interface ITheme {
    @property {
        sfColor iconColor();
    }
    sfColor primaryBackground();
    sfColor secondaryBackground();
    sfColor buttonBackground();
    sfColor buttonHoverBackground();
}

interface IThemeable {
    void onThemeChanged();
}

class Theme {
    shared static this() {
        _themes[0] = new RedTheme();
        _themes[1] = new GreenTheme();
        _currentTheme = _themes[0];
    }

    @property static {
        ITheme currentTheme() {
            return _currentTheme;
        }

        ITheme[2] themes() {
            return _themes;
        }

        void currentTheme(ITheme currentTheme) {
            _currentTheme = currentTheme;

            foreach (IThemeable themeable; _themeables) {
                themeable.onThemeChanged();
            }
        }
    }

    static {
        void themeables(IThemeable[] themeables) {
            _themeables = themeables;
        }
    }

    private static {
        ITheme _currentTheme;
        ITheme[2] _themes;
        IThemeable[] _themeables;
    }
}

class GreenTheme : ITheme {
    @property override {
        sfColor iconColor() {
            return sfGreen;
        }
    }

    override {
        sfColor primaryBackground() {
            return sfColor_fromRGB(5, 157, 0);
        }

        sfColor secondaryBackground() {
            return sfColor_fromRGB(4, 128, 0);
        }

        sfColor buttonBackground() {
            return sfColor_fromRGB(3, 99, 0);
        }

        sfColor buttonHoverBackground() {
            return sfColor_fromRGB(3, 81, 0);
        }
    }
}

class RedTheme : ITheme {
    @property override {
        sfColor iconColor() {
            return sfRed;
        }
    }

    override {
        sfColor primaryBackground() {
            return sfColor_fromRGB(216, 0, 0);
        }

        sfColor secondaryBackground() {
            return sfColor_fromRGB(189, 0, 0);
        }

        sfColor buttonBackground() {
            return sfColor_fromRGB(162, 0, 0);
        }

        sfColor buttonHoverBackground() {
            return sfColor_fromRGB(138, 0, 0);
        }
    }
}
