module gamesettings;

import std.typecons;

enum BoardSize : Tuple!(uint, uint) {
    small = tuple(5u, 5u),
    medium = tuple(20u, 20u),
    large = tuple(35u, 35u)
}

struct GameSettings {
    static BoardSize boardSize = BoardSize.medium;
}