module snake;

import bindbc.sfml;
import std.algorithm;
import std.stdio;
import sfmlextensions;
import std.algorithm;
import std.string;

struct SnakeSegment {
    this(int x, int y) {
        position = sfVector2i(x, y);
    }

    sfVector2i position;
}

enum Direction {
    none, up, down, left, right
}

enum EdgeDirection {
    north_east, north_west, south_east, south_west, none
}

alias SnakeContainer = SnakeSegment[];

ref SnakeSegment head(SnakeContainer container) {
    return container[0];
}

ref SnakeSegment neck(SnakeContainer container) {
    return container[1];
}

bool isEdgeSegment(SnakeContainer container, SnakeSegment snakeSegment) {
    long indx = container.countUntil(snakeSegment);

    return (indx > 0 && indx < (container.length - 1) &&
           ((snakeSegment.position.x == container[indx - 1].position.x && snakeSegment.position.y == container[indx + 1].position.y) ||
           (snakeSegment.position.y == container[indx - 1].position.y && snakeSegment.position.x == container[indx + 1].position.x)));
}

EdgeDirection getEdgeDirection(SnakeContainer container, SnakeSegment snakeSegment) {
    EdgeDirection edgeDirection;
    long indx = container.countUntil(snakeSegment);

    if ((container[indx - 1].position.x < snakeSegment.position.x || container[indx + 1].position.x < snakeSegment.position.x) &&
        (container[indx + 1].position.y > snakeSegment.position.y || container[indx - 1].position.y > snakeSegment.position.y)) {
        edgeDirection = EdgeDirection.north_east;
    } else if ((container[indx - 1].position.x > snakeSegment.position.x || container[indx + 1].position.x > snakeSegment.position.x) &&
        (container[indx + 1].position.y > snakeSegment.position.y || container[indx - 1].position.y > snakeSegment.position.y)) {
        edgeDirection = EdgeDirection.north_west;
    } else if ((container[indx - 1].position.x < snakeSegment.position.x || container[indx + 1].position.x < snakeSegment.position.x) &&
        (container[indx + 1].position.y < snakeSegment.position.y || container[indx - 1].position.y < snakeSegment.position.y)) {
        edgeDirection = EdgeDirection.south_east;
    } else if ((container[indx - 1].position.x > snakeSegment.position.x || container[indx + 1].position.x > snakeSegment.position.x) &&
        (container[indx + 1].position.y < snakeSegment.position.y || container[indx - 1].position.y < snakeSegment.position.y)) {
        edgeDirection = EdgeDirection.south_west;
    }

    return edgeDirection;
}


class Snake {
    this(float size) {
        this._size = size;

        createSprite(_snakeHeadUpSprite, _snakeHeadUpTexture, "snake_head_up.png");
        createSprite(_snakeHeadDownSprite, _snakeHeadDownTexture, "snake_head_down.png");
        createSprite(_snakeHeadLeftSprite, _snakeHeadLeftTexture, "snake_head_left.png");
        createSprite(_snakeHeadRightSprite, _snakeHeadRightTexture, "snake_head_right.png");
        createSprite(_snakeBodySprite1, _snakeBodyTexture1, "snake_body_1.png");
        createSprite(_snakeBodySprite2, _snakeBodyTexture2, "snake_body_2.png");
        createSprite(_snakeEdgeNESprite, _snakeEdgeNETexture, "snake_edge_ne.png");
        createSprite(_snakeEdgeNWSprite, _snakeEdgeNWTexture, "snake_edge_nw.png");
        createSprite(_snakeEdgeSESprite, _snakeEdgeSETexture, "snake_edge_se.png");
        createSprite(_snakeEdgeSWSprite, _snakeEdgeSWTexture, "snake_edge_sw.png");

        reset();
    }

    int speed() {
        return _speed;
    }

    sfVector2i position() {
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

        this._speed = 4;
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
        foreach (indx, snakeSegment; _snakeBody) {
            sfSprite* sprite;

            if (indx == 0) {
                if (getDirection() == Direction.up || getDirection() == Direction.none) {
                    sprite = _snakeHeadUpSprite;
                } else if (getDirection() == Direction.down) {
                    sprite = _snakeHeadDownSprite;
                } else if (getDirection() == Direction.left) {
                    sprite = _snakeHeadLeftSprite;
                } else if (getDirection() == Direction.right) {
                    sprite = _snakeHeadRightSprite;
                }
            } else if (_snakeBody.isEdgeSegment(snakeSegment)) {
                EdgeDirection edgeDirection = _snakeBody.getEdgeDirection(snakeSegment);
                writeln(edgeDirection); stdout.flush();

                if (edgeDirection == EdgeDirection.north_east) {
                    sprite = _snakeEdgeNESprite;
                } else if (edgeDirection == EdgeDirection.north_west) {
                    sprite = _snakeEdgeNWSprite;
                } else if (edgeDirection == EdgeDirection.south_east) {
                    sprite = _snakeEdgeSESprite;
                } else if (edgeDirection == EdgeDirection.south_west) {
                    sprite = _snakeEdgeSWSprite;
                }
            } else if (indx % 2 == 0) {
                sprite = _snakeBodySprite2;
            } else {
                sprite = _snakeBodySprite1;
            }

            sprite.sfSprite_setPosition(sfVector2f(snakeSegment.position.x * _size, snakeSegment.position.y * _size));
            renderWindow.draw(sprite);
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

    void createSprite(ref sfSprite* sprite, ref sfTexture* texture, string src) {
        texture = sfTexture_createFromFile(toStringz(src), null);
        sprite = sfSprite_create();
        sprite.sfSprite_setTexture(texture, 0);
        sprite.sizeToBounds(texture, sfVector2f(size, size));
    }

    SnakeContainer _snakeBody;
    float _size;
    Direction _dir = Direction.none;
    int _speed;
    int _score;
    bool _lost;
    sfTexture* _snakeHeadUpTexture;
    sfSprite* _snakeHeadUpSprite;
    sfTexture* _snakeHeadDownTexture;
    sfSprite* _snakeHeadDownSprite;
    sfTexture* _snakeHeadLeftTexture;
    sfSprite* _snakeHeadLeftSprite;
    sfTexture* _snakeHeadRightTexture;
    sfSprite* _snakeHeadRightSprite;
    sfTexture* _snakeBodyTexture1;
    sfSprite* _snakeBodySprite1;
    sfTexture* _snakeBodyTexture2;
    sfSprite* _snakeBodySprite2;
    sfTexture* _snakeEdgeNETexture;
    sfSprite* _snakeEdgeNESprite;
    sfTexture* _snakeEdgeNWTexture;
    sfSprite* _snakeEdgeNWSprite;
    sfTexture* _snakeEdgeSETexture;
    sfSprite* _snakeEdgeSESprite;
    sfTexture* _snakeEdgeSWTexture;
    sfSprite* _snakeEdgeSWSprite;
}
