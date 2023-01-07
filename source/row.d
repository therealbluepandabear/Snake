module row;

import bindbc.sfml;
import sfmlextensions;
import std.format;
import std.stdio;

class Row(T) {
    this(sfVector2f position, int spacing = 0) {
        static assert(isDrawable!T, format("Cannot call addChild method on type %s", T.stringof));
        _spacing = spacing;
        _position = position;
    }

    void render(sfRenderWindow* renderWindow) {
        foreach (T child; _children) {
            renderWindow.sfRenderWindowExt_draw(child);
        }
    }

    void addChild(T child) {
        child.sfDrawableExt_setPosition(sfVector2f(_cursor + (_spacing * _children.length) + _position.x, _position.y));
        _cursor += child.sfDrawableExt_getSize().x;
        _children ~= child;
    }

    @property {
        T[] children() {
            return _children;
        }
    }

    private {
        T[] _children;
        float _cursor = 0;
        sfVector2f _position;
        int _spacing;
    }
}
