module clickable;

import customdrawable;
import bindbc.sfml;

class Clickable : ICustomDrawable {
    this(ICustomDrawable drawable, void delegate() onClick) {
        _drawable = drawable;
        _onClick = onClick;
    }

    override void render(sfRenderWindow* renderWindow) {
        _drawable.render(renderWindow);
    }

    void update(sfEvent event, sfRenderWindow* renderWindow) {
        assert(_onClick != null, "_onClick must not be null");

        sfVector2i mousePosition = sfMouse_getPositionRenderWindow(renderWindow);

        if (isMousePositionInBounds(mousePosition)) {
            if (event.type == sfEventType.sfEvtMouseButtonPressed) {
                _executeOnClick = true;
            } else if (event.type == sfEventType.sfEvtMouseButtonReleased && _executeOnClick) {
                _onClick();
                _executeOnClick = false;
            }
        }
    }

    @property override {
        sfVector2f size() {
            return _drawable.size;
        }

        sfVector2f position() {
            return _drawable.position;
        }

        void position(sfVector2f position) {
            _drawable.position(position);
        }
    }

    private {
        bool isMousePositionInBounds(sfVector2i mousePosition) {
            return (mousePosition.x >= _drawable.position.x &&
                    mousePosition.x <= _drawable.position.x + _drawable.position.x &&
                    mousePosition.y >= _drawable.position.y &&
                    mousePosition.y <= _drawable.position.y + _drawable.position.y);
        }

        ICustomDrawable _drawable;
        void delegate() _onClick;
        bool _executeOnClick = false;
    }
}
