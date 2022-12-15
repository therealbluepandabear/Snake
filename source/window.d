module window;

import bindbc.sfml;

class Window {
    this() {
        setup("Window", sfVector2u(640, 480));
    }

    this(const(string)title, const(sfVector2u) size) {
        setup(title, size);
    }

    ~this() {
        destroy();
    }

    void beginDraw() {
        m_window.sfRenderWindow_clear(sfBlack);
    }

    void endDraw() {
        m_window.sfRenderWindow_display();
    }

    void update() {
        sfEvent event;

        while (m_window.sfRenderWindow_pollEvent(&event)) {
            if (event.type == sfEventType.sfEvtClosed) {
                m_isDone = true;
            } else if ((event.type == sfEventType.sfEvtKeyPressed) && (event.key.code == sfKeyCode.sfKeyF5)) {
                toggleFullscreen();
            }
        }
    }

    bool isDone() {
        return isDone;
    }

    bool isFullscreen() {
        return m_isFullscreen;
    }

    sfVector2u windowSize() {
        return m_windowSize;
    }

    sfRenderWindow* window() {
        return m_window;
    }

    void toggleFullscreen() {
        m_isFullscreen = !m_isFullscreen;
        destroy();
        create();
    }

private:
    void setup(const(string) title, const(sfVector2u) size) {
        m_windowTitle = title;
        m_windowSize = size;
        m_isFullscreen = false;
        m_isDone = false;

        create();
    }

    void destroy() {
        m_window.sfRenderWindow_close();
    }

    void create() {
        sfWindowStyle style = m_isFullscreen ? sfWindowStyle.sfFullscreen : sfWindowStyle.sfDefaultStyle;
        m_window = sfRenderWindow_create(sfVideoMode(m_windowSize.x, m_windowSize.y, 32), cast(const char*)m_windowTitle, style, null);
    }

    sfRenderWindow* m_window;
    sfVector2u m_windowSize;
    string m_windowTitle;
    bool m_isDone;
    bool m_isFullscreen;
}

