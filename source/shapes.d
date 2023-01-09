module shapes;

import bindbc.sfml;
import sfmlextensions;
import customdrawable;
import object;

class RoundRect : ICustomDrawable {
    this(float cornerRadius, sfVector2f size, sfVector2f position, sfColor color) {
        initialize(cornerRadius, size, position, color);
    }

    override void render(sfRenderWindow* renderWindow) {
        renderWindow.sfRenderWindowExt_drawArray(_circles);
        renderWindow.sfRenderWindowExt_drawArray(_rects);
    }

    @property override {
        sfVector2f size() {
            return _size;
        }

        sfVector2f position() {
            return _position;
        }

        void position(sfVector2f position) {
            initialize(_cornerRadius, _size, position, _color);
        }
    }

    private {
        void initialize(float cornerRadius, sfVector2f size, sfVector2f position, sfColor color) {
            assert((cornerRadius <= size.x / 2) && (cornerRadius <= size.y / 2), "cornerRadius too large");

            _cornerRadius = cornerRadius;
            _size = size;
            _position = position;
            _color = color;

            float diameter= cornerRadius * 2;
            sfVector2f shapePosition;
            foreach (indx, ref sfCircleShape* circle; _circles) {
                circle = sfCircleShape_create();
                circle.sfCircleShape_setFillColor(color);
                circle.sfCircleShape_setRadius(cornerRadius);

                if (indx == 0) {
                    shapePosition = sfVector2f(position.x, position.y);
                } else if (indx == 1) {
                    shapePosition = sfVector2f(position.x + size.x - diameter, position.y);
                } else if (indx == 2) {
                    shapePosition = sfVector2f(position.x, position.y + size.y - diameter);
                } else if (indx == 3) {
                    shapePosition = sfVector2f(position.x + size.x - diameter, position.y + size.y - diameter);
                }

                circle.sfCircleShape_setPosition(shapePosition);
            }

            sfVector2f shapeSize;
            foreach (indx, ref sfRectangleShape* rect; _rects) {
                rect = sfRectangleShape_create();
                rect.sfRectangleShape_setFillColor(color);

                if (indx == 0) {
                    shapePosition = sfVector2f(position.x + cornerRadius, position.y);
                    shapeSize = sfVector2f(size.x - diameter, size.y);
                } else if (indx == 1) {
                    shapePosition = sfVector2f(position.x, position.y + cornerRadius);
                    shapeSize = sfVector2f(size.x, size.y - diameter);
                }

                rect.sfRectangleShape_setPosition(shapePosition);
                rect.sfRectangleShape_setSize(shapeSize);
            }
        }

        sfCircleShape*[4] _circles;
        sfRectangleShape*[2] _rects;
        float _cornerRadius = 0;
        sfVector2f _size = sfVector2f(0, 0);
        sfVector2f _position = sfVector2f(0, 0);
        sfColor _color;
    }
}