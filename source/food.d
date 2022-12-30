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
        this._foodShape = sfCircleShape_create();

        _foodShape.sfCircleShape_setFillColor(sfRed);
        _foodShape.sfCircleShape_setRadius((cast(float)world.windowSize.x / world.blockSpan) / 2);
        respawn();
    }

    sfVector2i position() {
        return _position;
    }

    void respawn() {
        this._position = sfVector2i(uniform(0, _world.blockSpan), uniform(0, _world.blockSpan));
        _foodShape.sfCircleShape_setPosition(sfVector2f(_position.x * _world.blockSize, _position.y * _world.blockSize));

        if (!isFoodPosValid()) {
            respawn();
        }
    }

    void render(sfRenderWindow* renderWindow) {
        renderWindow.draw(_foodShape);
    }

private:
    bool isFoodPosValid() {
        bool isValid = true;

        foreach (SnakeSegment segment; _world.player.snakeBody) {
            if (segment.position == _foodShape.sfCircleShape_getPosition().toVector2i()) {
                isValid = false;
                break;
            }
        }

        return isValid;
    }

    World _world;
    sfCircleShape* _foodShape;
    sfVector2i _position;
}