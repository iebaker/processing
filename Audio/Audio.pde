import ddf.minim.analysis.FFT;
import ddf.minim.Minim;
import ddf.minim.AudioInput;
import processing.video.Capture;

Minim minim;
AudioInput audioInput;
FFT fft;

float gain = 0.0f;
float scale = 50.0f;
float sampleRate = 44100;
int bufferSize = 2048;

int minBin = 0;
int maxBin = bufferSize / 20;
int binCount = maxBin - minBin;

PImage image;

void setup() {
  size(600, 600);
  minim = new Minim(this);
  //image = loadImage("/Users/ibaker/Desktop/veggies.png");
  //image = loadImage("/Users/ibaker/Pictures/nyc - 6.jpg");
  //image = loadImage("/Users/ibaker/Pictures/ldn2/4.jpg");
  image = loadImage("/Users/ibaker/Downloads/lisafrank.jpg");
  //image = loadImage("/Users/ibaker/Downloads/pollack.jpg");
  //image = loadImage("/Users/ibaker/Downloads/octopus.jpg");
  //image = loadImage("/Users/ibaker/Downloads/vangogh.jpg");
  //image = loadImage("/Users/ibaker/Downloads/spectrum.jpg");
  image.resize(600, 600);
  
  audioInput = minim.getLineIn(Minim.MONO, bufferSize, sampleRate);
  fft = new FFT(audioInput.bufferSize(), audioInput.sampleRate());
  fft.window(FFT.HAMMING);
  
  colorMode(HSB, binCount, 100, 100);
  noStroke();
}

void draw() {
  loadPixels();
  image.loadPixels();
  
  background(0);
  fft.forward(audioInput.mix);
  
  for(int y = 0; y < image.height; y++) {
    for(int x = 0; x < image.width; x++) {
      int loc = x + y * image.width;
      color pixelColor = image.pixels[loc];
      //pixels[loc] = recolorBrightnessByFrequency(pixelColor);
      pixels[loc] = recolorSaturationByFrequency(pixelColor);
    }
  }
  updatePixels();
}

color recolorBrightnessByFrequency(color originalColor) {
  float hueAngle = hue(originalColor);
  float brightness = brightness(originalColor);
  float fftValue = fft.getBand((int)(hueAngle));
  float newBrightness = (brightness * (fftValue + 1)); 
  return color(hueAngle, saturation(originalColor), newBrightness);
}

color recolorSaturationByFrequency(color originalColor) {
  float hueAngle = hue(originalColor);
  float saturation = saturation(originalColor);
  float fftValue = fft.getBand((int)(hueAngle));
  float newSaturation = max(10, (saturation * (fftValue)) + gain);
  return color(hueAngle, newSaturation, brightness(originalColor));
}

void keyPressed() {
  switch(key) {
    case 'w': gain++; break;
    case 'q': gain--; break;
    case 's': scale++; break;
    case 'a': scale--; break;
  }
}

void stop() {
  audioInput.close();
  minim.stop();
  super.stop();
}