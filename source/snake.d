module snake;

import bindbc.sfml;
import std.algorithm;
import std.stdio;

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
        this.m_size = size;

        m_bodyRect = sfRectangleShape_create();
        m_bodyRect.sfRectangleShape_setSize(sfVector2f(size, size));

        reset();
    }

    int speed() {
        return m_speed;
    }

    sfVector2i pos() {
        return (!(m_snakeBody.length == 0)) ? m_snakeBody[0].position : sfVector2i(1, 1);
    }

    int lives() {
        return m_lives;
    }

    int score() {
        return m_score;
    }

    void incScore() {
        ++m_score;
    }

    bool lost() {
        return m_lost;
    }

    void dir(Direction dir) {
        this.m_dir = dir;
    }

    void lose() {
        this.m_lost = true;
    }

    void toggleLost() {
        this.m_lost = !m_lost;
    }

    void extend() {
        if (m_snakeBody.length == 0) {
            return;
        }

        SnakeSegment tailHead = m_snakeBody[m_snakeBody.length - 1];

        if (m_snakeBody.length > 1) {
            SnakeSegment tailBone = m_snakeBody[m_snakeBody.length - 2];

            if (tailHead.position.x == tailBone.position.x) {
                if (tailHead.position.y > tailBone.position.y) {
                    m_snakeBody ~= SnakeSegment(tailHead.position.x, tailHead.position.y + 1);
                } else {
                    m_snakeBody ~= SnakeSegment(tailHead.position.x, tailHead.position.y - 1);
                }
            } else if (tailHead.position.y == tailBone.position.y) {
                if (tailHead.position.x > tailBone.position.x) {
                    m_snakeBody ~= SnakeSegment(tailHead.position.x + 1, tailHead.position.y);
                } else {
                    m_snakeBody ~= SnakeSegment(tailHead.position.x - 1, tailHead.position.y);
                }
            }
        } else {
            if (m_dir == Direction.up) {
                m_snakeBody ~= SnakeSegment(tailHead.position.x, tailHead.position.y + 1);
            } else if (m_dir == Direction.down) {
                m_snakeBody ~= SnakeSegment(tailHead.position.x, tailHead.position.y - 1);
            } else if (m_dir == Direction.left) {
                m_snakeBody ~= SnakeSegment(tailHead.position.x + 1, tailHead.position.y);
            } else if (m_dir == Direction.right) {
                m_snakeBody ~= SnakeSegment(tailHead.position.x - 1, tailHead.position.y);
            }
        }
    }

    void reset() {
        m_snakeBody = SnakeContainer.init;

        m_snakeBody ~= SnakeSegment(5, 7);
        m_snakeBody ~= SnakeSegment(5, 6);
        m_snakeBody ~= SnakeSegment(5, 5);

        this.m_speed = 10;
        this.m_lives = 3;
        this.m_score = 0;
        this.m_lost = false;
    }

    void move() {
        for (int i = cast(int)(m_snakeBody.length - 1); i > 0; --i) {
            m_snakeBody[i].position = m_snakeBody[i - 1].position;
        }

        if (m_dir == Direction.left) {
            --m_snakeBody[0].position.x;
        } else if (m_dir == Direction.right) {
            ++m_snakeBody[0].position.x;
        } else if (m_dir == Direction.up) {
            --m_snakeBody[0].position.y;
        } else if (m_dir == Direction.down) {
            ++m_snakeBody[0].position.y;
        }
    }

    void tick() {
        if (getDirection() == Direction.none) {
            return;
        }

        move();
        checkCollision();
    }

    void render(sfRenderWindow* renderWindow) {
        if (m_snakeBody.length == 0) {
            return;
        }

        SnakeSegment head = m_snakeBody[0];

        m_bodyRect.sfRectangleShape_setFillColor(sfBlue);
        m_bodyRect.sfRectangleShape_setPosition(sfVector2f(head.position.x * m_size, head.position.y * m_size));

        renderWindow.sfRenderWindow_drawRectangleShape(m_bodyRect, null);

        m_bodyRect.sfRectangleShape_setFillColor(sfColor(173, 216, 230, 255));

        for (int i = 1; i < m_snakeBody.length; ++i) {
            m_bodyRect.sfRectangleShape_setPosition(sfVector2f(m_snakeBody[i].position.x * m_size, m_snakeBody[i].position.y * m_size));
            renderWindow.sfRenderWindow_drawRectangleShape(m_bodyRect, null);
        }
    }

    Direction getDirection() {
        SnakeSegment head = m_snakeBody[0];
        SnakeSegment neck = m_snakeBody[1];

        Direction dir;

        if (m_snakeBody.length <= 1) {
            dir = Direction.none;
        }

        if (head.position.x == neck.position.x) {
            if (head.position.y > neck.position.y) {
                dir = Direction.down;
            } else {
                dir = Direction.up;
            }
        } else if (head.position.y == neck.position.y) {
            if (head.position.x > neck.position.x) {
                dir = Direction.right;
            } else {
                dir = Direction.left;
            }
        } else {
            dir = Direction.none;
        }

        return dir;
    }

private:
    void checkCollision() {
        if (m_snakeBody.length < 5) {
            return;
        }

        SnakeSegment head = m_snakeBody[0];

        for (int i = 1; i < m_snakeBody.length; ++i) {
            if (m_snakeBody[i].position == head.position) {
                lose();
                break;
            }
        }
    }

    SnakeContainer m_snakeBody;
    int m_size;
    Direction m_dir;
    int m_speed;
    int m_lives;
    int m_score;
    bool m_lost;
    sfRectangleShape* m_bodyRect;
}
