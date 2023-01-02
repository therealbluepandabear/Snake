module button;

import bindbc.sfml;
import textbox;
import sfmlextensions;
import std.stdio;
import roundrect;

class Button {
    this() {
        _rect = sfRectangleShape_create();
        _rect.sfRectangleShape_setSize(sfVector2f(150, 50));
        _rect.sfRectangleShape_setPosition(sfVector2f(150, 50));
        _rect.sfRectangleShape_setFillColor(sfRed);
        _textbox = new Textbox();
    }

    sfVector2f getSize() {
        return _rect.sfRectangleShape_getSize();
    }

    void setText(string text) {
        _textbox.setText(text);
    }

    void setOnButtonClick(void delegate() onButtonClick) {
        _onButtonClick = onButtonClick;
    }

    void setPosition(sfVector2f position) {
        _rect.sfRectangleShape_setPosition(position);
        _textbox.setPosition(_rect.sfRectangleShapeExt_getCenter(_textbox.getSize(), sfVector2f(0, -3)));
    }

    void setColorHover(sfColor colorHover) {
        _colorHover = colorHover;
    }

    void setColor(sfColor color) {
        _color = color;
    }

    void update(sfEvent event, sfRenderWindow* renderWindow) {
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
        _rect.sfRectangleShapeExt_toRoundRect(10).render(renderWindow);
        _textbox.render(renderWindow);
    }

private:
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
