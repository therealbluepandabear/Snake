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

class Game {
    this() {
        this._window = new Window("Snake", sfVector2u(600, 600));

        _textbox = new Textbox(sfVector2f(24, 24));

        setup();

        _clock = sfClock_create();
        _clock.sfClock_restart();
    }

    Window window() {
        return _window;
    }

    void handleInput() {
        if (sfKeyboard_isKeyPressed(sfKeyCode.sfKeyUp) && (_snake.getDirection() != Direction.down)) {
            _snake.dir = Direction.up;
        } else if (sfKeyboard_isKeyPressed(sfKeyCode.sfKeyDown) && (_snake.getDirection() != Direction.up)) {
            _snake.dir = Direction.down;
        } else if (sfKeyboard_isKeyPressed(sfKeyCode.sfKeyLeft) && (_snake.getDirection() != Direction.right)) {
            _snake.dir = Direction.left;
        } else if (sfKeyboard_isKeyPressed(sfKeyCode.sfKeyRight) && (_snake.getDirection() != Direction.left)) {
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

        float timestep = 1.0f / _snake.speed;

        if (_elapsed >= timestep) {
            _snake.tick();
            _world.update();

            _elapsed = 0;
        }
    }

    void render() {
        handleInput();

        _window.beginDraw();

        _world.render(_window.renderWindow);
        _snake.render(_window.renderWindow);
        _textbox.render(_window.renderWindow, to!string(_snake.score));

        _window.endDraw();
    }

private:
    void setup() {
        this._snake = new Snake(24);
        this._world = new World(_window.renderWindow.sfRenderWindow_getSize(), _snake);
    }

    World _world;
    Snake _snake;
    Window _window;
    sfClock* _clock;
    float _elapsed = 0;

    Textbox _textbox;
}