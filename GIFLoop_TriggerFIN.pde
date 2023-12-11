//Code was made with the help of ChatGPT 3.5 in 2023 December. The class ImageLoop2 with different image process functions is created by Iris. Face Detection function modified from the code from the Project What Lies Under from Experiment 3.

import processing.video.*;
import gab.opencv.*;
import java.awt.*;

Capture video;
OpenCV opencv;

PFont courier;

int cameraIndex = 0; // default camera index, change this to select a different camera
float proximityThreshold = 80; // Adjust this threshold as needed

ImageLoop idleloop;
ImageLoop actloop;

PImage bg;

boolean loop=true;
boolean showCameraFeed = true;


void setup() {
  size(900, 900,P2D);
  
  frameRate(8);
  
  // List available cameras
  printArray(Capture.list());  

  //load bg image
  bg=loadImage("whitebg.png");
  
  // Setup for OpenCV and video capture
  String[] cameras = Capture.list();
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(i + ": " + cameras[i]);
    }
 
  video = new Capture(this, 350, 350, Capture.list()[cameraIndex]);
  opencv = new OpenCV(this, 350, 350);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);

  video.start();
  
  //load active state and idle GIF
  idleloop = new ImageLoop("idlefin", 90);
  actloop = new ImageLoop("actfin", 56);
}


void draw() {
  imageMode(CENTER);
   

  
  //background for fixing overlapping imgs
  image(bg, width/2, height/2, width, height);
  bg.filter(NORMAL);
  
  //ghostiamgeloop
imageMode(CENTER);
 if (loop==true) {
   actloop.pause();
   idleloop.display();
   idleloop.updatewdelay(50);
   //Using text to attract the audience 
     text("Come Closer", 300, 430);
      
  } else if (loop==false) {
    idleloop.pause();
    actloop.display();
 
    actloop.updatewdelaylast(50);
 

  }
   //set up video feed in display
  
  
  //debug function
  
  opencv.loadImage(video);
  //toggle by click
    if (showCameraFeed) {
  scale(-1,1);
  image(video, 0, 0);
  noFill();
  stroke(0, 255, 0);
  strokeWeight(3);
  }
  
  
  
  Rectangle[] faces = opencv.detect();
    
  //checking face 
  if (faces.length > 0) {
    // Assuming only one face is present, get the distance (proximity) of the face to the camera
    float proximity = dist(faces[0].x , faces[0].y, faces[0].x + faces[0].width , faces[0].y + faces[0].height );
    println("DETECTED FACE");

    // Check if the face is close enough to trigger the active state media. This check distance function is made with the help of ChatGPT3.5.
    if (proximity > proximityThreshold) {
      loop=false;

        if (showCameraFeed) {
      rect(faces[0].x-width, faces[0].y, faces[0].width, faces[0].height);
        }
      println("ACTIVE TRIGGERED");
    }
    else {
    // No face detected, switch back to the loop state
    loop = true;
    actloop.currentImage = 0;
  }

  }



//goes back to loop when wink is done
  if (actloop.currentImage<=0) { 
    loop=true;
  }
 
}

void captureEvent(Capture c) {
  c.read();
}
 
 void mousePressed() {
  // Toggle camera feed display on mouse click
  showCameraFeed = !showCameraFeed;
}
  
