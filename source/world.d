module world;

import bindbc.sfml;
import snake;
import std.random;
import std.stdio;
import std.random;

class World {
    this(sfVector2u windowSize, Snake player) {
        this.m_blockSize = player.size;
        this.m_windowSize = windowSize;

        this.m_soundBuffer = sfSoundBuffer_createFromFile("powerup.wav");
        this.m_sound = sfSound_create();
        this.m_sound.sfSound_setBuffer(m_soundBuffer);

        this.m_appleShape = sfCircleShape_create();

        this.m_player = player;

        respawnApple();

        m_appleShape.sfCircleShape_setFillColor(sfRed);
        m_appleShape.sfCircleShape_setRadius(m_blockSize / 2);
    }

    void respawnApple() {
        m_item = sfVector2i(uniform(0, m_windowSize.x / m_blockSize), uniform(0, m_windowSize.y / m_blockSize));
        m_appleShape.sfCircleShape_setPosition(sfVector2f(m_item.x * m_blockSize, m_item.y * m_blockSize));

        if (!applePosValid()) {
            respawnApple();
        }
    }

    void update() {
        if (m_player.pos == m_item) {
            m_player.extend();
            m_player.incScore();
            respawnApple();
            playPowerupSound();
        }

        int gridSizeX = m_windowSize.x / m_blockSize;
        int gridSizeY = m_windowSize.y / m_blockSize;

        if (m_player.pos.x < 0 ||
            m_player.pos.y < 0 ||
            m_player.pos.x > gridSizeX - 1 ||
            m_player.pos.y > gridSizeY - 1) {
            m_player.lose();
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

        sfColor fillColor;

        for (int x = 0; x < renderWindow.sfRenderWindow_getSize().x; x += m_blockSize) {
            for (int y = 0; y < renderWindow.sfRenderWindow_getSize().y; y += m_blockSize) {
                if ((x / m_blockSize) % 2 == 0) {
                    if ((y / m_blockSize) % 2 == 0) {
                        fillColor = m_orangeLight;
                    } else {
                        fillColor = m_orangeDark;
                    }
                } else {
                    if ((y / m_blockSize) % 2 != 0) {
                        fillColor = m_orangeLight;
                    } else {
                        fillColor = m_orangeDark;
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

    bool applePosValid() {
        bool valid = true;

        foreach (SnakeSegment segment; m_player.snakeBody) {
            if (segment.position.x == m_item.x && segment.position.y == m_item.y) {
                valid = false;
                break;
            }
        }

        return valid;
    }

    void playPowerupSound() {
        m_sound.sfSound_play();
    }

    sfVector2u m_windowSize;
    sfVector2i m_item;
    int m_blockSize;

    sfCircleShape* m_appleShape;

    sfSoundBuffer* m_soundBuffer;
    sfSound* m_sound;

    sfColor m_orangeLight = sfColor(255, 140, 0, 255);
    sfColor m_orangeDark = sfColor(255, 165, 0, 255);

    Snake m_player;
}