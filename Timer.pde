// Timer class
class Timer {
	// Timer time string
	String timeString = "00:00";

	// Timer that returns mm:ss time string using frame refresh count
	public String getTime() {
		if (game.hasPlayerWon()) return timeString;

		int totalSeconds = gameFrameCount / 30;
		int minutes = totalSeconds / 60;
		int seconds = totalSeconds % 60;

		// mm formatted minute string
		String minuteString = (minutes < 10 ? "0" : "") + String.valueOf(minutes);
		// ss formatted seconds string
		String secondsString = (seconds < 10 ? "0" : "") + String.valueOf(seconds);
		// Final mm:ss time string
		timeString = minuteString + ":" + secondsString;

		return timeString;
	}

	// Draw out the timer
	void draw() {
		textFont(pixelFont); // Loaded in setup()
		textSize(150);
		fill(232, 210, 17); // Yellow

		// Draw text
		text(getTime(), width / 2 - textWidth(timeString) / 2, height * 15 / 16);
	}
}
