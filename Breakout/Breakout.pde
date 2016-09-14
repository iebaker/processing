PVector ballPosition = new PVector(300, 300);
PVector ballVelocity = new PVector(1, 3).mult(2);

float paddlePosition = 300;
float paddleWidth = 100;
float paddleHeight = 20;
float brickSpacing = 2;
float ballRadius = 5;

float bricksAcross = 15;
float bricksDown = 20;
float bricksHeight = 300;

color ballColor = color(255, 50, 255);
color paddleColor = color(200);
color brickColor = color(100);
color backgroundColor = color(0);

boolean[][] brickHasBeenHit;

void setup() {
  size(600, 600);
  noStroke();
  brickHasBeenHit = new boolean[(int)bricksAcross][(int)bricksDown];
}

void draw() {
  background(backgroundColor);
  boolean gameWon = checkForWin();
  if (!gameWon) {
    moveBall();
    checkIfBallHitBricks();
    checkIfBallHitPaddle();
    checkIfBallHitWalls();
    drawPaddle();
    drawBricks();
    drawBall();
  } else {
    text("You win!", width / 2, height / 2); 
  }
}

void drawPaddle() {
  fill(paddleColor);
  rectMode(CENTER);
  rect(paddlePosition, height - paddleHeight / 2, paddleWidth, paddleHeight);
}

void drawBricks() {
  fill(brickColor);
  rectMode(CORNER);
  float brickWidth = (width - (brickSpacing * (bricksAcross + 1))) / bricksAcross;
  float brickHeight = (bricksHeight - (brickSpacing * (bricksDown + 1))) / bricksDown;
  for (int i = 0; i < bricksAcross; i++) {
    for (int j = 0; j < bricksDown; j++) {
      float brickPositionX = brickSpacing + ((brickSpacing + brickWidth) * i);
      float brickPositionY = brickSpacing + ((brickSpacing + brickHeight) * j);
      if (!brickHasBeenHit[i][j]) {
        rect(brickPositionX, brickPositionY, brickWidth, brickHeight);
      }
    }
  }
}

void drawBall() {
  fill(ballColor); 
  ellipse(ballPosition.x, ballPosition.y, ballRadius * 2, ballRadius * 2);
}

void moveBall() {
  ballPosition.add(ballVelocity);
}

void checkIfBallHitBricks() {
  float brickWidth = (width - (brickSpacing * (bricksAcross + 1))) / bricksAcross;
  float brickHeight = (bricksHeight - (brickSpacing * (bricksDown + 1))) / bricksDown;
  
  float ballPositionInColumn = ballPosition.x % (brickWidth + brickSpacing);
  float ballPositionInRow = ballPosition.y % (brickHeight + brickSpacing);
  
  int brickIndexX = floor(ballPosition.x / (brickWidth + brickSpacing));
  int brickIndexY = floor(ballPosition.y / (brickHeight + brickSpacing));
  
  boolean hitThisBrick = ballPositionInColumn + ballRadius > brickSpacing && ballPositionInRow + ballRadius > brickSpacing;
  boolean hitLeftBrick = ballPositionInColumn - ballRadius < 0;
  boolean hitUpBrick = ballPositionInRow - ballRadius < 0;
  
  if (hitThisBrick) hitBrick(brickIndexX, brickIndexY);
  if (hitLeftBrick) hitBrick(brickIndexX - 1, brickIndexY);
  if (hitUpBrick) hitBrick(brickIndexX, brickIndexY - 1);
  if (hitLeftBrick && hitUpBrick) hitBrick(brickIndexX - 1, brickIndexY - 1);
}

void hitBrick(int x, int y) {
  if (x < bricksAcross && y < bricksDown && x > -1 && y > -1) {
    brickHasBeenHit[x][y] = true;
  }
}

void checkIfBallHitPaddle() {
  if (abs(ballPosition.x - paddlePosition) < paddleWidth / 2) {
    if (height - ballPosition.y < paddleHeight + ballRadius) {
      ballVelocity.y = -ballVelocity.y; 
    }
  }
}

void checkIfBallHitWalls() {
  if (ballPosition.x > width || ballPosition.x < 0) {
    ballVelocity.x = -ballVelocity.x;
  } else if (ballPosition.y < 0) {
    ballVelocity.y = -ballVelocity.y;
  } else if (ballPosition.y > height) {
    ballPosition.set(300, 300); 
  }
}

boolean checkForWin() {
  for (int x = 0; x < bricksAcross; x++) {
    for (int y = 0; y < bricksDown; y++) {
      if (!brickHasBeenHit[x][y]) {
        return false; 
      }
    }
  }
  return true;
}

void mouseMoved() {
  paddlePosition = mouseX;
}