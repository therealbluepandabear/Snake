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
import gameconfig;
import theme;
import std.random;
import stacklayout;

private int margin = 24;

private class SettingsHeader {
    this(sfRenderWindow* renderWindow, string title, sfVector2f position) {
        _renderWindow = renderWindow;
        _title = title;
        _position = position;

        _headerRectangle = sfRectangleShape_create();
        _headerRectangle.sfRectangleShape_setFillColor(Theme.currentTheme.secondaryBackground());
        _headerRectangle.sfRectangleShape_setSize(sfVector2f(renderWindow.sfRenderWindow_getSize().x, margin * 3));
        _headerRectangle.sfRectangleShape_setPosition(position);

        _headerTextbox = new Textbox();
        _headerTextbox.text = title;
        _headerTextbox.position = sfVector2f(position.x + margin, position.y + margin);
    }

    void render() {
        _renderWindow.sfRenderWindowExt_draw(_headerRectangle);
        _renderWindow.sfRenderWindowExt_draw(_headerTextbox);
    }

    @property {
        sfRectangleShape* headerRectangle() {
            return _headerRectangle;
        }
    }

    private {
        sfRenderWindow* _renderWindow;
        string _title;
        sfVector2f _position;
        sfRectangleShape* _headerRectangle;
        Textbox _headerTextbox;
    }
}

class SettingsWindow {
    this(sfRenderWindow* renderWindow, SettingsWindow.EventHandler eventHandler) {
        _renderWindow = renderWindow;

        _backgroundRect = sfRectangleShape_create();
        _backgroundRect.sfRectangleShape_setSize(renderWindow.sfRenderWindow_getSize().sfVector2uExt_toVector2f());
        _backgroundRect.sfRectangleShape_setPosition(sfVector2fExt_splat(0));
        _backgroundRect.sfRectangleShape_setFillColor(Theme.currentTheme.primaryBackground());

        _boardSizeSettingsHeader = new SettingsHeader(renderWindow, "Board Size", sfVector2fExt_splat(0));

        _backButton = new Button();
        _backButton.text = "Back";
        _backButton.position = sfVector2f(_backgroundRect.sfRectangleShape_getSize().x - _backButton.size.x - margin, _boardSizeSettingsHeader.headerRectangle.sfRectangleShapeExt_getCenter(_backButton.size).y);
        _backButton.onButtonClick = &(eventHandler.settingsWindow_onBackButtonClick);

        _boardSizeRow = new StackLayout!Button(StackLayoutType.row, sfVector2f(margin, _boardSizeSettingsHeader.headerRectangle.sfRectangleShape_getSize().y + margin), margin);

        foreach (BoardSize boardSize; cast(BoardSize[])[EnumMembers!BoardSize]) {
            Button b = new Button();
            b.text = format("%sx%s", boardSize[0], boardSize[1]);
            b.onButtonClick = (BoardSize iteration_boardSize) {
                return {
                    eventHandler.settingsWindow_onBoardSizeButtonClick(iteration_boardSize);
                };
            } (boardSize);
            _boardSizeRow.addChild(b);
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
        _boardSizeSettingsHeader.render();
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
        Button _backButton;
        SettingsHeader _boardSizeSettingsHeader;
        StackLayout!Button _boardSizeRow;
    }
}
