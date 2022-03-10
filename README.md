# Snake-Game

CS50x FINAL PROJECT

The snake game made by using lua with LÖVE.
This game implements an algorithm to make the snake move by the user's key input in different directions to consume an apple that has a randomized position on the screen.
The game effectively incorporates the learnings on map creation, character movement, score update, sound effects, and various LÖVE functions and lua classes from the CS50 Games Track.

There are 4 levels to this game; the difficulty progessess as speed of the snake increases.
- Easy
- Medium
- Hard
- Challenge : the speed starts of as that of medium and progressively increases as an apple is consumed

Rules of the game:
- The snake's movement is controlled by using the appropriate arrow keys
- +1 point per each apple consumed in the span of the game
- The snake grows one unit upon each apple consumed
- The game ends if:
    •	Escape key is pressed
    •	The snake collides with the edges of the screen
    •	The snake collides with itself
    •   The game has been played for 25 hours continuously
- When the snake is moving upwards, it may not change direction dowanwards immediately after and vice versa
- When the snake is moving left, it may not change direction to the right immediately after and vice versa


Code editor - Visual Studio Code by Microsoft

Graphics:
- Snake body : Created using Microsoft Paint and Adobe Photoshop
- Apple : Created using Microsoft Paint and Adobe Photoshop
- Grass background : by txturs from https://opengameart.org/content/grass-pixel-art

Project ppt:
https://www.canva.com/design/DAEGzd9tq6o/sXHAn9wBiFKQsj5CO9_eOA/view?utm_content=DAEGzd9tq6o&utm_campaign=designshare&utm_medium=link2&utm_source=sharebutton

Sounds:
- Eating sound: from https://github.com/eugeneloza/SnakeGame
- Game end sound: from cs50 mario Game Track library
