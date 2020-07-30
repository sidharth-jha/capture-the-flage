import processing.sound.*;

import processing.serial.*;

import java.util.Arrays;
import java.util.List;
import java.awt.AWTException;

// USB Arduino Port
Serial arduinoPort;

// Array of all the mazes that the game is going to use
// A random maze is going to be chosen each time and used
// for that game
String[][] mazes = {
	{
		"11111111111111111111111111111111",
		"1                              0",
		"1 1111111111111 1111111111111 11",
		"1 1                         1 1",
		"1 1 11111111111111111111111 1 1",
		"1 1 1         1           1 1 1",
		"1 111 11111 11111 1111111 1 1 1",
		"1 1 1 1   1   1         1   1 1",
		"1 1 1 1 11111 1111111 111 1 1 1",
		"1 1   1 1     1       1 1 1 1 1",
		"1 1 1 1 1 1111111 111 1 1 111 1",
		"1 1 1 1   1   1     1 1 1 1 1 1",
		"1 1 1 1 111 1 11111 111 1 1 1 1",
		"1   1 1     1     1   1   1   1",
		"111 111 111 1 1 1 1 111 111 111",
		"1 1 1 1 1 1 1 121 1 1 1 1 1 1 1",
		"1 111 111 111 1 1 111 111 111 1",
		"1   1 1     1     1   1   1   1",
		"1 1 1 1 111 1 11111 111 1 1 1 1",
		"1 1 1 1   1   1     1 1 1 1 1 1",
		"1 1 1 1 1 1111111 111 1 1 111 1",
		"1 1   1 1     1       1 1 1 1 1",
		"1 1 1 1 11111 1111111 111 1 1 1",
		"1 1 1 1   1   1         1   1 1",
		"1 111 11111 11111 1111111 1 1 1",
		"1 1 1         1           1 1 1",
		"1 1 11111111111111111111111 1 1",
		"1 1                         1 1",
		"1 1111111111111 1111111111111 11",
		"1                              0",
		"11111111111111111111111111111111",
	}
};

// Create PImage object
PImage headLogo;
// Create PFont object
PFont pixelFont;
// Sound Objects
SoundFile coinDrop, runner;

// Processing setup
void setup() {
	// Get port name
	String portName = Serial.list()[0];
	// Setting arduino port
	arduinoPort = new Serial(this, portName, 9600);
	arduinoPort.bufferUntil('\n');

	// Canvas size and drawing framerate
	fullScreen();
	frameRate(30);

	// Load the image
	headLogo = loadImage("assets/logo.png");
	// Load the font
	pixelFont = createFont("assets/pixel-font.ttf", 32);
	// Load the sounds
	coinDrop = new SoundFile(this, "assets/coinDrop.wav");
	runner = new SoundFile(this, "assets/runner.wav");
}

void handleInput(String inputString) {
	// Start screen
	if (currentScreen == 0) {
		// If button pressed on start screen, move to next screen
		if (inputString.equals("Enter")) {
			coinDrop.play();
			currentScreen = 1;
		}
		return;
	}

	// Mode selection screen
	if (currentScreen == 1) {
		switch(inputString) {
			case "Up0":
			case "Up1":
				gameMode = 0;
				break;

			case "Down0":
			case "Down1":
				gameMode = 1;
				break;

			case "Enter":
				if (gameMode == 0) {
					currentScreen = 2;
				} else {
					game = new Game(gameMode);
					currentScreen = 3;
				}
				break;
		}
		return;
	}

	// Rules for single player
	if (currentScreen == 2) {
		// If button pressed on start screen, move to next screen
		if (inputString.equals("Enter")) {
			game = new Game(0);
			currentScreen = 3;
		}
		return;
	}

	// Game play screen
	if (
		currentScreen == 3 &&
		!(game != null && game.hasPlayerWon()) // no player has won
	) {
		switch(inputString) {
			case "Up0":
				game.players.get(0).attemptMove(new PVector(0, -1));
				break;

			case "Down0":
				game.players.get(0).attemptMove(new PVector(0, 1));
				break;

			case "Right0":
				game.players.get(0).attemptMove(new PVector(1, 0));
				break;

			case "Left0":
				game.players.get(0).attemptMove(new PVector(-1, 0));
				break;

			case "Up1":
				if (gameMode == 1)
					game.players.get(1).attemptMove(new PVector(0, -1));
				break;

			case "Down1":
				if (gameMode == 1)
					game.players.get(1).attemptMove(new PVector(0, 1));
				break;

			case "Right1":
				if (gameMode == 1)
					game.players.get(1).attemptMove(new PVector(1, 0));
				break;

			case "Left1":
				if (gameMode == 1)
					game.players.get(1).attemptMove(new PVector(-1, 0));
				break;

			case "g1_1":
				if (gameMode == 1)
					game.players.get(1).stepSize = 30;
				break;

			case "g2_1":
				if (gameMode == 1)
					game.players.get(1).stepSize = 20;
				break;

			case "g3_1":
				if (gameMode == 1)
					game.players.get(1).stepSize = 10;
				break;

			case "g1_2":
				game.players.get(0).stepSize = 30;
				break;

			case "g2_2":
				game.players.get(0).stepSize = 20;
				break;

			case "g3_2":
				game.players.get(0).stepSize = 10;
				break;
		}

		return;
	}
}

void serialEvent(Serial port) {
	try {
		// Get output from port and take substring upto colon
		String keyString = port.readStringUntil('\n');
		String inputString = keyString.substring(0, keyString.indexOf(':'));
		handleInput(inputString);
	} catch(RuntimeException e) {
		e.printStackTrace();
	}
}

// Frame refresh counter
int frameRefreshCount = 0;
int gameFrameCount = 0;

// Index of currently active screen:
//   0: start screen
//   1: mode selection screen
//   2: game play screen
int currentScreen = 0;

// 0 => single; 1 => multi
int gameMode = 0;

// Maintains number of players that are in the game
int playerCount = 0;

// Which level?
int level = 1;

// Flag that checks if a win has happened
boolean playerWon = false;

// Initialse Screen object
Screen screen = new Screen();

// Initialise Game object
Game game;

void draw() {
	clear(); // Clear the board to redraw everything and update states
	background(11, 76, 244); // Shade of blue

	// Draw the currently active screen
	screen.draw();

	frameRefreshCount++;
	if (game != null) {
		gameFrameCount++;
	}
}

// Same functions with keypress for debugging
void keyPressed() {
	switch(keyCode) {
		case UP:
			handleInput("Up0");
			break;
		case 87:
			handleInput("Up1");
			break;
		case DOWN:
			handleInput("Down0");
			break;
		case 83:
			handleInput("Down1");
			break;
		case RIGHT:
			handleInput("Right0");
			break;
		case 68:
			handleInput("Right1");
			break;
		case LEFT:
			handleInput("Left0");
			break;
		case 65:
			handleInput("Left1");
			break;
		case ENTER:
		case RETURN:
			handleInput("Enter");
			break;
	}
}
