module button;

import bindbc.sfml;
import textbox;
import sfmlextensions;
import std.stdio;

class Button {
    this(sfColor backgroundColor, sfColor colorHover, sfVector2f position, string text, void delegate() onButtonClick) {
        _backgroundColor = backgroundColor;
        _colorHover = colorHover;

        _onButtonClick = onButtonClick;

        _rect = sfRectangleShape_create();
        _rect.sfRectangleShape_setFillColor(backgroundColor);
        _rect.sfRectangleShape_setSize(sfVector2f(150, 50));
        _rect.sfRectangleShape_setPosition(position);

        _textbox = new Textbox(sfVector2fExt_splat(0), text);
        _textbox.setPosition(_rect.sfRectangleShapeExt_getCenter(_textbox.getSize(), sfVector2f(0, -3)));
    }

    sfVector2f getSize() {
        return _rect.sfRectangleShape_getSize();
    }

    void setPosition(sfVector2f position) {
        _rect.sfRectangleShape_setPosition(position);
        _textbox.setPosition(sfVector2f(_textbox.getPosition().x + position.x, _textbox.getPosition().y + position.y));
    }

    void update(sfEvent event, sfRenderWindow* renderWindow) {
        sfVector2i mousePosition = sfMouse_getPositionRenderWindow(renderWindow);

        if (isMousePositionInBounds(mousePosition)) {
            if (event.type == sfEventType.sfEvtMouseMoved) {
                _rect.sfRectangleShape_setFillColor(_colorHover);
            }

            if (event.type == sfEventType.sfEvtMouseButtonPressed && _excOnButtonClick) {
                _onButtonClick();
                _excOnButtonClick = false;
            } else if (event.type == sfEventType.sfEvtMouseButtonReleased) {
                _excOnButtonClick = true;
            }
        } else {
            _rect.sfRectangleShape_setFillColor(_backgroundColor);
        }
    }

    void render(sfRenderWindow* renderWindow) {
        renderWindow.sfRenderWindowExt_draw(_rect);
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
    sfColor _backgroundColor;
    sfColor _colorHover;
    void delegate() _onButtonClick;
    bool _excOnButtonClick = true;
}
