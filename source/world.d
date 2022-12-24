module world;

import bindbc.sfml;
import snake;
import std.random;
import std.stdio;
import std.random;

class World {
    this(sfVector2u windowSize) {
        this.m_blockSize = 24;
        this.m_windowSize = windowSize;

        m_appleShape = sfCircleShape_create();

        respawnApple();

        m_appleShape.sfCircleShape_setFillColor(sfRed);
        m_appleShape.sfCircleShape_setRadius(m_blockSize / 2);
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
            playPowerupSound();
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

        renderWindow.sfRenderWindow_drawCircleShape(m_appleShape, null);
    }

private:
    void drawCheckerboardPattern(sfRenderWindow* renderWindow) {
        sfRectangleShape* shape = sfRectangleShape_create();
        shape.sfRectangleShape_setSize(sfVector2f(m_blockSize, m_blockSize));

        sfColor orangeLight = sfColor(255, 140, 0, 255);
        sfColor orangeDark = sfColor(255, 165, 0, 255);

        sfColor fillColor;

        for (int x = 0; x < renderWindow.sfRenderWindow_getSize().x; x += m_blockSize) {
            for (int y = 0; y < renderWindow.sfRenderWindow_getSize().y; y += m_blockSize) {
                if ((x / m_blockSize) % 2 == 0) {
                    if ((y / m_blockSize) % 2 == 0) {
                        fillColor = orangeLight;
                    } else {
                        fillColor = orangeDark;
                    }
                } else {
                    if ((y / m_blockSize) % 2 != 0) {
                        fillColor = orangeLight;
                    } else {
                        fillColor = orangeDark;
                    }
                }

                shape.sfRectangleShape_setFillColor(fillColor);

                if (y == 0) {
                    shape.sfRectangleShape_setPosition(sfVector2f(x, 0));
                    renderWindow.sfRenderWindow_drawRectangleShape(shape, null);
                } else if (x == 0) {
                    shape.sfRectangleShape_setPosition(sfVector2f(0, y));
                    renderWindow.sfRenderWindow_drawRectangleShape(shape, null);
                }

                shape.sfRectangleShape_setPosition(sfVector2f(m_blockSize + x, m_blockSize + y));

                renderWindow.sfRenderWindow_drawRectangleShape(shape, null);
            }
        }
    }

    void playPowerupSound() {
        sfSoundBuffer* buffer = sfSoundBuffer_createFromFile("powerup.wav");
        sfSound* sound = sfSound_create();

        sound.sfSound_setBuffer(buffer);
        sound.sfSound_play();
    }

    sfVector2u m_windowSize;
    sfVector2i m_item;
    int m_blockSize;

    sfCircleShape* m_appleShape;
}