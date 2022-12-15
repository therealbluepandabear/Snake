module game;

import world;
import snake;
import bindbc.sfml;
import window;

class Game {
    this() {
        window = new Window("Snake", sfVector2u(800, 600));
    }
private:
    World world;
    Snake snake;
    Window window;
}