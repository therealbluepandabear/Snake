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

    override {
        void render(sfRenderWindow* renderWindow) {
            if (_visibility == Visibility.hidden) {
                sfColor currentColor = _text.sfText_getColor();
                _text.sfText_setColor(sfColor(currentColor.r, currentColor.g, currentColor.b, 0));
            } else {
                _text.sfText_setColor(sfWhite);
            }
            renderWindow.sfRenderWindowExt_draw(_text);
        }
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
        Visibility visibility() {
            return _visibility;
        }

        void text(string text) {
            _text.sfText_setString(toStringz(text));
        }

        void textSize(TextSize textSize) {
            _text.sfText_setCharacterSize(textSize);
        }

        void visibility(Visibility visibility) {
            _visibility = visibility;
        }
    }

    static {
        enum Visibility {
            visible, hidden
        }
    }

    private {
        sfText* _text;
        Visibility _visibility = Visibility.visible;
    }
}
