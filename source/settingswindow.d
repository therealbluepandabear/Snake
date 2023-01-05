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
import theme;
import std.random;

class SettingsWindow {
    this(sfRenderWindow* renderWindow, SettingsWindow.EventHandler eventHandler) {
        _renderWindow = renderWindow;

        _backgroundRect = sfRectangleShape_create();
        _backgroundRect.sfRectangleShape_setSize(renderWindow.sfRenderWindow_getSize().sfVector2uExt_toVector2f());
        _backgroundRect.sfRectangleShape_setPosition(sfVector2fExt_splat(0));
        _backgroundRect.sfRectangleShape_setFillColor(Theme.primaryBackground);

        int margin = 24;

        _colorRect = sfRectangleShape_create();
        _colorRect.sfRectangleShape_setFillColor(Theme.secondaryBackground);
        _colorRect.sfRectangleShape_setSize(sfVector2f(_backgroundRect.sfRectangleShape_getSize().x, margin * 3));

        _boardSizeTextbox = new Textbox();
        _boardSizeTextbox.text = "Board Size";
        _boardSizeTextbox.position = sfVector2fExt_splat(margin);

        _backButton = new Button();
        _backButton.text = "Back";
        _backButton.position = sfVector2f(_backgroundRect.sfRectangleShape_getSize().x - _backButton.size.x - margin, _colorRect.sfRectangleShapeExt_getCenter(_backButton.size).y);
        _backButton.onButtonClick = &(eventHandler.settingsWindow_onBackButtonClick);

        const(BoardSize[]) arr = cast(BoardSize[])[EnumMembers!BoardSize];
        _boardSizeRow = new Row!(Button)(sfVector2f(margin, _colorRect.sfRectangleShape_getPosition().y + _colorRect.sfRectangleShape_getSize().y + margin));

        Button[3] b;

        static foreach (indx, BoardSize boardSize; arr) {
            b[indx] = new Button();
            b[indx].text = format("%sx%s", boardSize[0], boardSize[1]);
            b[indx].onButtonClick = {
                eventHandler.settingsWindow_onBoardSizeButtonClick(boardSize);
            };
            _boardSizeRow.addChild(b[indx]);
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

    interface EventHandler {
        void settingsWindow_onBackButtonClick();
        void settingsWindow_onBoardSizeButtonClick(BoardSize boardSize);
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
