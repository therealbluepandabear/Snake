module gamesettings;

import std.typecons;

enum BoardSize : Tuple!(int, int) {
    small = tuple(5, 5),
    medium = tuple(20, 20),
    large = tuple(35, 35),
    very_large = tuple(50, 50)
}

struct GameSettings {
    static BoardSize boardSize = BoardSize.medium;
}