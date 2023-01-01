module bottompanel;

import bindbc.sfml;
import sfmlextensions;
import game;
import gamestatistics;
import textbox;
import std.conv;
import std.stdio;

class BottomPanel {
    this(GameStatistics gameStatistics, sfRenderWindow* renderWindow, int height) {
        _renderWindow = renderWindow;
        _gameStatistics = gameStatistics;

        _rect = sfRectangleShape_create();
        _rect.sfRectangleShape_setFillColor(sfColor(64, 190, 92, 255));
        _rect.sfRectangleShape_setSize(sfVector2f(renderWindow.sfRenderWindow_getSize().x, height));
        _rect.sfRectangleShape_setPosition(sfVector2f(0, renderWindow.sfRenderWindow_getSize().y - height));

        sfVector2f spriteSize = sfVector2f(50, 50);
        float spritePosY = renderWindow.sfRenderWindow_getSize().y - height + ((height - spriteSize.y) / 2);
        int margin = 24;

        _highScoreTexture = sfTexture_createFromFile("trophy.png", null);
        _highScoreSprite = sfSprite_create();
        _highScoreSprite.sfSprite_setTexture(_highScoreTexture, 0);
        _highScoreSprite.sizeToBounds(_highScoreTexture, spriteSize);
        _highScoreSprite.sfSprite_setPosition(sfVector2f(margin * 9, spritePosY));

        _scoreTexture = sfTexture_createFromFile("apple.png", null);
        _scoreSprite = sfSprite_create();
        _scoreSprite.sfSprite_setTexture(_scoreTexture, 0);
        _scoreSprite.sizeToBounds(_scoreTexture, spriteSize);
        _scoreSprite.sfSprite_setPosition(sfVector2f(margin, spritePosY));

        float txtPosY = renderWindow.sfRenderWindow_getSize().y - height + ((height - 24) / 2);

        _textboxes = [
            new Textbox(sfVector2f(_scoreSprite.sfSprite_getPosition().x + spriteSize.y + margin, txtPosY)),
            new Textbox(sfVector2f(_highScoreSprite.sfSprite_getPosition().x + spriteSize.y + margin, txtPosY))];
    }

    void render() {
        _renderWindow.draw(_rect);
        _renderWindow.draw(_highScoreSprite);
        _renderWindow.draw(_scoreSprite);

        _textboxes[0].render(_renderWindow, to!string(_gameStatistics._score()));
        _textboxes[1].render(_renderWindow, to!string(_gameStatistics._highScore()));
    }

private:
    GameStatistics _gameStatistics;
    sfRectangleShape* _rect;
    Textbox[2] _textboxes;
    sfRenderWindow* _renderWindow;
    sfTexture* _highScoreTexture;
    sfSprite* _highScoreSprite;
    sfTexture* _scoreTexture;
    sfSprite* _scoreSprite;
}
