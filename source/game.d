module game;

import world;
import snake;
import bindbc.sfml;
import window;
import std.stdio;
import std.format;
import std.math;
import std.conv;
import std.string;
import sfmlextensions;
import textbox;
import std.random;
import gamestatistics;
import bottompanel;
import gamesettings;
import row;

class Game {
    this() {
        int bottomPanelHeight = 100;
        int size = 600;

        _window = new Window("Snake", sfVector2u(size, size + bottomPanelHeight));
        setup();

        _clock = sfClock_create();
        _clock.sfClock_restart();

        _bottomPanel = new BottomPanel(_window.renderWindow, GameStatistics((() => _snake.score), (() => _highScore)), bottomPanelHeight, this);
    }

    Window window() {
        return _window;
    }

    void handleInput() {
        if ((sfKeyboard_isKeyPressed(sfKeyCode.sfKeyUp) || sfKeyboard_isKeyPressed(sfKeyCode.sfKeyW))  && (_snake.getDirection() != Direction.down)) {
            _snake.dir = Direction.up;
        } else if ((sfKeyboard_isKeyPressed(sfKeyCode.sfKeyDown) || sfKeyboard_isKeyPressed(sfKeyCode.sfKeyS)) && (_snake.getDirection() != Direction.up)) {
            _snake.dir = Direction.down;
        } else if ((sfKeyboard_isKeyPressed(sfKeyCode.sfKeyLeft) || sfKeyboard_isKeyPressed(sfKeyCode.sfKeyA))  && (_snake.getDirection() != Direction.right)) {
            _snake.dir = Direction.left;
        } else if ((sfKeyboard_isKeyPressed(sfKeyCode.sfKeyRight) || sfKeyboard_isKeyPressed(sfKeyCode.sfKeyD)) && (_snake.getDirection() != Direction.left)) {
            _snake.dir = Direction.right;
        }
    }

    void restartClock() {
        _elapsed += sfTime_asSeconds(_clock.sfClock_restart());
    }

    void update() {
        if (_snake.lost) {
            setup();
        }

        _window.update();
        _bottomPanel.update(_window.event);

        float timestep = 1.0f / _snake.speed;
        float div = 10;
        float transitionTimestep = timestep / div;

        if (_elapsed >= timestep) {
            _snake.tick();
            _world.update();

            _elapsed -= timestep;
        }
    }

    void render() {
        handleInput();

        _window.beginDraw();

        _world.render(_window.renderWindow);
        _snake.render(_window.renderWindow);
        _bottomPanel.render();

        _window.endDraw();
    }

    void setup() {
        if (_snake !is null && _snake.score > _highScore) {
            _highScore = _snake.score;
        }

        int blockSpan = GameSettings.boardSize[0];
        _snake = new Snake(cast(float)(_window.renderWindow.sfRenderWindow_getSize().x) / blockSpan);
        _world = new World(_window.renderWindow.sfRenderWindow_getSize(), blockSpan, _snake);
    }

    private {
        World _world;
        Snake _snake;
        Window _window;
        sfClock* _clock;
        float _elapsed = 0;
        BottomPanel _bottomPanel;
        int _highScore;
    }
}