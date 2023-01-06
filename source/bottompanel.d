module bottompanel;

import bindbc.sfml;
import sfmlextensions;
import game;
import gamestatistics;
import textbox;
import std.conv;
import std.stdio;
import button;
import settingswindow;
import world;
import gamesettings;
import snake;
import game;
import theme;

class BottomPanel {
    this(sfRenderWindow* renderWindow, GameStatistics gameStatistics, int height, BottomPanel.EventHandler eventHandler) {
        _renderWindow = renderWindow;
        _gameStatistics = gameStatistics;

        _backgroundRect = sfRectangleShape_create();
        _backgroundRect.sfRectangleShape_setFillColor(Theme.secondaryBackground);
        _backgroundRect.sfRectangleShape_setSize(sfVector2f(renderWindow.sfRenderWindow_getSize().x, height));
        _backgroundRect.sfRectangleShape_setPosition(sfVector2f(0, renderWindow.sfRenderWindow_getSize().y - height));

        sfVector2f spriteSize = sfVector2fExt_splat(50);
        int margin = 24;

        _highScoreTexture = sfTexture_createFromFile("trophy.png", null);
        _highScoreSprite = sfSprite_create();
        _highScoreSprite.sfSprite_setTexture(_highScoreTexture, 0);
        _highScoreSprite.sfSpriteExt_sizeToBounds(_highScoreTexture, spriteSize);
        _highScoreSprite.sfSprite_setPosition(sfVector2f(margin * 9, _backgroundRect.sfRectangleShapeExt_getCenter(_highScoreSprite.sfSpriteExt_getSize()).y));

        _scoreTexture = sfTexture_createFromFile("apple.png", null);
        _scoreSprite = sfSprite_create();
        _scoreSprite.sfSprite_setTexture(_scoreTexture, 0);
        _scoreSprite.sfSpriteExt_sizeToBounds(_scoreTexture, spriteSize);
        _scoreSprite.sfSprite_setPosition(sfVector2f(margin,  _backgroundRect.sfRectangleShapeExt_getCenter(_scoreSprite.sfSpriteExt_getSize()).y));

        float txtPosY = renderWindow.sfRenderWindow_getSize().y - height + ((height - 24) / 2);

        _scoreTextbox = new Textbox();
        _scoreTextbox.position = sfVector2f(_scoreSprite.sfSprite_getPosition().x + spriteSize.y + margin, txtPosY);

        _highScoreTextbox = new Textbox();
        _highScoreTextbox.position = sfVector2f(_highScoreSprite.sfSprite_getPosition().x + spriteSize.y + margin, txtPosY);

        _settingsButton = new Button();
        _settingsButton.text = "Settings";
        _settingsButton.onButtonClick = &(eventHandler.bottomPanel_onSettingsButtonClick);
        _settingsButton.position = sfVector2f(_backgroundRect.sfRectangleShape_getSize().x - _settingsButton.size.x - margin, _backgroundRect.sfRectangleShapeExt_getCenter(_settingsButton.size).y);
    }

    void update(sfEvent event) {
        _settingsButton.update(event, _renderWindow);
    }

    void render() {
        _renderWindow.sfRenderWindowExt_draw(_backgroundRect);
        _renderWindow.sfRenderWindowExt_draw(_highScoreSprite);
        _renderWindow.sfRenderWindowExt_draw(_scoreSprite);

        _scoreTextbox.text = to!string(_gameStatistics._score());
        _highScoreTextbox.text = to!string(_gameStatistics._highScore());

        _renderWindow.sfRenderWindowExt_draw(_scoreTextbox);
        _renderWindow.sfRenderWindowExt_draw(_highScoreTextbox);
        _renderWindow.sfRenderWindowExt_draw(_settingsButton);
    }

    interface EventHandler {
        void bottomPanel_onSettingsButtonClick();
    }

    private {
        GameStatistics _gameStatistics;
        sfRectangleShape* _backgroundRect;
        Button _settingsButton;
        Textbox _scoreTextbox;
        Textbox _highScoreTextbox;
        sfRenderWindow* _renderWindow;
        sfTexture* _highScoreTexture;
        sfSprite* _highScoreSprite;
        sfTexture* _scoreTexture;
        sfSprite* _scoreSprite;
    }
}
