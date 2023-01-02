module textbox;

import bindbc.sfml;
import std.algorithm;
import std.container;
import std.format;
import std.string;
import sfmlextensions;

class Textbox {
    this() {
        _text = sfText_create();
        _text.sfText_setFont(sfFont_createFromFile("nunito_black.ttf"));
        _text.sfText_setColor(sfWhite);
        _text.sfText_setCharacterSize(TextSize.medium);
    }

    enum TextSize {
        small = 12, medium = 24, large = 36
    }

    void setText(string text) {
        _text.sfText_setString(toStringz(text));
    }

    void setTextSize(TextSize textSize) {
        _text.sfText_setCharacterSize(textSize);
    }

    void setPosition(sfVector2f position) {
        _text.sfText_setPosition(position);
    }

    sfVector2f getPosition() {
        return _text.sfText_getPosition();
    }

    sfVector2f getSize() {
        sfFloatRect bounds = _text.sfText_getLocalBounds();
        return sfVector2f(bounds.width, bounds.height);
    }

    void render(sfRenderWindow* renderWindow) {
        renderWindow.sfRenderWindowExt_draw(_text);
    }

private:
    sfText* _text;
}
