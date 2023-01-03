module settingswindow;

import bindbc.sfml;
import sfmlextensions;
import textbox;
import std.stdio;
import roundrect;
import button;

class SettingsWindow {
    this(sfRenderWindow* renderWindow, sfColor backgroundColor, sfColor secondaryColor, void delegate() onBackButtonClick) {
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
            roundRect = new RoundRect(8, sfVector2fExt_splat(size), sfVector2f(margin + size * indx + margin / 2 * indx, _colorRect.sfRectangleShape_getSize().y + margin), _colors[indx]);
        }

        _backButton = new Button();
        _backButton.setText("Back");
        _backButton.setPosition(sfVector2f(_renderWindow.sfRenderWindow_getSize().x - _backButton.getSize().x - margin, _colorRect.sfRectangleShapeExt_getCenter(_backButton.getSize()).y));
        _backButton.setColor(sfColor_fromRGB(189, 183, 107));
        _backButton.setColorHover(sfColor_fromRGB(166, 159, 74));
        _backButton.setOnButtonClick(onBackButtonClick);
    }

    void update(sfEvent event) {
        _backButton.update(event, _renderWindow);
    }

    void render() {
        _renderWindow.sfRenderWindowExt_draw(_backgroundRect);
        _renderWindow.sfRenderWindowExt_draw(_colorRect);
        _colorTextbox.render(_renderWindow);
        _backButton.render(_renderWindow);
        _colorList.roundRectExt_renderArray(_renderWindow);
    }

private:
    sfRectangleShape* _backgroundRect;
    sfRenderWindow* _renderWindow;
    sfRectangleShape* _colorRect;
    Button _backButton;
    Textbox _colorTextbox;
    RoundRect[3] _colorList;
    sfColor[3] _colors;
}
