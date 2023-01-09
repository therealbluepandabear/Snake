module stacklayout;

import bindbc.sfml;
import sfmlextensions;
import std.format;
import std.stdio;
import std.algorithm;
import customdrawable;
import button;

enum StackLayoutType {
    row, column
}

class StackLayout : ICustomDrawable {
    this(StackLayoutType stackLayoutType, sfVector2f position, int spacing = 0) {
        _stackLayoutType = stackLayoutType;
        _spacing = spacing;
        _position = position;
    }

    override void render(sfRenderWindow* renderWindow) {
        foreach (ICustomDrawable child; _children) {
            renderWindow.sfRenderWindowExt_draw(child);
        }
    }

    void addChild(T)(T child) {
        static assert(is(T : ICustomDrawable), "Invalid type T for child");

        if (_stackLayoutType == StackLayoutType.row) {
            child.position = sfVector2f(_cursor + (_spacing * _children.length) + _position.x, _position.y);
            _cursor += child.size.x;
        } else if (_stackLayoutType == StackLayoutType.column) {
            child.position = sfVector2f(_position.x, _cursor + (_spacing * _children.length) + _position.y);
            _cursor += child.size.y;
        }

        _children ~= child;
        updateSize();
    }

    @property override {
        sfVector2f size() {
            return _size;
        }

        sfVector2f position() {
            return _position;
        }

        void position(sfVector2f position) {

        }
    }

    @property {
        ICustomDrawable[] children() {
            return _children;
        }
    }

    private {
        void updateSize(bool isLast = false) {
            assert(_children.length > 0);

            if (_stackLayoutType == StackLayoutType.row) {
                float x = 0;
                foreach (indx, ICustomDrawable child; _children) {
                    x += child.size.x;

                    if (indx != _children.length && indx != 0) {
                        x += _spacing;
                    }
                }

                _size.x = x;
                _size.y = _children.maxElement!(child => child.size.y).size.y;
            } else if (_stackLayoutType == StackLayoutType.column) {
                float y = 0;
                foreach (indx, ICustomDrawable child; _children) {
                    y += child.size.y;

                    if (indx != _children.length && indx != 0) {
                        y += _spacing;
                    }
                }

                _size.x = _children.maxElement!(child => child.size.x).size.x;
                _size.y = y;
            }
        }

        StackLayoutType _stackLayoutType;
        ICustomDrawable[] _children;
        float _cursor = 0;
        int _spacing;
        sfVector2f _position = sfVector2f(0, 0);
        sfVector2f _size = sfVector2f(0, 0);
    }
}
