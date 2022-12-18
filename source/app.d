import std.stdio;
import bindbc.sfml;
import snake;
import std.random;
import std.string;
import std.conv;
import bindbc.loader;
import game;

void main() {
	loadSFML();

	Game game = new Game();

	while (!game.window.isDone()) {
		game.update();
		game.render();
	}
}
