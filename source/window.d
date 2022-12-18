module window;

import bindbc.sfml;

class Window {
    this() {
        setup("Snake", sfVector2u(640, 480));
    }

    this(const string title, const sfVector2u size) {
        setup(title, size);
    }

    ~this() {
        destroy();
    }

    bool isDone() {
        return m_isDone;
    }

    bool isFullScreen() {
        return m_isFullScreen;
    }

    sfVector2u windowSize() {
        return m_windowSize;
    }

    sfRenderWindow* renderWindow() {
        return m_renderWindow;
    }

    void beginDraw() {
        m_renderWindow.sfRenderWindow_clear(sfBlack);
    }

    void endDraw() {
        m_renderWindow.sfRenderWindow_display();
    }

    void update() {
        sfEvent event;

        while (m_renderWindow.sfRenderWindow_pollEvent(&event)) {
            if (event.type == sfEventType.sfEvtClosed) {
                m_isDone = true;
            } else if ((event.type == sfEventType.sfEvtKeyPressed) && (event.key.code == sfKeyCode.sfKeyF5)) {
                toggleFullscreen();
            }
        }
    }

    void toggleFullscreen() {
        m_isFullScreen = !m_isFullScreen;
        destroy();
        create();
    }

    void drawSprite(sfSprite* sprite) {
        m_renderWindow.sfRenderWindow_drawSprite(sprite, null);
    }

private:
    void setup(const string title, const sfVector2u size) {
        m_windowTitle = title;
        m_windowSize = size;
        m_isFullScreen = false;
        m_isDone = false;
        create();
    }

    void destroy() {
        m_renderWindow.sfRenderWindow_close();
    }

    void create() {
        sfWindowStyle style = m_isFullScreen ? sfWindowStyle.sfFullscreen : sfWindowStyle.sfDefaultStyle;
        m_renderWindow = sfRenderWindow_create(sfVideoMode(m_windowSize.x, m_windowSize.y, 32), cast(const char*)m_windowTitle, style, null);
    }

    sfRenderWindow* m_renderWindow;
    sfVector2u m_windowSize;
    string m_windowTitle;
    bool m_isDone;
    bool m_isFullScreen;
}

