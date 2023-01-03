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

class BottomPanel {
    this(sfRenderWindow* renderWindow, GameStatistics gameStatistics, int height) {
        _renderWindow = renderWindow;
        _gameStatistics = gameStatistics;

        _backgroundRect = sfRectangleShape_create();
        _backgroundRect.sfRectangleShape_setFillColor(Colors.shade_4);
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
        _scoreTextbox.setPosition(sfVector2f(_scoreSprite.sfSprite_getPosition().x + spriteSize.y + margin, txtPosY));

        _highScoreTextbox = new Textbox();
        _highScoreTextbox.setPosition(sfVector2f(_highScoreSprite.sfSprite_getPosition().x + spriteSize.y + margin, txtPosY));

        void delegate() onBackButtonClick = {
            showSettingsWindow = false;
        };

        _settingsWindow = new SettingsWindow(_renderWindow, Colors.shade_1, Colors.shade_4, onBackButtonClick);

        void delegate() onButtonClick = {
            showSettingsWindow = true;
        };

        _settingsButton = new Button();
        _settingsButton.setText("Settings");
        _settingsButton.setOnButtonClick(onButtonClick);
        _settingsButton.setColor(Colors.shade_2);
        _settingsButton.setColorHover(Colors.shade_3);
        _settingsButton.setPosition(sfVector2f(_backgroundRect.sfRectangleShape_getSize().x - _settingsButton.getSize().x - margin, _backgroundRect.sfRectangleShapeExt_getCenter(_settingsButton.getSize()).y));
    }

    void update(sfEvent event) {
        _settingsButton.update(event, _renderWindow);
        _settingsWindow.update(event);
    }

    void render() {
        _renderWindow.sfRenderWindowExt_draw(_backgroundRect);
        _renderWindow.sfRenderWindowExt_draw(_highScoreSprite);
        _renderWindow.sfRenderWindowExt_draw(_scoreSprite);

        _scoreTextbox.setText(to!string(_gameStatistics._score()));
        _highScoreTextbox.setText(to!string(_gameStatistics._highScore()));

        _scoreTextbox.render(_renderWindow);
        _highScoreTextbox.render(_renderWindow);
        _settingsButton.render(_renderWindow);

        if (showSettingsWindow) {
            _settingsWindow.render();
        }
    }

private:
    enum Colors : sfColor {
        shade_1 = sfColorExt_255(189, 183, 107),
        shade_2 = sfColorExt_255(189, 183, 107),
        shade_3 = sfColorExt_255(166, 159, 74),
        shade_4 = sfColorExt_255(64, 190, 92)
    }

    GameStatistics _gameStatistics;
    sfRectangleShape* _backgroundRect;
    SettingsWindow _settingsWindow;
    Button _settingsButton;
    Textbox _scoreTextbox;
    Textbox _highScoreTextbox;
    sfRenderWindow* _renderWindow;
    sfTexture* _highScoreTexture;
    sfSprite* _highScoreSprite;
    sfTexture* _scoreTexture;
    sfSprite* _scoreSprite;
    bool showSettingsWindow = false;
}
