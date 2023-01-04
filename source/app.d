import std.stdio;
import bindbc.sfml;
import snake;
import std.random;
import std.string;
import std.conv;
import bindbc.loader;
import game;

struct List(T) {
	typeof(this)* arr;
}

void main() {
	loadSFML();

	List!int l = List!int();

	Game game = new Game();

	while (!game.window.isDone()) {
		game.handleInput();
		game.update();
		game.render();
		game.restartClock();
	}
}
