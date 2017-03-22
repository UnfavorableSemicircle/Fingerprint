import processing.video.*;

final boolean EXACT = false;
final float SPEED = 1.0;

final int PIXELS = 50;

Movie movie = null;
int frame = -1;
boolean newFrame = true;
int[][] pixelCounts;
int maxPixelCount = 0;

void setup() {
  size(640, 640);
  strokeWeight(10);
  smooth(0);
  background(0);
  
  selectInput("Choose a video file...", "fileChosen");
}

void fileChosen(File f) {
  if(f == null) {
    exit();
    return;
  }
  movie = new Movie(this, f.toString());
  
  movie.speed(SPEED);
  movie.play();
  if(EXACT) {
    movie.jump(0);
    movie.pause();
  }
  pixelCounts = new int[PIXELS][PIXELS];
}

void movieEvent(Movie m) {
  m.read();
  newFrame = true;
}

void draw() {
  if(movie == null)
    return;
  if(newFrame) {
    background(0);
    movie.loadPixels();
    float totalR = 0;
    float totalG = 0;
    float totalB = 0;
    for(color pixel : movie.pixels) {
      totalR += red(pixel);
      totalG += green(pixel);
      totalB += blue(pixel);
    }
    int numPixels = movie.width * movie.height;
    color averageColor =
      color(totalR / numPixels, totalG / numPixels, totalB / numPixels);
    
    int i = 0;
    for(color pixel : movie.pixels) {
      float diff = abs(red(pixel) - red(averageColor))
           + abs(green(pixel) - green(averageColor))
           + abs(blue(pixel) - blue(averageColor));
      if(diff > 96) {
        int x = i % movie.width;
        int y = i / movie.width;
        pixelCounts[x][y] += 1;
        if(pixelCounts[x][y] > maxPixelCount)
          maxPixelCount = pixelCounts[x][y];
      }
      i++;
    }
    
    if(maxPixelCount != 0) {
      for(int y = 0; y < movie.height; y++) {
        for(int x = 0; x < movie.width; x++) {
          float pixelCount = (float)(pixelCounts[x][y]) / (float)maxPixelCount;
          float pixelColor = pixelCount * 255.0;
          stroke(pixelColor, pixelColor, pixelColor);
          point((x+.5) / (float)movie.width * (float)width,
                (y+.5) / (float)movie.height * (float)height);
        }
      }
    }
    
    if(EXACT) {
      newFrame = false;
      nextFrame();
    } else {
      newFrame = true;
    }
  }
}

void nextFrame() {
  frame += 1;
  //movie.play();
  //movie.jump((float)frame / (float)movie.frameRate);
  //movie.pause();
  
  movie.play();
  float frameDuration = 1.0 / movie.frameRate;
  float where = (frame + 0.5) * frameDuration;
  float diff = movie.duration() - where;
  if (diff < 0) {
    where += diff - 0.25 * frameDuration;
  }
  movie.jump(where);
  movie.pause();  
  
  println(movie.time() * movie.frameRate);
}