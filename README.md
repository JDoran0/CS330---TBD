Tarot: the chaotic card-based fighting game

members: Jericho, Dawson, Javi, Enrique

created: Oct 26 2024

update log (11 - 1 - 2024):
	quitting game is binded to the escape key inside the gameplay, otherwise press the exit button
	
	player health, 100 max, is printed when updated into the command line 
	
	dummy added
	  - has 1000 max health, also printed on the command line when updated
	  - The dummy is a character, the movement ability was just commented out
	
update log (11 - 2 - 2024)
	local multiplayer added, the game works with two controllers and keyboard controls
	keyboard player 1: arrow keys, space bar
	keyboard player 2: w,a,s,d
	controls (both players): d-pad movement, joystick movement, a to jump
	
A couple things to note about update (11 - 8 - 2024):
- to check for crouching, I made a bool called "crouching" and it returns true or false if the player is crouching.
- A "playAnimation" function was made at the bottom of each player to play the sprite animations in case more frames are made.
- player health was made, I connected I wrote the code in player however its possible to move it strictly to the health bars respectively
- the controller screen was made, im hoping the punching control is swapped to left button eventually
- yes I do know that I didn't change the platform, I completely forgot about it but Ill do it another time.
