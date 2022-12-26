module game;

import world;
import snake;
import bindbc.sfml;
import window;
import std.stdio;
import std.format;
import std.math;
import std.conv;
import std.string;

class Game {
    this() {
        this.m_window = new Window("Snake", sfVector2u(600, 600));

        this.m_font = sfFont_createFromFile("nunito_black.ttf");
        this.m_text = sfText_create();
        m_text.sfText_setFont(m_font);
        m_text.sfText_setCharacterSize(32);
        m_text.sfText_setString("0");
        m_text.sfText_setPosition(sfVector2f(24, 24));
        m_text.sfText_setFillColor(sfWhite);

        setup();

        m_clock = sfClock_create();
        m_clock.sfClock_restart();
    }

    Window window() {
        return m_window;
    }

    void handleInput() {
        if (sfKeyboard_isKeyPressed(sfKeyCode.sfKeyUp) && (m_snake.getDirection() != Direction.down)) {
            m_snake.dir = Direction.up;
        } else if (sfKeyboard_isKeyPressed(sfKeyCode.sfKeyDown) && (m_snake.getDirection() != Direction.up)) {
            m_snake.dir = Direction.down;
        } else if (sfKeyboard_isKeyPressed(sfKeyCode.sfKeyLeft) && (m_snake.getDirection() != Direction.right)) {
            m_snake.dir = Direction.left;
        } else if (sfKeyboard_isKeyPressed(sfKeyCode.sfKeyRight) && (m_snake.getDirection() != Direction.left)) {
            m_snake.dir = Direction.right;
        }
    }

    void restartClock() {
        m_elapsed += sfTime_asSeconds(m_clock.sfClock_restart());
    }

    void update() {
        if (m_snake.lost) {
            setup();
        }

        m_window.update();

        float timestep = 1.0f / m_snake.speed;

        if (m_elapsed >= timestep) {
            m_snake.tick();
            m_world.update();

            m_elapsed = 0;
        }
    }

    void render() {
        handleInput();

        m_window.beginDraw();

        m_world.render(m_window.renderWindow);
        m_snake.render(m_window.renderWindow);

        m_text.sfText_setString(cast(const char*)toStringz(to!string(m_snake.score)));
        m_window.renderWindow.sfRenderWindow_drawText(m_text, null);

        m_window.endDraw();
    }

private:
    void setup() {
        this.m_snake = new Snake(24);
        this.m_world = new World(m_window.renderWindow.sfRenderWindow_getSize(), m_snake);
    }

    World m_world;
    Snake m_snake;
    Window m_window;
    sfClock* m_clock;
    float m_elapsed = 0;

    sfFont* m_font;
    sfText* m_text;
}