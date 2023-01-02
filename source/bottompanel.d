module bottompanel;

import bindbc.sfml;
import sfmlextensions;
import game;
import gamestatistics;
import textbox;
import std.conv;
import std.stdio;
import button;

class BottomPanel {
    this(sfRenderWindow* renderWindow, GameStatistics gameStatistics, int height) {
        _renderWindow = renderWindow;
        _gameStatistics = gameStatistics;

        _rect = sfRectangleShape_create();
        _rect.sfRectangleShape_setFillColor(sfColor(64, 190, 92, 255));
        _rect.sfRectangleShape_setSize(sfVector2f(renderWindow.sfRenderWindow_getSize().x, height));
        _rect.sfRectangleShape_setPosition(sfVector2f(0, renderWindow.sfRenderWindow_getSize().y - height));

        sfVector2f spriteSize = sfVector2fExt_splat(50);
        float spritePosY = renderWindow.sfRenderWindow_getSize().y - height + ((height - spriteSize.y) / 2);
        int margin = 24;

        _highScoreTexture = sfTexture_createFromFile("trophy.png", null);
        _highScoreSprite = sfSprite_create();
        _highScoreSprite.sfSprite_setTexture(_highScoreTexture, 0);
        _highScoreSprite.sfSpriteExt_sizeToBounds(_highScoreTexture, spriteSize);
        _highScoreSprite.sfSprite_setPosition(sfVector2f(margin * 9, spritePosY));

        _scoreTexture = sfTexture_createFromFile("apple.png", null);
        _scoreSprite = sfSprite_create();
        _scoreSprite.sfSprite_setTexture(_scoreTexture, 0);
        _scoreSprite.sfSpriteExt_sizeToBounds(_scoreTexture, spriteSize);
        _scoreSprite.sfSprite_setPosition(sfVector2f(margin, spritePosY));

        float txtPosY = renderWindow.sfRenderWindow_getSize().y - height + ((height - 24) / 2);

        _scoreTextbox = new Textbox(sfVector2f(_scoreSprite.sfSprite_getPosition().x + spriteSize.y + margin, txtPosY));
        _highScoreTextbox = new Textbox(sfVector2f(_highScoreSprite.sfSprite_getPosition().x + spriteSize.y + margin, txtPosY));

        float btnPosY = renderWindow.sfRenderWindow_getSize().y - height + ((height - 50) / 2);
        float btnPosX = renderWindow.sfRenderWindow_getSize().x - 200;

        void delegate() onButtonClick = {

        };

        _settingsButton = new Button(sfColor(189, 183, 107, 255), sfColor(166, 159, 74, 255), sfVector2fExt_splat(0), "Settings", onButtonClick);
        _settingsButton.setPosition(sfVector2f(_rect.sfRectangleShape_getSize().x - _settingsButton.getSize().x - margin, _rect.sfRectangleShapeExt_getCenter(_settingsButton.getSize()).y));
    }

    void update(sfEvent event) {
        _settingsButton.update(event, _renderWindow);
    }

    void render() {
        _renderWindow.sfRenderWindowExt_draw(_rect);
        _renderWindow.sfRenderWindowExt_draw(_highScoreSprite);
        _renderWindow.sfRenderWindowExt_draw(_scoreSprite);

        _scoreTextbox.setText(to!string(_gameStatistics._score()));
        _scoreTextbox.render(_renderWindow);
        _highScoreTextbox.setText(to!string(_gameStatistics._highScore()));
        _highScoreTextbox.render(_renderWindow);
        _settingsButton.render(_renderWindow);
    }

private:
    GameStatistics _gameStatistics;
    sfRectangleShape* _rect;
    Button _settingsButton;
    Textbox _scoreTextbox;
    Textbox _highScoreTextbox;
    sfRenderWindow* _renderWindow;
    sfTexture* _highScoreTexture;
    sfSprite* _highScoreSprite;
    sfTexture* _scoreTexture;
    sfSprite* _scoreSprite;
}
