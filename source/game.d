module game;

import world;
import snake;
import bindbc.sfml;
import window;

class Game {
    this() {
        m_window = new Window("Snake", sfVector2u(800, 600));

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

    Window window() {
        return m_window;
    }

    void update() {
        m_window.update();
        //float timestep = 1.0f / m_snake.speed;
        //
        //if (m_elapsed.sfTime_asSeconds() >= timestep) {
        //    m_snake.tick();
        //    m_world.update(&m_snake);
        //}
    }

    void render() {
        sfRectangleShape* shape = sfRectangleShape_create();

        shape.sfRectangleShape_setSize(sfVector2f(50, 50));
        shape.sfRectangleShape_setFillColor(sfRed);

        m_window.beginDraw();

        m_window.renderWindow.sfRenderWindow_drawRectangleShape(shape, null);

        m_window.endDraw();
    }

private:
    World m_world;
    Snake m_snake;
    Window m_window;
    sfTime m_elapsed;
}