module settingswindow;

import bindbc.sfml;
import sfmlextensions;
import textbox;
import std.stdio;
import shapes;
import button;
import std.typecons;
import std.traits;
import std.string;
import gamesettings;

class SettingsWindow {
    this(sfRenderWindow* renderWindow, sfColor backgroundColor, sfColor secondaryColor, void delegate() onBackButtonClick, void delegate() onBoardSizeButtonClick) {
        _renderWindow = renderWindow;

        _backgroundRect = sfRectangleShape_create();
        _backgroundRect.sfRectangleShape_setSize(renderWindow.sfRenderWindow_getSize().sfVector2uExt_toVector2f());
        _backgroundRect.sfRectangleShape_setPosition(sfVector2fExt_splat(0));
        _backgroundRect.sfRectangleShape_setFillColor(backgroundColor);

        short margin = 24;

        _colorRect = sfRectangleShape_create();
        _colorRect.sfRectangleShape_setFillColor(secondaryColor);
        _colorRect.sfRectangleShape_setSize(sfVector2f(renderWindow.sfRenderWindow_getSize().x, margin * 3));

        _boardSizeTextbox = new Textbox();
        _boardSizeTextbox.setText("Board Size");
        _boardSizeTextbox.setPosition(sfVector2fExt_splat(margin));

        _backButton = new Button();
        _backButton.setText("Back");
        _backButton.setPosition(sfVector2f(_renderWindow.sfRenderWindow_getSize().x - _backButton.getSize().x - margin, _colorRect.sfRectangleShapeExt_getCenter(_backButton.getSize()).y));
        _backButton.setColor(sfColor_fromRGB(189, 183, 107));
        _backButton.setColorHover(sfColor_fromRGB(166, 159, 74));
        _backButton.setOnButtonClick(onBackButtonClick);

        BoardSize[] arr = cast(BoardSize[])[EnumMembers!BoardSize];

        foreach (indx, ref Button button; _boardSizeButtons) {
            button = new Button();
            button.setText(format("%sx%s", arr[indx][0], arr[indx][1]));
            button.setPosition(sfVector2f(margin + button.getSize().x * indx + margin * indx, _colorRect.sfRectangleShape_getPosition().y + _colorRect.sfRectangleShape_getSize().y + margin));
            button.setColor(secondaryColor);
            button.setColorHover(sfColor_fromRGB(166, 159, 74));
            button.setOnButtonClick(onBoardSizeButtonClick);
        }
    }

    void update(sfEvent event) {
        _backButton.update(event, _renderWindow);

        foreach (Button button; _boardSizeButtons) {
            button.update(event, _renderWindow);
        }
    }

    void render() {
        _renderWindow.sfRenderWindowExt_draw(_backgroundRect);
        _renderWindow.sfRenderWindowExt_draw(_colorRect);
        _boardSizeTextbox.render(_renderWindow);
        _backButton.render(_renderWindow);

        foreach (Button button; _boardSizeButtons) {
            button.render(_renderWindow);
        }
    }

private:
    sfRectangleShape* _backgroundRect;
    sfRenderWindow* _renderWindow;
    sfRectangleShape* _colorRect;
    Button _backButton;
    Textbox _boardSizeTextbox;
    Button[3] _boardSizeButtons;
}
