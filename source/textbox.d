module textbox;

import bindbc.sfml;
import std.algorithm;
import std.container;
import std.format;
import std.string;
import sfmlextensions;

class Textbox {
    this(sfVector2f pos) {
        _text = sfText_create();
        _text.sfText_setFont(sfFont_createFromFile("nunito_black.ttf"));
        _text.sfText_setCharacterSize(24);
        _text.sfText_setColor(sfWhite);
        _text.sfText_setPosition(pos);
    }

    sfText* text() {
        return _text;
    }

    void render(sfRenderWindow* renderWindow, string content) {
        _text.sfText_setString(toStringz(content));
        renderWindow.sfRenderWindowExt_draw(_text);
    }

private:
    sfText* _text;
}
