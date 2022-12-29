module snake;

import bindbc.sfml;
import std.algorithm;
import std.stdio;
import sfmlextensions;

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

ref SnakeSegment head(SnakeContainer container) {
    return container[0];
}

ref SnakeSegment neck(SnakeContainer container) {
    return container[1];
}

class Snake {
    this(float size) {
        this._size = size;

        this._bodyRect = sfRectangleShape_create();
        _bodyRect.sfRectangleShape_setSize(sfVector2f(size, size));

        reset();
    }

    int speed() {
        return _speed;
    }

    sfVector2i pos() {
        return (!(_snakeBody.length == 0)) ? _snakeBody.head.position : sfVector2i(1, 1);
    }

    SnakeContainer snakeBody() {
        return _snakeBody;
    }

    int score() {
        return _score;
    }

    void incScore() {
        ++_score;
    }

    bool lost() {
        return _lost;
    }

    float size() {
        return _size;
    }

    void dir(Direction dir) {
        this._dir = dir;
    }

    void lose() {
        this._lost = true;
    }

    void extend() {
        if (_snakeBody.length == 0) {
            return;
        }

        SnakeSegment tailHead = _snakeBody[_snakeBody.length - 1];

        if (_snakeBody.length > 1) {
            SnakeSegment tailBone = _snakeBody[_snakeBody.length - 2];

            if (tailHead.position.x == tailBone.position.x) {
                if (tailHead.position.y > tailBone.position.y) {
                    _snakeBody ~= SnakeSegment(tailHead.position.x, tailHead.position.y + 1);
                } else {
                    _snakeBody ~= SnakeSegment(tailHead.position.x, tailHead.position.y - 1);
                }
            } else if (tailHead.position.y == tailBone.position.y) {
                if (tailHead.position.x > tailBone.position.x) {
                    _snakeBody ~= SnakeSegment(tailHead.position.x + 1, tailHead.position.y);
                } else {
                    _snakeBody ~= SnakeSegment(tailHead.position.x - 1, tailHead.position.y);
                }
            }
        } else {
            if (_dir == Direction.up) {
                _snakeBody ~= SnakeSegment(tailHead.position.x, tailHead.position.y + 1);
            } else if (_dir == Direction.down) {
                _snakeBody ~= SnakeSegment(tailHead.position.x, tailHead.position.y - 1);
            } else if (_dir == Direction.left) {
                _snakeBody ~= SnakeSegment(tailHead.position.x + 1, tailHead.position.y);
            } else if (_dir == Direction.right) {
                _snakeBody ~= SnakeSegment(tailHead.position.x - 1, tailHead.position.y);
            }
        }
    }

    void reset() {
        this._snakeBody = SnakeContainer.init;

        _snakeBody ~= SnakeSegment(0, 0);
        _snakeBody ~= SnakeSegment(0, 1);

        this._speed = 10;
        this._score = 0;
        this._lost = false;
    }

    void move() {
        if (_dir == Direction.none) {
            return;
        }

        for (int i = cast(int)(_snakeBody.length - 1); i > 0; --i) {
            _snakeBody[i].position = _snakeBody[i - 1].position;
        }

        if (_dir == Direction.left) {
            --_snakeBody.head.position.x;
        } else if (_dir == Direction.right) {
            ++_snakeBody.head.position.x;
        } else if (_dir == Direction.up) {
            --_snakeBody.head.position.y;
        } else if (_dir == Direction.down) {
            ++_snakeBody.head.position.y;
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
        for (int i = 0; i < _snakeBody.length; ++i) {
            if (i == 0) {
                _bodyRect.sfRectangleShape_setFillColor(sfBlue);
            } else {
                _bodyRect.sfRectangleShape_setFillColor(sfColor(173, 216, 230, 255));
            }

            _bodyRect.sfRectangleShape_setPosition(sfVector2f(_snakeBody[i].position.x * _size, _snakeBody[i].position.y * _size));
            renderWindow.draw(_bodyRect);
        }
    }

    Direction getDirection() {
        Direction dir = Direction.none;

        if (_snakeBody.head.position.x == _snakeBody.neck.position.x) {
            if (_snakeBody.head.position.y > _snakeBody.neck.position.y) {
                dir = Direction.down;
            } else {
                dir = Direction.up;
            }
        } else if (_snakeBody.head.position.y == _snakeBody.neck.position.y) {
            if (_snakeBody.head.position.x > _snakeBody.neck.position.x) {
                dir = Direction.right;
            } else {
                dir = Direction.left;
            }
        }

        return dir;
    }

private:
    void checkCollision() {
        if (_snakeBody.length < 5) {
            return;
        }

        for (int i = 1; i < _snakeBody.length; ++i) {
            if (_snakeBody[i].position == _snakeBody.head.position) {
                lose();
                break;
            }
        }
    }

    SnakeContainer _snakeBody;
    float _size;
    Direction _dir = Direction.none;
    int _speed;
    int _score;
    bool _lost;
    sfRectangleShape* _bodyRect;
}
