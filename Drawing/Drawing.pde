final int DRAW_LINES = 0;
final int DRAW_DOTS = 1;
final int DRAW_CRAZY = 2;

color brushColor = color(0);
int drawMode = DRAW_LINES;
float angle = 0;

void setup() {
  size(600, 600);
  background(255);
}

void draw() {
  switch (drawMode) {
    case DRAW_LINES:
      stroke(brushColor);
      line(pmouseX, pmouseY, mouseX, mouseY);
      break;
    case DRAW_DOTS:
      noStroke();
      fill(brushColor);
      ellipse(mouseX, mouseY, 10, 10);
      break;
    case DRAW_CRAZY:
      stroke(brushColor);
      PVector offset = new PVector(mouseX, mouseY).add(PVector.fromAngle(angle).mult(100));
      line(mouseX, mouseY, offset.x, offset.y);
  }
}

void mouseReleased() {
  background(255); 
}

void mouseMoved() {
  angle += 0.1; 
}

void keyReleased() {
  drawMode++;
  if (drawMode == 3) {
    drawMode = 0; 
  }
}