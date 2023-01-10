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
import gameconfig;
import settingswindow;
import theme;
import std.exception;

interface GameEventHandler : BottomPanel.EventHandler, SettingsWindow.EventHandler { }

class Game : GameEventHandler {
    this() {
        _highscore = GameConfig.highscores[GameConfig.boardSize];

        int bottomPanelHeight = 100;
        int size = 600;

        _window = new Window("Snake", sfVector2u(size, size + bottomPanelHeight));
        _settingsWindow = new SettingsWindow(_window.renderWindow, this);

        setup();

        _clock = sfClock_create();
        _clock.sfClock_restart();

        _bottomPanel = new BottomPanel(_window.renderWindow, GameStatistics((() => _snake.score), (() => _highscore)), bottomPanelHeight, this);

        Theme.themeables = cast(IThemeable[])[_settingsWindow, _bottomPanel];
    }

    Window window() {
        return _window;
    }

    void handleInput() {
        if (_window.renderWindow.sfRenderWindow_hasFocus()) {
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
    }

    void restartClock() {
        _elapsed += sfTime_asSeconds(_clock.sfClock_restart());
        _bottomPanel.restartClock();
    }

    void update() {
        if (_snake.lost) {
            setup();
        }

        _window.update();
        _bottomPanel.update(_window.event);
        _settingsWindow.update(_window.event);

        float timestep = 1.0f / _snake.speed;
        float div = 10;

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

        if (_showSettingsWindow) {
            _settingsWindow.render();
        }

        _window.endDraw();
    }

    override void bottomPanel_onSettingsButtonClick() {
        _showSettingsWindow = true;
    }

    override void settingsWindow_onBackButtonClick() {
        _showSettingsWindow = false;
    }

    override void settingsWindow_onBoardSizeButtonClick(BoardSize boardSize) {
        _showSettingsWindow = false;
        GameConfig.boardSize = boardSize;
        _highscore = GameConfig.highscores[GameConfig.boardSize];
        setup();
    }

    private {
        void setup() {
            if (_snake !is null && _snake.score > _highscore) {
                _highscore = _snake.score;
                GameConfig.setHighscore(GameConfig.boardSize, _highscore);
            }

            int blockSpan = GameConfig.boardSize[0];
            _snake = new Snake(cast(float)(_window.renderWindow.sfRenderWindow_getSize().x) / blockSpan);
            _world = new World(_window.renderWindow.sfRenderWindow_getSize(), blockSpan, _snake);
        }

        World _world;
        Snake _snake;
        Window _window;
        sfClock* _clock;
        float _elapsed = 0;
        BottomPanel _bottomPanel;
        int _highscore;
        bool _showSettingsWindow = false;
        SettingsWindow _settingsWindow;
    }
}