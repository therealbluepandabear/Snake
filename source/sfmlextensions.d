module sfmlextensions;

import std.string;
import bindbc.sfml;

// in the future more checks can be added when more drawable types are used throughout the program
private bool isDrawable(T)(T obj) {
    return (is(T == sfCircleShape*) || is(T == sfRectangleShape*) || is(T == sfText*) || is(T == sfSprite*));
}

void draw(T)(sfRenderWindow* renderWindow, T obj) {
    assert(isDrawable(obj), format("Cannot call any draw method on type %s", T.stringof));

    if (is(T == sfCircleShape*)) {
        renderWindow.sfRenderWindow_drawCircleShape(cast(sfCircleShape*)obj, null);
    } else if (is(T == sfRectangleShape*)) {
        renderWindow.sfRenderWindow_drawRectangleShape(cast(sfRectangleShape*)obj, null);
    } else if (is(T == sfText*)) {
        renderWindow.sfRenderWindow_drawText(cast(sfText*)obj, null);
    } else if (is(T == sfSprite*)) {
        renderWindow.sfRenderWindow_drawSprite(cast(sfSprite*)obj, null);
    }
}

sfVector2i toVector2i(sfVector2f vector) {
    return sfVector2i(cast(int)vector.x, cast(int)vector.y);
}

sfVector2f sfVector2f_splat(float size) {
    return sfVector2f(size, size);
}

void sizeToBounds(sfSprite* sprite, sfTexture* texture, sfVector2f bounds) {
    sprite.sfSprite_setScale(sfVector2f(bounds.x / texture.sfTexture_getSize().x, bounds.y / texture.sfTexture_getSize().y));
}