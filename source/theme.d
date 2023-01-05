module theme;

import sfmlextensions;
import bindbc.sfml;

struct Theme {
    static {
        sfColor primaryBackground = sfColorExt_alpha255(189, 183, 107);
        sfColor secondaryBackground = sfColorExt_alpha255(64, 190, 92);
        sfColor buttonBackground = sfColorExt_alpha255(189, 183, 107);
        sfColor buttonHoverBackground = sfColorExt_alpha255(166, 159, 74);
    }
}
