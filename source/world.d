module world;

import bindbc.sfml;
import snake;

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