void setup() {
  size(600, 600); 
  noStroke();
  background(0);
}

void draw() {
  for(int i = 0; i < 20; i++) {
    fill(random(255), random(255), random(255), 8);
    triangle(
      random(-200, width + 200), random(-200, height + 200), 
      random(-200, width + 200), random(-200, height + 200),
      random(-200, width + 200), random(-200, height + 200));
  }
}