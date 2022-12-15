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

    void update() {

    }

private:
    World m_world;
    Snake m_snake;
    Window m_window;
    sfTime m_elapsed;
}