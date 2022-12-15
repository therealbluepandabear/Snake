module snake;

import bindbc.sfml;
import std.algorithm;

struct SnakeSegment {
    this(int x, int y) {
        position = sfVector2i(x, y);
    }

    sfVector2i position;
}

enum Direction {
    none, up, down, left, right
}

alias SnakeContainer = SnakeSegment[];

class Snake {
    this(int size) {
        this.size = size;
        bodyRect.sfRectangleShape_setSize(sfVector2f(size - 1, size - 1));
        reset();
    }

    void setDirection(Direction dir) {
        this.dir = dir;
    }

    Direction getDirection() {
        return dir;
    }

    int getSpeed() {
        return speed;
    }

    sfVector2i getPosition() {
        return (!(snakeBody.length == 0)) ? snakeBody[0].position : sfVector2i(1, 1);
    }

    int getLives() {
        return lives;
    }

    int getScore() {
        return score;
    }

    void increaseScore() {
        score += 10;
    }

    bool hasLost() {
        return lost;
    }

    void lose() {
        this.lost = true;
    }

    void toggleLost() {
        this.lost = !lost;
    }

    void extend() {
        if (snakeBody.length == 0) {
            return;
        }

        SnakeSegment* tailHead = &snakeBody[snakeBody.length - 1];

        if (snakeBody.length > 1) {
            SnakeSegment* tailBone = &snakeBody[snakeBody.length - 2];

            if (tailHead.position.x == tailBone.position.x) {
                if (tailHead.position.y > tailBone.position.y) {
                    snakeBody ~= SnakeSegment(tailHead.position.x, tailHead.position.y + 1);
                } else {
                    snakeBody ~= SnakeSegment(tailHead.position.x, tailHead.position.y - 1);
                }
            } else if (tailHead.position.y == tailBone.position.y) {
                if (tailHead.position.x > tailBone.position.x) {
                    snakeBody ~= SnakeSegment(tailHead.position.x + 1, tailHead.position.y);
                } else {
                    snakeBody ~= SnakeSegment(tailHead.position.x - 1, tailHead.position.y);
                }
            }
        } else {
            if (dir == Direction.up) {
                snakeBody ~= SnakeSegment(tailHead.position.x, tailHead.position.y + 1);
            } else if (dir == Direction.down) {
                snakeBody ~= SnakeSegment(tailHead.position.x, tailHead.position.y - 1);
            } else if (dir == Direction.left) {
                snakeBody ~= SnakeSegment(tailHead.position.x + 1, tailHead.position.y);
            } else if (dir == Direction.right) {
                snakeBody ~= SnakeSegment(tailHead.position.x - 1, tailHead.position.y);
            }
        }
    }

    void reset() {
        snakeBody = SnakeContainer.init;

        snakeBody ~= SnakeSegment(5, 7);
        snakeBody ~= SnakeSegment(5, 6);
        snakeBody ~= SnakeSegment(5, 5);

        setDirection(Direction.none);

        this.speed = 15;
        this.lives = 3;
        this.score = 0;
        this.lost = false;
    }

    void move() {
        for (int i = cast(int)(snakeBody.length - 1); i > 0; --i) {
            snakeBody[i].position = snakeBody[i - 1].position;
        }

        if (dir == Direction.left) {
            --snakeBody[0].position.x;
        } else if (dir == Direction.right) {
            ++snakeBody[0].position.x;
        } else if (dir == Direction.up) {
            --snakeBody[0].position.y;
        } else if (dir == Direction.down) {
            ++snakeBody[0].position.y;
        }
    }

    void tick() {
        if (snakeBody.length == 0) {
            return;
        }

        if (dir == Direction.none) {
            return;
        }

        move();
        checkCollision();
    }

    void cut(int segments) {

    }

    void render(sfRenderWindow* window) {

    }

    private void checkCollision() {

    }

    private SnakeContainer snakeBody;
    private int size;
    private Direction dir;
    private int speed;
    private  int lives;
    private int score;
    private bool lost;
    private sfRectangleShape* bodyRect;
}
