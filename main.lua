function love.load()
	objects = {}

	-- Ball
	objects.ball = {}
	objects.ball.speed = {}

	objects.ball.radius = 10
	objects.ball.segments = 60

	setBallInitalPositionAndSpeed()

	wallBoundary = objects.ball.radius / 2

	-- Paddle
	objects.paddle = {}
	objects.paddle.height = 60
	objects.paddle.width = 20

	-- Player 1
	objects.player1 = {}
	objects.player1.score = 0
	objects.player1.xPos = 20
	objects.player1.yPos = 250

	-- Player 2
	objects.player2 = {}
	objects.player2.score = 0
	objects.player2.xPos = 760
	objects.player2.yPos = 250

	objects.speed = {}
	objects.speed.x = 2
	objects.speed.y = 2

	-- Window
	objects.window = {}
	objects.window.height = 600
	objects.window.maxHeight = 600
	objects.window.minHeight = 0
	objects.window.width = 800
	love.window.setMode(objects.window.width, objects.window.height)
end

function love.draw()
	-- Score
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.print('Player 1: ', 250, 20, 0, 1, 1)
	love.graphics.print(objects.player1.score, 325, 20, 0, 1, 1)
	love.graphics.print('Player 2: ', 500, 20, 0, 1, 1)
	love.graphics.print(objects.player2.score, 575, 20, 0, 1, 1)


	-- 1st player
	love.graphics.setColor(0, 245, 255)
	love.graphics.rectangle('fill', objects.player1.xPos, objects.player1.yPos, objects.paddle.width, objects.paddle.height)

	-- 2nd player
	love.graphics.setColor(0, 255, 127);
	love.graphics.rectangle('fill', objects.player2.xPos, objects.player2.yPos, objects.paddle.width, objects.paddle.height)

	-- Ball
	love.graphics.setColor(220, 20, 60)
	love.graphics.circle('fill', objects.ball.xPos, objects.ball.yPos, objects.ball.radius, objects.ball.segments)
end

function love.update()
	-- Debugging
	require("lovebird").update()

	-- Determines what player scored
	playerScored()

	-- Ball movement
	moveBall();

	-- Hit ball
	hitBall()

	-- Player 1 movement
	if love.keyboard.isDown('w') then
		movePaddleUp(objects.player1)
	elseif love.keyboard.isDown('s') then
		movePaddleDown(objects.player1)
	end

	-- Player 2 movement
	if love.keyboard.isDown('up') then
		movePaddleUp(objects.player2)
	elseif love.keyboard.isDown('down') then
		movePaddleDown(objects.player2)
	end
end

-- Function to handle the logic for hitting the ball if the player 1/2 paddle.
function hitBall()
	if objects.ball.xPos - objects.ball.radius == objects.player1.xPos + objects.paddle.width and 
	    (objects.player1.yPos <= objects.ball.yPos and objects.player1.yPos + objects.paddle.height >= objects.ball.yPos) then

		objects.ball.speed.x = -objects.ball.speed.x * objects.speed.x
		objects.ball.speed.y = objects.ball.speed.y * objects.speed.y
	elseif objects.ball.xPos + objects.ball.radius == objects.player2.xPos and
		(objects.player2.yPos <= objects.ball.yPos and objects.player2.yPos + objects.paddle.height >= objects.ball.yPos) then

		objects.ball.speed.x = -objects.ball.speed.x * objects.speed.x
		objects.ball.speed.y = objects.ball.speed.y * objects.speed.y
	end

	if objects.ball.speed.x > 4 then
		objects.ball.speed.x = 4
	elseif objects.ball.speed.x < -4 then
		objects.ball.speed.x = -4			
	end

	if objects.ball.speed.y > 4 then
		objects.ball.speed.y = 4
	elseif objects.ball.speed.y < -4 then
		objects.ball.speed.y = -4			
	end
end

-- Logic to handle if the ball hits the top or bottom of the screen.
function moveBall()
	if objects.ball.yPos <= wallBoundary and objects.ball.speed.y < 0 or 
	   objects.ball.yPos >= objects.window.height - wallBoundary and objects.ball.speed.y > 0 then
		objects.ball.speed.y = -objects.ball.speed.y
	end
	objects.ball.xPos = objects.ball.xPos + objects.ball.speed.x
	objects.ball.yPos = objects.ball.yPos + objects.ball.speed.y
end

-- Function to handle moving the paddle up.
function movePaddleUp(player)
	if player.yPos > objects.window.minHeight then
		player.yPos = player.yPos - 5
	end
end

-- Function to handle moving the paddle down.
function movePaddleDown(player)
	if player.yPos < objects.window.maxHeight - objects.paddle.height then
		player.yPos = player.yPos + 5
	end
end

-- Logic to handle when a player scores.
function playerScored()
	if objects.ball.xPos <= wallBoundary and objects.ball.speed.x < 0 then
		objects.player2.score = objects.player2.score + 1
		setBallInitalPositionAndSpeed()
	elseif objects.ball.xPos >= objects.window.width - wallBoundary and objects.ball.speed.x > 0 then
		objects.player1.score = objects.player1.score + 1
		setBallInitalPositionAndSpeed()
	end
end

-- Sets the ball's position/speed on load, and every time a player scores
function setBallInitalPositionAndSpeed()
	objects.ball.xPos = 400
	objects.ball.yPos = 275
	objects.ball.speed.x = love.math.random(-1, 1)  
	objects.ball.speed.y = love.math.random(-1, 1)

	if objects.ball.speed.x == 0 or objects.ball.speed.y == 0 then
		objects.ball.speed.x = 1
		objects.ball.speed.y = 1
	end
end
