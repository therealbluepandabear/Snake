module game;

import world;
import snake;
import bindbc.sfml;
import window;
import std.stdio;

class Game {
    this() {
        m_window = new Window("Snake", sfVector2u(800, 600));
        m_world = new World(m_window.renderWindow.sfRenderWindow_getSize());
        m_snake = new Snake(16);
        m_clock = sfClock_create();
    }

    Window window() {
        return m_window;
    }

    void handleInput() {
        if (sfKeyboard_isKeyPressed(sfKeyCode.sfKeyUp) && (m_snake.dir != Direction.down)) {
            m_snake.dir = Direction.up;
        } else if (sfKeyboard_isKeyPressed(sfKeyCode.sfKeyDown) && (m_snake.dir != Direction.up)) {
            m_snake.dir = Direction.down;
        } else if (sfKeyboard_isKeyPressed(sfKeyCode.sfKeyLeft) && (m_snake.dir != Direction.right)) {
            m_snake.dir = Direction.left;
        } else if (sfKeyboard_isKeyPressed(sfKeyCode.sfKeyRight) && (m_snake.dir != Direction.left)) {
            m_snake.dir = Direction.right;
        }
    }

    void restartClock() {
        m_elapsed += sfTime_asSeconds(m_clock.sfClock_restart());
    }

    void update() {
        m_window.update();
        float timestep = 1.0f / m_snake.speed;

        if (m_elapsed >= timestep) {
            m_snake.tick();
            m_world.update(m_snake);
            m_elapsed -= timestep;
        }
    }

    void render() {
        handleInput();

        m_window.beginDraw();

        m_world.render(m_window.renderWindow);
        m_snake.render(m_window.renderWindow);

        m_window.endDraw();
    }

private:
    World m_world;
    Snake m_snake;
    Window m_window;
    sfClock* m_clock;
    float m_elapsed;
}