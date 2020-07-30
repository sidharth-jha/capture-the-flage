// Screen class
class Screen {
	// "Press to Start" screen
	void startScreen() {
		image(headLogo, width / 2 - 200, height / 4 - 200, 400, 400);

		textFont(pixelFont); // Loaded in setup()
		textSize(90);

		// To give the blinking effect, change color mode every half-second
		if (frameRefreshCount % 30 < 15) {
			fill(232, 210, 17); // Yellow
		} else {
			fill(21, 30, 113); // Dark blue
		}

		String displayText = "Press to Start >>";
		float displayTextWidth = textWidth(displayText); // Drawn text width

		// Draw text
		text(displayText, width / 2 - displayTextWidth / 2 + 10, height * 2 / 3);
	}

	// "Select mode" screen
	void selectModeScreen() {
		image(headLogo, width / 2 - 200, height / 4 - 200, 400, 400);

		// They should be equal length strings for equal widths
		String[] modes = {"Single", "Multi "};
		textFont(pixelFont); // Loaded in setup()
		textSize(90);

		for (int i = 0; i < modes.length; i++) {
			String displayText = modes[i];

			if (gameMode == i) {
				displayText = ">> " + displayText;
				fill(232, 210, 17);
			} else {
				displayText = "   " + displayText;
				fill(255, 255, 255);
			}

			float displayTextWidth = textWidth(displayText); // Drawn text width
			// Draw text
			text(displayText, width / 2 - displayTextWidth / 2, height * 2 / 3 + i * 100);
		}
	}

	// "Rules" screen
	void rulesScreen() {
		// Draw out image
		image(headLogo, width / 2 - 75, 30, 150, 150);
		textFont(pixelFont); // Loaded in setup()
		fill(232, 210, 17); // Yellow

		String[] texts = {
			"Rule:",
			"Complete Level 1 within",
			"40 seconds to reach Level 2"
		};

		textSize(120);
		text(texts[0], width / 2 - textWidth(texts[0]) / 2, height / 2);
		textSize(80);
		text(texts[1], width / 2 - textWidth(texts[1]) / 2, height * 2 / 3);
		textSize(80);
		text(texts[2], width / 2 - textWidth(texts[2]) / 2, height * 3 / 4);
	}

	// Draw the respective screens corresponding to the current index
	void draw() {
		switch(currentScreen) {
			// Start screen
			case 0:
				startScreen();
				break;

			// Mode selection screen
			case 1:
				selectModeScreen();
				break;

			// Mode selection screen
			case 2:
				rulesScreen();
				break;

			// Game play screen
			case 3:
				game.draw();
				break;
		}
	}
}
