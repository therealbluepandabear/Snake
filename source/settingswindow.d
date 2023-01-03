module settingswindow;

import bindbc.sfml;
import sfmlextensions;
import textbox;
import std.stdio;
import roundrect;

class SettingsWindow {
    this(sfRenderWindow* renderWindow, sfColor backgroundColor, sfColor secondaryColor) {
        _renderWindow = renderWindow;

        _backgroundRect = sfRectangleShape_create();
        _backgroundRect.sfRectangleShape_setSize(renderWindow.sfRenderWindow_getSize().sfVector2uExt_toVector2f());
        _backgroundRect.sfRectangleShape_setPosition(sfVector2fExt_splat(0));
        _backgroundRect.sfRectangleShape_setFillColor(backgroundColor);

        short margin = 24;

        _colorRect = sfRectangleShape_create();
        _colorRect.sfRectangleShape_setFillColor(secondaryColor);
        _colorRect.sfRectangleShape_setSize(sfVector2f(renderWindow.sfRenderWindow_getSize().x, margin * 3));

        _colorTextbox = new Textbox();
        _colorTextbox.setText("Color");
        _colorTextbox.setPosition(sfVector2fExt_splat(margin));

        _colors[0] = sfBlue;
        _colors[1] = sfRed;
        _colors[2] = sfGreen;

        int size = 30;
        foreach (indx, ref RoundRect roundRect; _colorList) {
            roundRect = new RoundRect(8, sfVector2fExt_splat(size), sfVector2f(margin + size * indx + margin * indx, _colorRect.sfRectangleShape_getSize().y + margin), _colors[indx]);
        }
    }

    void render() {
        _renderWindow.sfRenderWindowExt_draw(_backgroundRect);
        _renderWindow.sfRenderWindowExt_draw(_colorRect);
        _colorTextbox.render(_renderWindow);

        foreach (RoundRect roundRect; _colorList) {
            roundRect.render(_renderWindow);
        }
    }

private:
    sfRectangleShape* _backgroundRect;
    sfRenderWindow* _renderWindow;
    sfRectangleShape* _colorRect;
    Textbox _colorTextbox;
    RoundRect[3] _colorList;
    sfColor[3] _colors;
}
