float angle = 0;

void setup() {
  size(600, 600);
  background(255);
}

void draw() {
  PVector offset = new PVector(mouseX, mouseY).add(PVector.fromAngle(angle).mult(100));
  line(mouseX, mouseY, offset.x, offset.y);
}

void mouseReleased() {
  background(255); 
}

void mouseMoved() {
  angle += 0.1; 
}