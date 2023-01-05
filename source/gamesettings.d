module gamesettings;

import std.typecons;

enum BoardSize : Tuple!(int, int) {
    small = tuple(5, 5),
    medium = tuple(20, 20),
    large = tuple(35, 35)
}

struct GameSettings {
    static BoardSize boardSize = BoardSize.medium;
}