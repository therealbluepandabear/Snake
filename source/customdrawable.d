module customdrawable;

import bindbc.sfml;

interface ICustomDrawable {
    void render(sfRenderWindow* renderWindow);

    @property {
        sfVector2f size();
    }
}
