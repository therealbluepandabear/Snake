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
import row;

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
        _boardSizeTextbox.text = "Board Size";
        _boardSizeTextbox.position = sfVector2fExt_splat(margin);

        _backButton = new Button();
        _backButton.text = "Back";
        _backButton.position = sfVector2f(_renderWindow.sfRenderWindow_getSize().x - _backButton.size.x - margin, _colorRect.sfRectangleShapeExt_getCenter(_backButton.size).y);
        _backButton.color = sfColor_fromRGB(189, 183, 107);
        _backButton.colorHover = sfColor_fromRGB(166, 159, 74);
        _backButton.onButtonClick = onBackButtonClick;

        const(BoardSize[]) arr = cast(BoardSize[])[EnumMembers!BoardSize];
        _boardSizeRow = new Row!(Button)(sfVector2f(margin, _colorRect.sfRectangleShape_getPosition().y + _colorRect.sfRectangleShape_getSize().y + margin));

        foreach (indx; 0..arr.length) {
            Button button = new Button();
            button.text = format("%sx%s", arr[indx][0], arr[indx][1]);
            button.colorHover = sfColor_fromRGB(166, 159, 74);
            button.onButtonClick = onBoardSizeButtonClick;
            _boardSizeRow.addChild(button);
        }
    }

    void update(sfEvent event) {
        _backButton.update(event, _renderWindow);

        foreach (Button button; _boardSizeRow.children) {
            button.update(event, _renderWindow);
        }
    }

    void render() {
        _renderWindow.sfRenderWindowExt_draw(_backgroundRect);
        _renderWindow.sfRenderWindowExt_draw(_colorRect);
        _renderWindow.sfRenderWindowExt_draw(_boardSizeTextbox);
        _renderWindow.sfRenderWindowExt_draw(_backButton);
        _boardSizeRow.render(_renderWindow);
    }

    private {
        sfRectangleShape* _backgroundRect;
        sfRenderWindow* _renderWindow;
        sfRectangleShape* _colorRect;
        Button _backButton;
        Textbox _boardSizeTextbox;
        Row!(Button) _boardSizeRow;
    }
}
