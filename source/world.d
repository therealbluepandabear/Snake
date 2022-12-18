module world;

import bindbc.sfml;
import snake;
import std.random;
import std.stdio;
import std.random;

class World {
    this(sfVector2u windowSize) {
        this.m_blockSize = 16;
        this.m_windowSize = windowSize;

        m_appleShape = sfCircleShape_create();

        respawnApple();

        m_appleShape.sfCircleShape_setFillColor(sfRed);
        m_appleShape.sfCircleShape_setRadius(m_blockSize / 2);

        for (int i = 0; i < 4; ++i) {
            m_bounds[i] = sfRectangleShape_create();
            m_bounds[i].sfRectangleShape_setFillColor(sfBlue);

            if (i % 2) {
                m_bounds[i].sfRectangleShape_setSize(sfVector2f(m_blockSize, windowSize.y));
            } else {
                m_bounds[i].sfRectangleShape_setSize(sfVector2f(windowSize.x, m_blockSize));
            }

            if (i >= 2) {
                m_bounds[i].sfRectangleShape_setOrigin(m_bounds[i].sfRectangleShape_getSize());
                m_bounds[i].sfRectangleShape_setPosition(sfVector2f(m_windowSize.x, windowSize.y));
            }
        }
    }

    int blockSize() {
        return m_blockSize;
    }

    void respawnApple() {
        int maxX = m_windowSize.x - (cast(int)(m_appleShape.sfCircleShape_getRadius()) * 2) - blockSize;
        int maxY = m_windowSize.y - (cast(int)(m_appleShape.sfCircleShape_getRadius()) * 2) - blockSize;

        m_item = sfVector2i(uniform(m_blockSize - 1, maxX), uniform(m_blockSize - 1, maxY));
        m_appleShape.sfCircleShape_setPosition(sfVector2f(m_item.x, m_item.y));
    }

    void update(Snake* player) {
        if (player.pos == m_item) {
            player.extend();
            player.incScore();
            respawnApple();
        }

        int gridSizeX = m_windowSize.x / m_blockSize;
        int gridSizeY = m_windowSize.y / m_blockSize;

        if (player.pos.x <= 0 ||
            player.pos.y <= 0 ||
            player.pos.x >= gridSizeX - 1 ||
            player.pos.y >= gridSizeY - 1)
        {
            player.lose();
        }
    }

    void render(sfRenderWindow* renderWindow) {
        foreach (sfRectangleShape* rect; m_bounds) {
            renderWindow.sfRenderWindow_drawRectangleShape(rect, null);
        }

        respawnApple();
        renderWindow.sfRenderWindow_drawCircleShape(m_appleShape, null);
    }

private:
    sfVector2u m_windowSize;
    sfVector2i m_item;
    int m_blockSize;

    sfCircleShape* m_appleShape;
    sfRectangleShape*[4] m_bounds;
}