module world;

import bindbc.sfml;
import snake;
import std.random;
import std.stdio;
import std.random;
import std.string;
import sfmlextensions;
import food;

class World {
    this(sfVector2u windowSize, int blockSpan, Snake player) {
        this._blockSpan = blockSpan;
        this._windowSize = windowSize;
        this._player = player;
        this._blockSize = cast(float)_windowSize.x / _blockSpan;

        initSound();
        initFood();
    }

    sfVector2u windowSize() {
        return _windowSize;
    }

    int blockSpan()  {
        return _blockSpan;
    }

    float blockSize()  {
        return _blockSize;
    }

    Snake player() {
        return _player;
    }

    void update() {
        if (_player.position == _food.position) {
            _player.extend();
            _player.incScore();
            _food.respawn();
            _scoreSound.sfSound_play();
        }

        if (_player.position.x < 0 ||
            _player.position.y < 0 ||
            _player.position.x > _blockSpan - 1 ||
            _player.position.y > _blockSpan - 1) {
            _player.lose();
        }

        if (_player.lost) {
            _snakeDeathSound.sfSound_play();
        }
    }

    void render(sfRenderWindow* renderWindow) {
        drawCheckerboardPattern(renderWindow);
        _food.render(renderWindow);
    }

private:
    void drawCheckerboardPattern(sfRenderWindow* renderWindow) {
        sfRectangleShape* shape = sfRectangleShape_create();
        shape.sfRectangleShape_setSize(sfVector2f(_blockSize, _blockSize));

        float dim = shape.sfRectangleShape_getSize().x;

        sfColor fillColor;

        for (float x = 0; x < _blockSpan; ++x) {
            for (float y = 0; y < _blockSpan; ++y) {
                if (x % 2 == 0) {
                    if (y % 2 == 0) {
                        fillColor = _orangeLight;
                    } else {
                        fillColor = _orangeDark;
                    }
                } else {
                    if (y % 2 != 0) {
                        fillColor = _orangeLight;
                    } else {
                        fillColor = _orangeDark;
                    }
                }

                shape.sfRectangleShape_setFillColor(fillColor);
                shape.sfRectangleShape_setPosition(sfVector2f(dim * x, dim * y));

                renderWindow.draw(shape);
            }
        }
    }

    bool isApplePosValid() {
        bool valid = true;

        foreach (SnakeSegment segment; _player.snakeBody) {
            if (segment.position == _food.position) {
                valid = false;
                break;
            }
        }

        return valid;
    }

    void createSound(ref sfSoundBuffer* soundBuffer, ref sfSound* sound, string src) {
        soundBuffer = sfSoundBuffer_createFromFile(toStringz(src));
        sound = sfSound_create();
        sound.sfSound_setBuffer(soundBuffer);
    }

    void initSound() {
        createSound(_scoreSoundBuffer, _scoreSound, Sounds.powerup);
        createSound(_snakeDeathSoundBuffer, _snakeDeathSound, Sounds.death);
    }

    void initFood() {
        this._food = new Food(this);
    }

    enum Sounds : string {
        powerup = "powerup.wav", death = "snakedeath.wav"
    }

    sfVector2u _windowSize;

    int _blockSpan;
    float _blockSize;

    sfSoundBuffer* _scoreSoundBuffer;
    sfSound* _scoreSound;

    sfSoundBuffer* _snakeDeathSoundBuffer;
    sfSound* _snakeDeathSound;

    sfColor _orangeLight = sfColor(255, 140, 0, 255);
    sfColor _orangeDark = sfColor(255, 165, 0, 255);

    Snake _player;
    Food _food;
}