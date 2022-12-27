module sfmlextensions;

import std.string;
import bindbc.sfml;

// in the future more checks can be added when more drawable types are used throughout the program
private bool isDrawable(T)(T obj) {
    return (is(T == sfCircleShape*) || is(T == sfRectangleShape*) || is(T == sfText*));
}

void draw(T)(sfRenderWindow* renderWindow, T obj) {
    assert(isDrawable(obj), format("Cannot call any draw method on type %s", T.stringof));

    if (is(T == sfCircleShape*)) {
        renderWindow.sfRenderWindow_drawCircleShape(cast(sfCircleShape*)obj, null);
    } else if (is(T == sfRectangleShape*)) {
        renderWindow.sfRenderWindow_drawRectangleShape(cast(sfRectangleShape*)obj, null);
    } else if (is(T == sfText*)) {
        renderWindow.sfRenderWindow_drawText(cast(sfText*)obj, null);
    }
}