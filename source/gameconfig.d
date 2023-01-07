module gameconfig;

import std.typecons;
import std.stdio;
import std.json;
import std.file;
import std.string;
import std.conv;
import std.traits;

enum BoardSize : Tuple!(int, int) {
    small = tuple(5, 5),
    medium = tuple(20, 20),
    large = tuple(35, 35),
    very_large = tuple(50, 50)
}

string fileContent(string filePath) {
    return to!string(read(filePath));
}

class JSONConfigHelper {
    this(string configPath) {
        string fileContent = fileContent(configPath);
        if (fileContent.length > 0) {
            _json = parseJSON(fileContent);
        }
        _configPath = configPath;
    }

    void write(string key, JSONValue jsonValue) {
        _configFile = File(_configPath, "w+");
        _json[key] = jsonValue;
        _configFile.write(_json.toPrettyString());
        _configFile.flush();
    }

    JSONValue get(string key) {
        return _json[key];
    }

private:
    File _configFile;
    string _configPath;
    JSONValue _json;
}

class GameConfig {
    shared static this() {
        string configPath = "game_config.json";
        _jsonConfigHelper = new JSONConfigHelper(configPath);

        if (fileContent(configPath).length == 0) {
            foreach (BoardSize boardSize; EnumMembers!BoardSize) {
                _highscores[boardSize] = 0;
            }
            _jsonConfigHelper.write(JSONKeys.board_size, JSONValue(to!string(_boardSize)));
            _jsonConfigHelper.write(JSONKeys.high_scores, highscoresJSON());
        } else {
            _boardSize = to!BoardSize(_jsonConfigHelper.get(JSONKeys.board_size).str);
            JSONValue _highscoresJSON = _jsonConfigHelper.get(JSONKeys.high_scores);
            foreach (BoardSize boardSize; EnumMembers!BoardSize) {
                _highscores[boardSize] = cast(int)((_highscoresJSON[(to!string(boardSize))]).integer);
            }
        }
    }

    @property static {
        BoardSize boardSize() {
            return _boardSize;
        }

        int[BoardSize] highscores() {
            return _highscores;
        }

        void boardSize(BoardSize boardSize) {
            _boardSize = boardSize;
            _jsonConfigHelper.write(JSONKeys.board_size, JSONValue(to!string(_boardSize)));
        }

        void setHighscore(BoardSize boardSize, int score) {
            assert(_highscores.keys.length == (cast(BoardSize[])[EnumMembers!BoardSize]).length);
            _highscores[boardSize] = score;
            _jsonConfigHelper.write(JSONKeys.high_scores, highscoresJSON());
        }
    }

    private static {
        JSONValue highscoresJSON() {
            JSONValue json;

            foreach (BoardSize boardSize; EnumMembers!BoardSize) {
                json[to!string(boardSize)] = highscores[boardSize];
            }

            return json;
        }

        enum JSONKeys : string {
            board_size = "board_size",
            high_scores = "high_scores"
        }

        BoardSize _boardSize = BoardSize.medium;
        int[BoardSize] _highscores;
        JSONConfigHelper _jsonConfigHelper;
    }
}