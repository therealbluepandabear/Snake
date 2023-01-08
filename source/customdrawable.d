module customdrawable;

import bindbc.sfml;

interface ICustomDrawable {
    void render(sfRenderWindow* renderWindow);
}
