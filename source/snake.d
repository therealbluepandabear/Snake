module snake;

import bindbc.sfml;

struct SnakeSegment {
    this(int x, int y) {
        position = sfVector2i(x, y);
    }

    sfVector2i position;
}

enum Direction {
    none, up, down, left, right
}
