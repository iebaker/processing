class Dot {
  public Dot(PVector p, PVector v) {
    this.position = p;
    this.velocity = v.x == 0 && v.y == 0 ? PVector.random2D() : v;
  }
  public PVector position;
  public PVector velocity;
}

ArrayList<Dot> dots = new ArrayList<Dot>();
float dotRadius = 5;
float maxFrequency = 20;
float maxAmplitude = 300;
float maxDotSpeed = 4;

void setup() {
  size(800, 600); 
  noStroke();
  makeInitialDots();
}

void makeInitialDots() {
  float count = 4;
  for(int i = 0; i < count; i++) {
    PVector position = new PVector(random(width), random(height));
    PVector velocity = PVector.random2D().mult(random(0, 1));
    dots.add(new Dot(position, velocity));
  }
}

void draw() {
  background(255);
  updateDots();
  drawWave();
}

void updateDots() {
  for(Dot dot : dots) {
    dot.position.add(dot.velocity);
    if(!within(dot.position.x, 0, width)) {
      dot.velocity.x = -dot.velocity.x; 
    }
    if(!within(dot.position.y, 0, height)) {
      dot.velocity.y = -dot.velocity.y; 
    }
  }
}

void drawDots() {
  for(Dot dot : dots) {
    fill(255, 0, 255);
    ellipse(dot.position.x, dot.position.y, dotRadius * 2, dotRadius * 2); 
  }
}

void drawWave() {
  fill(255);
  float valueAtX, amplitude, frequency, currentValueAtX;
  for(float x = 0; x < width; x++) {
    valueAtX = 0;
    for(Dot dot : dots) {
      amplitude = map(dot.position.y, 0, height, -maxAmplitude, maxAmplitude);
      frequency = map(dot.position.x, 0, width, 0, maxFrequency); 
      currentValueAtX = amplitude * sin(2 * PI * (x + 1000) * frequency / width);
      valueAtX += currentValueAtX;
    }
    valueAtX /= dots.size();
    stroke(0); line(x, height / 2 - valueAtX, x, height); noStroke();
  }
}

boolean within(float arg, float min, float max) {
  return arg > min && arg < max;
}