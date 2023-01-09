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
import customdrawable;
import std.conv;
import std.exception;
import clickable;

private int margin = 24;

private class SettingsHeader : ICustomDrawable {
    this(float width, string title, sfVector2f position) {
        _title = title;
        _position = position;
        _size = sfVector2f(width, margin * 3);

        _headerRectangle = sfRectangleShape_create();
        _headerRectangle.sfRectangleShape_setFillColor(Theme.currentTheme.secondaryBackground());
        _headerRectangle.sfRectangleShape_setSize(_size);
        _headerRectangle.sfRectangleShape_setPosition(position);

        _headerTextbox = new Textbox();
        _headerTextbox.text = title;
        _headerTextbox.position = sfVector2f(position.x + margin, position.y + margin);
    }

    override void render(sfRenderWindow* renderWindow) {
        renderWindow.sfRenderWindowExt_draw(_headerRectangle);
        renderWindow.sfRenderWindowExt_draw(_headerTextbox);
    }

    @property override {
        sfVector2f size() {
            return _size;
        }

        sfVector2f position() {
            return _position;
        }

        void position(sfVector2f position) {

        }
    }

    @property {
        sfRectangleShape* headerRectangle() {
            return _headerRectangle;
        }
    }

    private {
        string _title;
        sfVector2f _position;
        sfRectangleShape* _headerRectangle;
        Textbox _headerTextbox;
        sfVector2f _size;
    }
}

class SettingsWindow {
    this(sfRenderWindow* renderWindow, SettingsWindow.EventHandler eventHandler) {
        _renderWindow = renderWindow;

        _backgroundRect = sfRectangleShape_create();
        _backgroundRect.sfRectangleShape_setSize(renderWindow.sfRenderWindow_getSize().sfVector2uExt_toVector2f());
        _backgroundRect.sfRectangleShape_setPosition(sfVector2fExt_splat(0));
        _backgroundRect.sfRectangleShape_setFillColor(Theme.currentTheme.primaryBackground());

        _settingsHeaders[0] = new SettingsHeader(renderWindow.sfRenderWindow_getSize().x, "Board Size", sfVector2fExt_splat(0));

        _backButton = new Button();
        _backButton.text = "Back";
        _backButton.position = sfVector2f(_backgroundRect.sfRectangleShape_getSize().x - _backButton.size.x - margin, _settingsHeaders[0].headerRectangle.sfRectangleShapeExt_getCenter(_backButton.size).y);
        _backButton.onButtonClick = &(eventHandler.settingsWindow_onBackButtonClick);

        float _boardSizeRowPositionY = _settingsHeaders[0].headerRectangle.sfRectangleShape_getSize().y + margin;
        _boardSizeRow = new StackLayout(StackLayoutType.row, sfVector2f(margin, _boardSizeRowPositionY), margin / 2);

        foreach (BoardSize boardSizeIter; EnumMembers!BoardSize) (BoardSize boardSize) {
            Button button = new Button();
            button.text = format("%sx%s", boardSize[0], boardSize[1]);
            button.onButtonClick = {
                eventHandler.settingsWindow_onBoardSizeButtonClick(boardSize);
            };
            _boardSizeRow.addChild(button);
        } (boardSizeIter);

        float _themeHeaderPositionY = _boardSizeRowPositionY + _boardSizeRow.size.y + margin * 2;
        _settingsHeaders[1] = new SettingsHeader(renderWindow.sfRenderWindow_getSize().x, "Theme", sfVector2f(0, _themeHeaderPositionY));

        float _themeRowPosY = _themeHeaderPositionY + _settingsHeaders[1].size.y + margin;
        _themeRow = new StackLayout(StackLayoutType.row, sfVector2f(margin, _themeRowPosY), margin / 2);

        foreach (ColorTheme colorThemeIter; cast(ColorTheme[])[EnumMembers!ColorTheme]) (ColorTheme colorTheme) {
            RoundRect roundRect = new RoundRect(8, sfVector2fExt_splat(30), sfVector2f(margin, _themeRowPosY), colorTheme);
            _themeRow.addChild(new Clickable(roundRect, { writeln("Hi"); stdout.flush(); }));
        } (colorThemeIter);
    }

    void update(sfEvent event) {
        assertNotThrown!ConvException(to!(Button[])(_boardSizeRow.children));
        assertNotThrown!ConvException(to!(Clickable[])(_themeRow.children));

        _backButton.update(event, _renderWindow);
        foreach (Button button; to!(Button[])(_boardSizeRow.children)) {
            button.update(event, _renderWindow);
        }
        foreach (Clickable clickable; to!(Clickable[])(_themeRow.children)) {
            clickable.update(event, _renderWindow);
        }
    }

    void render() {
        _renderWindow.sfRenderWindowExt_draw(_backgroundRect);
        foreach (SettingsHeader settingsHeader; _settingsHeaders) {
            settingsHeader.render(_renderWindow);
        }
        _renderWindow.sfRenderWindowExt_draw(_backButton);
        _boardSizeRow.render(_renderWindow);
        _themeRow.render(_renderWindow);
    }

    interface EventHandler {
        void settingsWindow_onBackButtonClick();
        void settingsWindow_onBoardSizeButtonClick(BoardSize boardSize);
    }

    private {
        sfRectangleShape* _backgroundRect;
        sfRenderWindow* _renderWindow;
        Button _backButton;
        SettingsHeader[2] _settingsHeaders;
        StackLayout _boardSizeRow;
        StackLayout _themeRow;
    }
}
