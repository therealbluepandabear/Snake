module roundrect;

import bindbc.sfml;
import sfmlextensions;

void roundRectExt_renderArray(RoundRect[] arr, sfRenderWindow* renderWindow) {
    foreach (RoundRect rect; arr) {
        rect.render(renderWindow);
    }
}

class RoundRect {
    this(float cornerRadius, sfVector2f size, sfVector2f position, sfColor color) {
        assert((cornerRadius <= size.x / 2) && (cornerRadius <= size.y / 2), "cornerRadius too large");

        float diameter = cornerRadius * 2;
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

    void render(sfRenderWindow* renderWindow) {
        renderWindow.sfRenderWindowExt_drawArray(_circles);
        renderWindow.sfRenderWindowExt_drawArray(_rects);
    }

private:
    sfCircleShape*[4] _circles;
    sfRectangleShape*[2] _rects;
}
