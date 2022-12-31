module food;

import world;
import bindbc.sfml;
import std.random;
import sfmlextensions;
import snake;
import std.stdio;

class Food {
    this(World world) {
        this._world = world;
        this._appleTexture = sfTexture_createFromFile("apple.png", null);
        this._appleSprite = sfSprite_create();
        _appleSprite.sfSprite_setTexture(_appleTexture, 0);
        _appleSprite.sizeToBounds(_appleTexture, sfVector2f_splat(cast(float)(world.windowSize.x / world.blockSpan)));
        respawn();
    }

    sfVector2i position() {
        return _position;
    }

    void respawn() {
        this._position = sfVector2i(uniform(0, _world.blockSpan), uniform(0, _world.blockSpan));
        _appleSprite.sfSprite_setPosition(sfVector2f(_position.x * _world.blockSize, _position.y * _world.blockSize));

        if (!isFoodPosValid()) {
            respawn();
        }
    }

    void render(sfRenderWindow* renderWindow) {
        renderWindow.draw(_appleSprite);
    }

private:
    bool isFoodPosValid() {
        bool isValid = true;

        foreach (SnakeSegment segment; _world.player.snakeBody) {
            if (segment.position == _appleSprite.sfSprite_getPosition().toVector2i()) {
                isValid = false;
                break;
            }
        }

        return isValid;
    }

    World _world;
    sfVector2i _position;
    sfTexture* _appleTexture;
    sfSprite* _appleSprite;
}
