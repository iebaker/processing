class Ball {
  
  PVector myPosition;
  PVector myVelocity;
  float myMass;
  PVector myForce;
  PVector myImpulse;
  
  Ball(PVector position, PVector velocity, float mass) {
    myPosition = position;
    myVelocity = velocity;
    myMass = mass;
    
    myForce = new PVector();
    myImpulse = new PVector();
  }
  
  PVector getPosition() {
    return myPosition; 
  }
  
  PVector getVelocity() {
    return myVelocity; 
  }
  
  float getMass() {
    return myMass; 
  }
  
  float getRadius() {
    return sqrt(myMass) / materialDensity;
  }
  
  void applyImpulse(PVector impulse) {
    myImpulse.add(impulse); 
  }
  
  void applyForce(PVector force) {
    myForce.add(force); 
  }
  
  void augmentPosition(PVector delta) {
    myPosition.add(delta); 
  }
  
  void update() {
    myVelocity.add(myForce.mult(1.0f / myMass)).add(myImpulse.mult(1.0f / myMass)).limit(speedOfLight);
    myPosition.add(myVelocity);
    checkForWalls();
    myForce.set(0, 0, 0);
    myImpulse.set(0, 0, 0);
  }
  
  void drawSelf() {
    fill(ballColor);
    ellipse(myPosition.x, myPosition.y, getRadius() * 2, getRadius() * 2); 
  }
  
  void checkForWalls() {
    if (myPosition.x > width || myPosition.x < 0) {
      myVelocity.x = -myVelocity.x;
    }
    if (myPosition.y > height || myPosition.y < 0) {
      myVelocity.y = -myVelocity.y; 
    }
  }
}