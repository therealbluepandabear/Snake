module textbox;

import bindbc.sfml;
import std.algorithm;
import std.container;
import std.format;
import std.string;
import sfmlextensions;

class Textbox {
    this(sfVector2f position, string text = "") {
        _text = sfText_create();
        _text.sfText_setFont(sfFont_createFromFile("nunito_black.ttf"));
        _text.sfText_setCharacterSize(24);
        _text.sfText_setColor(sfWhite);
        _text.sfText_setPosition(position);
        _text.sfText_setString(toStringz(text));
    }

    void setText(string text) {
        _text.sfText_setString(toStringz(text));
    }

    void setPosition(sfVector2f position) {
        _text.sfText_setPosition(position);
    }

    sfVector2f getSize() {
        const auto bounds = _text.sfText_getLocalBounds();
        return sfVector2f(bounds.width, bounds.height);
    }

    void render(sfRenderWindow* renderWindow) {
        assert(_text.sfText_getString() != "", "text must not be null");
        renderWindow.sfRenderWindowExt_draw(_text);
    }

private:
    sfText* _text;
}
