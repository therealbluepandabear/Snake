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
        m_item = sfVector2i(uniform(0, m_windowSize.x / m_blockSize), uniform(0, m_windowSize.y / m_blockSize));
        m_appleShape.sfCircleShape_setPosition(sfVector2f(m_item.x * m_blockSize, m_item.y * m_blockSize));
    }

    void update(Snake player) {
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
            player.pos.y >= gridSizeY - 1) {
            player.lose();
        }
    }

    void render(sfRenderWindow* renderWindow) {
        drawCheckerboardPattern(renderWindow);

        foreach (sfRectangleShape* rect; m_bounds) {
            renderWindow.sfRenderWindow_drawRectangleShape(rect, null);
        }

        renderWindow.sfRenderWindow_drawCircleShape(m_appleShape, null);
    }

private:
    void drawCheckerboardPattern(sfRenderWindow* renderWindow) {
        int countX = 0;
        int countY = 0;

        sfRectangleShape* shape = sfRectangleShape_create();
        sfColor fillColor = sfGreen;

        for (int x = 1; x < renderWindow.sfRenderWindow_getSize().x; x += m_blockSize) {
            for (int y = 1; y < renderWindow.sfRenderWindow_getSize().y; y += m_blockSize) {
                if ((x / m_blockSize) % 2 == 0) {
                    if ((y / m_blockSize) % 2 == 0) {
                        fillColor = sfColor(255, 140, 0, 255);
                    } else {
                        fillColor = sfColor(255, 165, 0, 255);
                    }
                } else {
                    if ((y / m_blockSize) % 2 != 0) {
                        fillColor = sfColor(255, 140, 0, 255);
                    } else {
                        fillColor = sfColor(255, 165, 0, 255);
                    }
                }

                shape.sfRectangleShape_setFillColor(fillColor);
                shape.sfRectangleShape_setPosition(sfVector2f(m_blockSize + x, m_blockSize + y));
                shape.sfRectangleShape_setSize(sfVector2f(m_blockSize, m_blockSize));

                renderWindow.sfRenderWindow_drawRectangleShape(shape, null);

                ++countY;
            }
        }
    }

    sfVector2u m_windowSize;
    sfVector2i m_item;
    int m_blockSize;

    sfCircleShape* m_appleShape;
    sfRectangleShape*[4] m_bounds;
}