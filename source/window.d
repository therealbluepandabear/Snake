module window;

import bindbc.sfml;
import std.stdio;
import std.string;

class Window {
    this() {
        setup("Snake", sfVector2u(640, 480));
    }

    this(string title, sfVector2u size) {
        setup(title, size);
    }

    ~this() {
        destroy();
    }

    void beginDraw() {
        _renderWindow.sfRenderWindow_clear(sfBlack);
    }

    void endDraw() {
        _renderWindow.sfRenderWindow_display();
    }

    void update() {
        while (_renderWindow.sfRenderWindow_pollEvent(&_event)) {
            if (_event.type == sfEventType.sfEvtClosed) {
                _isDone = true;
            } else if ((_event.type == sfEventType.sfEvtKeyPressed) && (_event.key.code == sfKeyCode.sfKeyF5)) {
                toggleFullscreen();
            }
        }
    }

    void toggleFullscreen() {
        _isFullScreen = !_isFullScreen;
        destroy();
        create();
    }

    @property {
        bool isDone() {
            return _isDone;
        }

        sfRenderWindow* renderWindow() {
            return _renderWindow;
        }

        sfEvent event() {
            return _event;
        }
    }

    private {
        void setup(string title, sfVector2u size) {
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
            _renderWindow = sfRenderWindow_create(sfVideoMode(_windowSize.x, _windowSize.y, 32), toStringz(_windowTitle), style, null);
        }

        sfRenderWindow* _renderWindow;
        sfVector2u _windowSize;
        string _windowTitle;
        bool _isDone;
        bool _isFullScreen;
        sfEvent _event;
    }
}

