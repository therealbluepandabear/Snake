module bottompanel;

import bindbc.sfml;
import sfmlextensions;
import game;
import gamestatistics;
import textbox;
import std.conv;
import std.stdio;

class BottomPanel {
    this(GameStatistics gameStatistics, sfRenderWindow* renderWindow, uint height) {
        _renderWindow = renderWindow;
        _gameStatistics = gameStatistics;

        int padding = 24;
        sfVector2f vec = sfVector2f(padding, renderWindow.sfRenderWindow_getSize().y - height + padding);
        _textboxes = [new Textbox(vec), new Textbox(sfVector2f(vec.x + 200, vec.y))];

        _rect = sfRectangleShape_create();
        _rect.sfRectangleShape_setFillColor(sfColor(255, 140, 0, 255));
        _rect.sfRectangleShape_setSize(sfVector2f(renderWindow.sfRenderWindow_getSize().x, height));
        _rect.sfRectangleShape_setPosition(sfVector2f(0, renderWindow.sfRenderWindow_getSize().y - height));

        _highScoreTexture = sfTexture_createFromFile("trophy.png", null);
        _highScoreSprite = sfSprite_create();
        _highScoreSprite.sfSprite_setTexture(_highScoreTexture, 0);
        _highScoreSprite.sfSprite_setPosition(sfVector2f(0, renderWindow.sfRenderWindow_getSize().y - height));
    }

    void render() {
        _renderWindow.draw(_rect);
        _renderWindow.draw(_highScoreSprite);

        _textboxes[0].render(_renderWindow, "Score: " ~ to!string(_gameStatistics._score()));
        _textboxes[1].render(_renderWindow, "High score: " ~ to!string(_gameStatistics._highScore()));
    }

private:
    GameStatistics _gameStatistics;
    sfRectangleShape* _rect;
    Textbox[2] _textboxes;
    sfRenderWindow* _renderWindow;
    sfTexture* _highScoreTexture;
    sfSprite* _highScoreSprite;
}
