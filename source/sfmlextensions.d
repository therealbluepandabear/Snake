module sfmlextensions;

import std.string;
import bindbc.sfml;
import shapes;
import std.stdio;
import button;
import textbox;
import shapes;
import customdrawable;
import std.conv;

enum isDrawable(T) = is(T == sfCircleShape*) || is(T == sfRectangleShape*) || is(T == sfText*) || is(T == sfSprite*) || is(T : ICustomDrawable);

void sfRenderWindowExt_draw(T)(sfRenderWindow* renderWindow, T drawable) {
    static assert(isDrawable!T, format("Cannot call any draw method on type %s", T.stringof));

    static if (is(T == sfCircleShape*)) {
        renderWindow.sfRenderWindow_drawCircleShape(drawable, null);
    } else static if (is(T == sfRectangleShape*)) {
        renderWindow.sfRenderWindow_drawRectangleShape(drawable, null);
    } else static if (is(T == sfText*)) {
        renderWindow.sfRenderWindow_drawText(drawable, null);
    } else static if (is(T == sfSprite*)) {
        renderWindow.sfRenderWindow_drawSprite(drawable, null);
    } else static if (is(T : ICustomDrawable)) {
        drawable.render(renderWindow);
    }
}

void sfDrawableExt_setPosition(T)(T drawable, sfVector2f vector) {
    static assert(isDrawable!T, format("Cannot call any setPosition method on type %s", T.stringof));

    static if (is(T == Button)) {
        drawable.position = vector;
    }
}

void sfRenderWindowExt_drawArray(T)(sfRenderWindow* renderWindow, T[] arr) {
    foreach (T t; arr) {
        renderWindow.sfRenderWindowExt_draw(t);
    }
}

sfVector2i sfVector2fExt_toVector2i(sfVector2f vector) {
    return sfVector2i(cast(int)vector.x, cast(int)vector.y);
}

sfVector2f sfVector2uExt_toVector2f(sfVector2u vector) {
    return sfVector2f(cast(float)vector.x, cast(float)vector.y);
}

sfVector2f sfVector2fExt_splat(float size) {
    return sfVector2f(size, size);
}

sfVector2f sfVector2fExt_plus(sfVector2f left, sfVector2f right) {
    return sfVector2f(left.x + right.x, left.y + right.y);
}

void sfSpriteExt_sizeToBounds(sfSprite* sprite, sfTexture* texture, sfVector2f bounds) {
    sprite.sfSprite_setScale(sfVector2f(bounds.x / texture.sfTexture_getSize().x, bounds.y / texture.sfTexture_getSize().y));
}

sfVector2f sfSpriteExt_getSize(sfSprite* sprite) {
    return sfVector2f(sprite.sfSprite_getGlobalBounds().width, sprite.sfSprite_getGlobalBounds().height);
}

sfVector2f sfRectangleShapeExt_getCenter(sfRectangleShape* rect, sfVector2f bounds, sfVector2f offset = sfVector2fExt_splat(0)) {
    return sfVector2f(
            ((rect.sfRectangleShape_getPosition().x + rect.sfRectangleShape_getSize().x / 2) - (bounds.x / 2)) + offset.x,
            ((rect.sfRectangleShape_getPosition().y + rect.sfRectangleShape_getSize().y / 2) - (bounds.y / 2)) + offset.y);
}

RoundRect sfRectangleShapeExt_toRoundRect(sfRectangleShape* rect, float cornerRadius) {
    return new RoundRect(cornerRadius, rect.sfRectangleShape_getSize(), rect.sfRectangleShape_getPosition(), rect.sfRectangleShape_getFillColor());
}

sfColor sfColorExt_alpha255(ubyte r, ubyte g, ubyte b) {
    return sfColor(r, g, b, 255);
}