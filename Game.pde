// Game class
public class Game {
	// Initiating the game's maze with a random maze selected from
	// the array of mazes declared in the start
	private String[] selectedMaze = mazes[(int)(Math.random() * mazes.length)];
	private Maze mazeBoard = new Maze(selectedMaze);

	// Initiating the players
	public List<Player> players = new ArrayList<Player>();

	// Timer
	public Timer timer = new Timer();

	// Draw all game graphics
	public void draw() {
		// Draw out image
		image(headLogo, width / 2 - 75, 30, 150, 150);

		// Draw the maze
		mazeBoard.draw();
		// Rotate the inner wall
		mazeBoard.rotateInnerWall();

		// Draw each player (multiple in case of multiplayer)
		for (Player player : players) {
			player.draw();
		}

		// Draw the timer
		timer.draw();

		if (hasPlayerWon()) {
			fill(0, 0, 0, 180);
			noStroke();
			rect(0, 0, width, height);

			textFont(pixelFont); // Loaded in setup()
			textSize(150);

			String winText = "Player ";
			for (int i = 0; i < players.size(); i++) {
				if (players.get(i).playerWon) {
					winText += (i + 1);
					break;
				} 
			}
			winText += " won!";

			String timerText = "Finish time: " + timer.getTime();

			// Draw text
			// To give the blinking effect, change color mode every half-second
			if (frameRefreshCount % 30 < 15) {
				fill(232, 210, 17); // Yellow
			} else {
				fill(255, 0, 0); // White
			}
			text(winText, width / 2 - textWidth(winText) / 2, height * 1 / 3);

			fill(232, 210, 17); // Yellow
			text(timerText, width / 2 - textWidth(timerText) / 2, height * 2 / 3);
		}
	}

	// Returns boolean if player one
	public boolean hasPlayerWon() {
		for (Player player : players) {
			if (player.playerWon) return true;
		}

		return false;
	}

	Game(int mode) {
		// Array of player colors in RGB int arrays
		int[][] colors = {
			{232, 210, 17},
			{255, 0, 0}
		};

		// Add the first player (for both single and multiplayer)
		players.add(new Player(selectedMaze, colors[0]));

		if (mode == 1) {
			// Add the second player (only for multi)
			players.add(new Player(selectedMaze, colors[1]));
		}
	}
}
