//We end up using only the updatewdelay, updatewdelaylast and pause function in this Class
class ImageLoop {

  // Set up class parameters
  PImage[] frames;
  int currentImage = 0;

  int timeDelay;
  int nextTime;

  int direction=1;

  boolean pause= false;
  int count = 0;

// set up variables for ImageLoop
  ImageLoop(String fileName, int numFiles) {
    frames = new PImage[numFiles];
    for (int i = 0; i < frames.length; i++) {
      frames[i] = loadImage(fileName + nf(i, 3) + ".png");
    }
  }

  void update() {
    currentImage++;
    if (currentImage >= frames.length) {
      currentImage = 0;
    }
  }

//this function is used to play the array of images with a delay inbetween each image
  void updatewdelay(int timeDelay) {
    if (millis() > nextTime) {
      currentImage++;
      if (currentImage >= frames.length) {
        currentImage = 0;
      }
      nextTime = millis() + timeDelay;
    }
  }
  //this function will play the array of images, and repeat the last 10 frames 5 times. This function is made with the help of ChatGPT3.5.
   void updatewdelaylast(int timeDelay) {
    if (count < 5) {
      if (millis() > nextTime) {
        currentImage++;
        if (currentImage ==frames.length) {
          currentImage = frames.length - 10;
         
          count++;
        }
        nextTime = millis() + timeDelay;
      }
    } else if(count ==5) {
      currentImage = 0;
      count = 0;
    }

  }

  void display() {
    image(frames[currentImage], width/2, height/2, width, height);
  }

  void intdisplay(float x, float y, float x2, float y2) {
    image(frames[currentImage], x, y, x2, y2);
  }

  void textdisplay() {
    image(frames[currentImage], width/2, 500, width, 2500);
  }


//this function is used to pause each image in the array of images
  void pause() {
    if (pause==false) {
      currentImage++;
      if (currentImage>=frames.length) {
        currentImage=0;
      }
    }
  }
  
  void pausekey(float x, float y, float x2, float y2){
    if ((overRect2(x,y,x2,y2))==true&&(mousePressed==true)){
      pause=!pause;
    }
  }

  void mouseover() {
    int currentImage=int(map(mouseX, 0, width, 0, frames.length-1));
    image(frames[currentImage], width/2, height/2);
  }
} 

boolean overRect2(float rx, float ry, float rwidth, float rheight) { //if mouse is over rectangle
  if (mouseX>rx && mouseX<rx+rwidth && mouseY>ry && mouseY<ry+rheight) {
    return true;
  } else {
    return false;
  }
}
