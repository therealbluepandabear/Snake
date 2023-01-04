module button;

import bindbc.sfml;
import textbox;
import sfmlextensions;
import std.stdio;
import shapes;

class Button {
    this() {
        _rect = sfRectangleShape_create();
        _textbox = new Textbox();
    }

    void update(sfEvent event, sfRenderWindow* renderWindow) {
        assert(_onButtonClick != null, "_onButtonClick must not be null");

        sfVector2i mousePosition = sfMouse_getPositionRenderWindow(renderWindow);

        if (isMousePositionInBounds(mousePosition)) {
            if (event.type == sfEventType.sfEvtMouseMoved) {
                _rect.sfRectangleShape_setFillColor(_colorHover);
            }

            if (event.type == sfEventType.sfEvtMouseButtonPressed && _executeOnButtonClick) {
                _onButtonClick();
                _executeOnButtonClick = false;
            } else if (event.type == sfEventType.sfEvtMouseButtonReleased) {
                _executeOnButtonClick = true;
            }
        } else {
            _rect.sfRectangleShape_setFillColor(_color);
        }
    }

    void render(sfRenderWindow* renderWindow) {
        renderWindow.sfRenderWindowExt_draw(_rect.sfRectangleShapeExt_toRoundRect(10));
        renderWindow.sfRenderWindowExt_draw(_textbox);
    }

    @property {
        sfVector2f size() {
            return _rect.sfRectangleShape_getSize();
        }

        sfVector2f position() {
            return _rect.sfRectangleShape_getPosition();
        }

        void text(string text) {
            _textbox.text = text;
            _rect.sfRectangleShape_setSize(sfVector2f(_textbox.size.x + 48, 50));
        }

        void onButtonClick(void delegate() onButtonClick) {
            _onButtonClick = onButtonClick;
        }

        void position(sfVector2f position) {
            _rect.sfRectangleShape_setPosition(position);
            _textbox.position = _rect.sfRectangleShapeExt_getCenter(_textbox.size, sfVector2f(0, -4));
        }

        void colorHover(sfColor colorHover) {
            _colorHover = colorHover;
        }

        void color(sfColor color) {
            _color = color;
            _rect.sfRectangleShape_setFillColor(color);
        }
    }

    private {
        bool isMousePositionInBounds(sfVector2i mousePosition) {
            return (mousePosition.x >= _rect.sfRectangleShape_getPosition().x &&
                    mousePosition.x <= _rect.sfRectangleShape_getPosition().x + _rect.sfRectangleShape_getSize().x &&
                    mousePosition.y >= _rect.sfRectangleShape_getPosition().y &&
                    mousePosition.y <= _rect.sfRectangleShape_getPosition().y + _rect.sfRectangleShape_getSize().y);
        }

        Textbox _textbox;
        sfRectangleShape* _rect;
        sfColor _color;
        sfColor _colorHover;
        void delegate() _onButtonClick;
        bool _executeOnButtonClick = true;
    }
}
