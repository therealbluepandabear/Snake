module stacklayout;

import bindbc.sfml;
import sfmlextensions;
import std.format;
import std.stdio;
import std.algorithm;

enum StackLayoutType {
    row, column
}

class StackLayout(T) {
    this(StackLayoutType stackLayoutType, sfVector2f position, int spacing = 0) {
        static assert(isDrawable!T, format("Cannot call addChild method on type %s", T.stringof));
        _stackLayoutType = stackLayoutType;
        _spacing = spacing;
        _position = position;
    }

    void render(sfRenderWindow* renderWindow) {
        foreach (T child; _children) {
            renderWindow.sfRenderWindowExt_draw(child);
        }
    }

    void addChild(T child) {
        if (_stackLayoutType == StackLayoutType.row) {
            child.sfDrawableExt_setPosition(sfVector2f(_cursor + (_spacing * _children.length) + _position.x, _position.y));
            _cursor += child.sfDrawableExt_getSize().x;
        } else if (_stackLayoutType == StackLayoutType.column) {
            child.sfDrawableExt_setPosition(sfVector2f(_position.x, _cursor + (_spacing * _children.length) + _position.y));
            _cursor += child.sfDrawableExt_getSize().y;
        }

        _children ~= child;
        updateSize();
    }

    @property {
        T[] children() {
            return _children;
        }

        sfVector2f size() {
            return _size;
        }
    }

    private {
        void updateSize(bool isLast = false) {
            if (_stackLayoutType == StackLayoutType.row) {
                float x = 0;
                foreach (indx, T child; _children) {
                    x += child.sfDrawableExt_getSize().x;

                    if (indx != _children.length && indx != 0) {
                        x += _spacing;
                    }
                }

                _size.x = x;
                _size.y = _children.maxElement!(child => child.sfDrawableExt_getSize().y).sfDrawableExt_getSize().y;
            } else if (_stackLayoutType == StackLayoutType.column) {
                float y = 0;
                foreach (indx, T child; _children) {
                    y += child.sfDrawableExt_getSize().y;

                    if (indx != _children.length && indx != 0) {
                        y += _spacing;
                    }
                }

                _size.x = _children.maxElement!(child => child.sfDrawableExt_getSize().x).sfDrawableExt_getSize().x;
                _size.y = y;
            }
        }

        StackLayoutType _stackLayoutType;
        T[] _children;
        float _cursor = 0;
        sfVector2f _position = sfVector2f(0, 0);
        int _spacing;
        sfVector2f _size = sfVector2f(0, 0);
    }
}
