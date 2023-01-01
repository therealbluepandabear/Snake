module gamestatistics;

struct GameStatistics {
    int delegate() _score;
    int delegate() _highScore;
}
