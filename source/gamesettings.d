module gamesettings;

import std.typecons;
import std.stdio;
import std.json;
import std.file;
import std.string;
import std.conv;

enum BoardSize : Tuple!(int, int) {
    small = tuple(5, 5),
    medium = tuple(20, 20),
    large = tuple(35, 35),
    very_large = tuple(50, 50)
}

class GameSettings {
    static this() {
        file =  File(_fileName, "a+");
        load();
    }

    @property static {
        BoardSize boardSize() {
            return _boardSize;
        }

        void boardSize(BoardSize boardSize) {
            _boardSize = boardSize;
            writeBoardSize(boardSize);
        }
    }

    private static {
        void writeBoardSize(BoardSize boardSize) {
            JSONValue json = [_json_boardSize : to!string(boardSize)];
            file = File(_fileName, "w");
            file.writeln(json.toPrettyString());
        }

        void load() {
            char[] content = cast(char[])(read(_fileName));

            if (content == "") {
                writeBoardSize(BoardSize.medium);
            } else {
                JSONValue json = parseJSON(content);
                _boardSize = to!BoardSize(json[_json_boardSize].str);
            }
        }

        File file;
        string _json_boardSize = "board_size";
        string _fileName = "game_settings.json";
        BoardSize _boardSize = BoardSize.medium;
    }
}