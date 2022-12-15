module world;

import bindbc.sfml;
import snake;
import std.random;

class World {
    this(sfVector2u windowSize) {
        this.blockSize = 16;
        this.windowSize = windowSize;

        respawnApple();
        appleShape.sfCircleShape_setFillColor(sfRed);
        appleShape.sfCircleShape_setRadius(blockSize / 2);

        for (int i = 0; i < 4; ++i) {
            bounds[i].sfRectangleShape_setFillColor(sfColor(150, 0, 0, 255));

            if (!((i + 1) % 2)) {
                bounds[i].sfRectangleShape_setSize(sfVector2f(windowSize.x, blockSize));
            } else {
                bounds[i].sfRectangleShape_setSize(sfVector2f(blockSize, windowSize.y));
            }

            if (i < 2) {
                bounds[i].sfRectangleShape_setPosition(sfVector2f(0, 0));
            } else {
                bounds[i].sfRectangleShape_setOrigin(bounds[i].sfRectangleShape_getSize());
                bounds[i].sfRectangleShape_setPosition(cast(sfVector2f)windowSize);
            }
        }
    }

    int getBlockSize() {
        return 0;
    }

    void respawnApple() {
        int maxX = (windowSize.x / blockSize) - 2;
        int maxY = (windowSize.y / blockSize) - 2;

        item = sfVector2i(uniform(0, maxX + 1), uniform(0, maxY + 1));
        appleShape.sfCircleShape_setPosition(sfVector2f(item.x * blockSize, item.y * blockSize));
    }

    void update(Snake* player) {

    }

private:
    sfVector2u windowSize;
    sfVector2i item;
    int blockSize;

    sfCircleShape* appleShape;
    sfRectangleShape*[4] bounds;
}