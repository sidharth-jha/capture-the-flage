// Maze class
public class Maze {
	// The main "maze array" containing the string
	// of rows with '1's for walls
	private String[] rows;

	// Draw the maze with respect to the row strings
	public void draw() {
		int SMALL_LENGTH = 10; // Wall pixel length
		int LARGE_LENGTH = 30; // Space pixel length

		PVector currentDrawingPosition = new PVector(width / 2 - 320, 210); // Current drawing x/y coordinates
		PVector currentUnitDimensions = new PVector(0, 0); // Current unit dimensions

		for (int i = 0; i < rows.length; i++) {
			// Current drawing x coordinate
			currentDrawingPosition.x = width / 2 - 320;
			// Current row's rects' height
			currentUnitDimensions.y = i % 2 == 1 ? LARGE_LENGTH : SMALL_LENGTH;

			for (int j = 0; j < rows[i].length(); j++) {
				// Current row's rects' height
				currentUnitDimensions.x = j % 2 == 1 ? LARGE_LENGTH : SMALL_LENGTH;

				// Draw the wall if the unit is "1" and
				// push WallUnit unit to wallUnits list
				if (rows[i].charAt(j) == '1') {
					if (level == 1) {
						fill(21, 30, 113); // Dark blue
					} else {
						// To give the blinking effect, change color mode every half-second
						if (frameRefreshCount % 30 < 15) {
							fill(21, 30, 113); // Dark blue
						} else {
							fill(11, 76, 244); // White
						}
					}

					noStroke();
					rect(
						currentDrawingPosition.x,
						currentDrawingPosition.y,
						currentUnitDimensions.x,
						currentUnitDimensions.y
					);
				}

				// Draw the flag
				if (rows[i].charAt(j) == '2') {
					fill(65, 182, 251);
					noStroke();
					triangle(
						currentDrawingPosition.x + currentUnitDimensions.x / 8,
						currentDrawingPosition.y + currentUnitDimensions.y / 8,
						currentDrawingPosition.x + currentUnitDimensions.x / 8,
						currentDrawingPosition.y + currentUnitDimensions.y * 7 / 8,
						currentDrawingPosition.x + currentUnitDimensions.x * 7 / 8,
						currentDrawingPosition.y + currentUnitDimensions.y / 2
					);
				}

				// Shift the drawing x coordinate right
				currentDrawingPosition.x += currentUnitDimensions.x;
			}

			// Shift the drawing y coordinate bottom
			currentDrawingPosition.y += currentUnitDimensions.y;
		}
	}

	// Rotate inner most walls
	public void rotateInnerWall() {
		// Rotate every 1.5 seconds (45 / 30 = 1.5)
		if (frameRefreshCount % 45 != 0) {
			return;
		}

		// Array of string arrays containing the inner wall states
		String[][] INNER_WALL_STATES = {
			{ "111", "121", "1 1" },
			{ "111", " 21", "111" },
			{ "1 1", "121", "111" },
			{ "111", "12 ", "111" }
		};

		int BASE_INDEX = ((rows.length - 1) / 2) - 1; // Index to start editing
		String[] currentState = INNER_WALL_STATES[frameRefreshCount % 4]; // State selection

		// Looping over each string of the selected state and editing it
		for (int i = 0; i < currentState.length; i++) {
			String innerStr = currentState[i];
			String rowStr = rows[BASE_INDEX + i]; // main maze array's corresponding row string
			// Editing the string with updated inner string
			rows[BASE_INDEX + i] =
				rowStr.substring(0, BASE_INDEX) +
				innerStr +
				rowStr.substring(BASE_INDEX + innerStr.length());
		}
	}

	// Constructor
	Maze(String[] rows) {
		this.rows = rows;
	}
}
