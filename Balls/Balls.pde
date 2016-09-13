float speedOfLight = 1.8;
float constantOfGravitation = 4.5;
float materialDensity = 0.5;
float collisionElasticity = 0.05;
color ballColor;

ArrayList<Ball> balls = new ArrayList<Ball>();

void setup() {
  size(600, 600);
  mouseReleased();
}

void draw() {
  background(255);
  
  for (int i = 0; i < balls.size(); i++) {
    Ball thisBall = balls.get(i);
    
    for (int j = i; j < balls.size(); j++) {
      Ball otherBall = balls.get(j);
      
      // Handle gravitation
      PVector towardsThisBall = PVector.sub(thisBall.getPosition(), otherBall.getPosition());
      float distanceSquared = towardsThisBall.magSq();
      float m1m2 = thisBall.getMass() * otherBall.getMass();
      if (distanceSquared > 0) {
        float magnitudeOfAcceleration = constantOfGravitation * m1m2 / towardsThisBall.magSq();
        otherBall.applyForce(towardsThisBall.setMag(magnitudeOfAcceleration));
        thisBall.applyForce(towardsThisBall.mult(-1));
      }
      
      // Handle collisions
      float sumOfRadii = thisBall.getRadius() + otherBall.getRadius();
      float distance = sqrt(distanceSquared);
      float gap = distance - sumOfRadii;
      if (gap < 0) {
        towardsThisBall = PVector.sub(thisBall.getPosition(), otherBall.getPosition()).normalize();
        PVector thisTranslationVector = towardsThisBall.setMag(abs(gap));
        PVector otherTranslationVector = thisTranslationVector.copy().mult(-1);
        
        PVector v1 = project(thisBall.getVelocity(), otherTranslationVector);
        PVector v2 = project(otherBall.getVelocity(), thisTranslationVector);
        
        thisBall.augmentPosition(thisTranslationVector.mult(0.5));
        otherBall.augmentPosition(otherTranslationVector.mult(0.5));
        
        float multiplier = (m1m2 * (1 + collisionElasticity)) / (thisBall.getMass() + otherBall.getMass());
        
        thisBall.applyImpulse(PVector.sub(v2, v1).mult(multiplier));
        otherBall.applyImpulse(PVector.sub(v1, v2).mult(multiplier));
      }
    }
    
    thisBall.update();
    thisBall.drawSelf();
    drawHud();
  }
}

void spawnBalls(int howMany) {
  balls.clear();
  for (int i = 0; i < howMany; i++) {
    PVector randomStartingPosition = new PVector(random(width), random(height));
    Ball ball = new Ball(randomStartingPosition, PVector.random2D(), random(1, 40));
    balls.add(ball);
  } 
}

void drawHud() {
  noStroke();
  fill(0);
  text("G = " + constantOfGravitation + " (gravitational constant) [G]", 10, 20);
  text("ρ = " + materialDensity + " (material density) [D]", 10, 40);
  text("c = " + speedOfLight + " (speed of light) [C]", 10, 60);
  text("e = " + collisionElasticity + " (elastic coefficient) [E]", 10, 80);
}

PVector project(PVector vector, PVector onto) {
  return onto.copy().mult(PVector.dot(vector, onto) / vector.magSq()); 
}

void mouseReleased() {
  ballColor = color(random(255), random(255), random(255));
  int ballsToSpawn = (int) random(10, 200);
  spawnBalls(ballsToSpawn);
}

void keyPressed() {
  if (key == 'G') constantOfGravitation += 0.1;
  if (key == 'g') constantOfGravitation -= 0.1;
  if (key == 'D') materialDensity += 0.1;
  if (key == 'd') materialDensity -= 0.1;
  if (key == 'C') speedOfLight += 0.1;
  if (key == 'c') speedOfLight -= 0.1;
  if (key == 'E') collisionElasticity += 0.1;
  if (key == 'e') collisionElasticity -= 0.1;
}