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
import gameconfig;
import snake;
import game;
import theme;

class BottomPanel : IThemeable {
    this(sfRenderWindow* renderWindow, GameStatistics gameStatistics, int height, BottomPanel.EventHandler eventHandler) {
        initialize(renderWindow, gameStatistics, height, eventHandler);
    }

    void restartClock() {
        if (_startAnim) {
            _elapsed += sfTime_asSeconds(_clock.sfClock_restart());
        }
    }

    void update(sfEvent event) {
        float timestep = 0.6f;

        if (_elapsed >= timestep && _startAnim) {
            if (_scoreTextbox.visibility == Textbox.Visibility.visible) {
                _scoreTextbox.visibility = Textbox.Visibility.hidden;
            } else {
                _scoreTextbox.visibility = Textbox.Visibility.visible;
                ++_animItr;
            }
            _elapsed -= timestep;

            if (_animItr == 3) {
                assert(_scoreTextbox.visibility == Textbox.Visibility.visible, "_scoreTextbox must be visible");
                _startAnim = false;
                _animOver = true;
                _elapsed = 0;
                _animItr = 0;
                _clock.sfClock_destroy();
            }
        }

        if (!_animOver && _gameStatistics._score() % 10 == 0 && _gameStatistics._score() != 0) {
            _startAnim = true;
            _clock = sfClock_create();
        } else if (_gameStatistics._score() % 10 != 0 || _gameStatistics._score() == 0) {
            _scoreTextbox.visibility = Textbox.Visibility.visible;
            _animOver = false;
        }

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

    override {
        void onThemeChanged() {
            assert(_renderWindow !is null, "_renderWindow is null");
            initialize(_renderWindow, _gameStatistics, _height, _eventHandler);
        }
    }

    @property {
        Textbox scoreTextbox() {
            return _scoreTextbox;
        }
    }

    private {
        void initialize(sfRenderWindow* renderWindow, GameStatistics gameStatistics, int height, BottomPanel.EventHandler eventHandler) {
            _renderWindow = renderWindow;
            _gameStatistics = gameStatistics;
            _height = height;
            _eventHandler = eventHandler;

            _backgroundRect = sfRectangleShape_create();
            _backgroundRect.sfRectangleShape_setFillColor(Theme.currentTheme.secondaryBackground());
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

        GameStatistics _gameStatistics;
        int _height;
        BottomPanel.EventHandler _eventHandler;
        Button _settingsButton;
        Textbox _scoreTextbox;
        Textbox _highScoreTextbox;
        sfRenderWindow* _renderWindow;
        sfRectangleShape* _backgroundRect;
        sfTexture* _highScoreTexture;
        sfTexture* _scoreTexture;
        sfSprite* _highScoreSprite;
        sfSprite* _scoreSprite;

        sfClock* _clock;
        bool _startAnim = false;
        bool _animOver = false;
        float _elapsed = 0;
        int _animItr = 0;
    }
}
