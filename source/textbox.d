module textbox;

import bindbc.sfml;
import std.algorithm;
import std.container;
import std.format;
import std.string;
import sfmlextensions;
import customdrawable;

class Textbox : ICustomDrawable {
    this() {
        _text = sfText_create();
        _text.sfText_setFont(sfFont_createFromFile("nunito_black.ttf"));
        _text.sfText_setColor(sfWhite);
        _text.sfText_setCharacterSize(TextSize.medium);
    }

    enum TextSize : short {
        small = 12, medium = 24, large = 36
    }

    override void render(sfRenderWindow* renderWindow) {
        renderWindow.sfRenderWindowExt_draw(_text);
    }

    @property override {
        sfVector2f size() {
            sfFloatRect bounds = _text.sfText_getLocalBounds();
            return sfVector2f(bounds.width, bounds.height);
        }

        sfVector2f position() {
            return _text.sfText_getPosition();
        }

        void position(sfVector2f position) {
            _text.sfText_setPosition(position);
        }
    }

    @property {
        void text(string text) {
            _text.sfText_setString(toStringz(text));
        }

        void textSize(TextSize textSize) {
            _text.sfText_setCharacterSize(textSize);
        }
    }

    private {
        sfText* _text;
    }
}
