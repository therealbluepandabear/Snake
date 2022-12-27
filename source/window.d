module window;

import bindbc.sfml;

class Window {
    this() {
        setup("Snake", sfVector2u(640, 480));
    }

    this(const(string) title, const(sfVector2u) size) {
        setup(title, size);
    }

    ~this() {
        destroy();
    }

    bool isDone() {
        return _isDone;
    }

    sfRenderWindow* renderWindow() {
        return _renderWindow;
    }

    void beginDraw() {
        _renderWindow.sfRenderWindow_clear(sfBlack);
    }

    void endDraw() {
        _renderWindow.sfRenderWindow_display();
    }

    void update() {
        sfEvent event;

        while (_renderWindow.sfRenderWindow_pollEvent(&event)) {
            if (event.type == sfEventType.sfEvtClosed) {
                _isDone = true;
            } else if ((event.type == sfEventType.sfEvtKeyPressed) && (event.key.code == sfKeyCode.sfKeyF5)) {
                toggleFullscreen();
            }
        }
    }

    void toggleFullscreen() {
        _isFullScreen = !_isFullScreen;
        destroy();
        create();
    }

private:
    void setup(const(string) title, const(sfVector2u) size) {
        _windowTitle = title;
        _windowSize = size;
        _isFullScreen = false;
        _isDone = false;
        create();
    }

    void destroy() {
        _renderWindow.sfRenderWindow_close();
    }

    void create() {
        sfWindowStyle style = _isFullScreen ? sfWindowStyle.sfFullscreen : sfWindowStyle.sfDefaultStyle;
        _renderWindow = sfRenderWindow_create(sfVideoMode(_windowSize.x, _windowSize.y, 32), cast(const char*)_windowTitle, style, null);
    }

    sfRenderWindow* _renderWindow;
    sfVector2u _windowSize;
    string _windowTitle;
    bool _isDone;
    bool _isFullScreen;
}

