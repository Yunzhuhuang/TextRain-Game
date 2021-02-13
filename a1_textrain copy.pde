/*
 * CSci-4611 Assignment #1 Text Rain
 */


/* Note: if Processing's video library does not support your particular combination of webcam and
   operating system, then the Sketch may hang in the setup() routine when the list of available
   image capture devices is requestd with "Capture.list()".  If this happens, you can skip all of
   the camera initilization code and just run in movie mode by setting the following global 
   variable to true. 
 */
boolean forceMovieMode = false;

// Global vars used to access video frames from either a live camera or a prerecorded movie file
import processing.video.*;
String[] cameraModes;
Capture cameraDevice;
Movie inputMovie;
boolean initialized = false;


// Both modes of input (live camera and movie) will update this same variable with the lastest
// pixel data each frame.  Use this variable to access the new pixel data each frame!
PImage inputImage;
PImage finalImage;
PImage debuggerImage;

//To indicate whether I open debugger or not
Boolean debugger;

// Declare PFont variable
PFont f;

// Text message
String message  = "I love Text rains Letters are cool";

// Declare four arrays to control thset e text rain falling
int[] y = new int[message.length()];
int[] x = new int[message.length()];
int[] variation = new int[message.length()]; //To control speed of rain
color[] colors = new int[message.length()];  //To control color of rain

// Threshold for assigning pixels
int threshold  = 128;

// Take care of keyboard usage
int spacecount = 0;

// Called automatically by Processing, once when the program starts up
void setup() {
  size(1280, 720);  
  inputImage = createImage(width, height, RGB);
  finalImage = createImage(width, height, RGB);
  debuggerImage = createImage(width, height, RGB);
  f = createFont("Arial", 25, true); // Create Font
  
  textAlign(LEFT, BOTTOM); //Align text display
  
  //Initialize y value for each letter
  for(int i = 0; i < message.length(); i++) {
    y[i] = 0;
  }
   
  
  //Initialize x value of each letter/
  x[0] = (int)random(100);
  int m = 100; //track the first letter's position of each word
  for(int i = 1; i < message.   length(); i++) {
    if( message.charAt(i-1) == ' ' && message.charAt(i) != ' ') {
      if(m+210 <1100) { //avoid letter go beyond the screen
       m+=160; //160 to make sure words don't conflict each other most of the time
       x[i] = (int)random(m, m+50);
      }
      else
       x[i] = (int)random(m, m+100);
    }
   else if (message.charAt(i) == ' ')
     x[i] = 0;
   else {
     if(x[i-1] < 1250)  //avoid letter go beyond the screen
      x[i] = x[i-1] + (int)random(15, 30); //make letters in a work be bounded at some extent
     else
      x[i] = 1279;
   }
  }
  
  
  //Initialize the speed
  for(int i = 0; i < message.length(); i++) {
    variation[i] = (int)random(1,6);
  }
  
  //initializa the color
  for(int i = 0; i < message.length(); i++) {
    colors[i] = color(random(255), random(255), random(255));
  }
 
  if (!forceMovieMode) {
    println("Querying avaialble camera modes.");
    cameraModes = Capture.list();
    println("Found " + cameraModes.length + " camera modes.");
    for (int i=0; i<cameraModes.length; i++) {
      println(" " + i + ". " + cameraModes[i]); 
    }
    // if no cameras were detected, then run in offline mode
    if (cameraModes.length == 0) {
      println("Starting movie mode automatically since no cameras were detected.");
      initializeMovieMode(); 
    }
    else {
      println("Press a number key in the Processing window to select the desired camera mode.");
    }
  }
}



// Called automatically by Processing, once per frame
void draw() {
  // start each frame by clearing the screen
  background(0);
   
  if (!initialized) {
    // IF NOT INITIALIZED, DRAW THE INPUT SELECTION MENU
    drawMenuScreen();      
  }
  else {
    // IF WE REACH THIS POINT, WE'RE PAST THE MENU AND THE INPUT MODE HAS BEEN INITIALIZED


    // GET THE NEXT FRAME OF INPUT DATA FROM LIVE CAMERA OR MOVIE  
    if ((cameraDevice != null) && (cameraDevice.available())) {
      // Get image data from cameara and copy it over to the inputImage variable
      cameraDevice.read();
      inputImage.copy(cameraDevice, 0,0,cameraDevice.width,cameraDevice.height, 0,0,inputImage.width,inputImage.height);
    }
    else if ((inputMovie != null) && (inputMovie.available())) {
      // Get image data from the movie file and copy it over to the inputImage variable
      inputMovie.read();
      inputImage.copy(inputMovie, 0,0,inputMovie.width,inputMovie.height, 0,0,inputImage.width,inputImage.height);
    }


    // DRAW THE INPUTIMAGE ACROSS THE ENTIRE SCREEN
    // Note, this is like clearing the screen with an image.  It will cover up anything drawn before this point.
    // So, draw your text rain after this!
    
    //display debugger mode or normal mode
    finalImage = grayscale(flip(inputImage)); 
    if (key == ' ' && spacecount % 2 == 1) {
       debuggerImage = debugger(finalImage);
       set(0, 0, debuggerImage);
       debugger = true;
    }
    else {
       debugger = false;
       set(0, 0, finalImage);
    }
    
   
      
    // DRAW THE TEXT RAIN, ETC.
    // TODO: Much of your implementation code should go here.  At this point, the latest pixel data from the
    // live camera or movie file will have been copied over to the inputImage variable.  So, if you access
    // the pixel data from the inputImage variable, your code should always work, no matter which mode you run in.
    textFont(f);
    
    if (debugger == true) {
      debuggerRains(message);
    }
    else {
      finalRains(message);
    }
 }
}
   

  


// Called automatically by Processing once per frame
void keyPressed() {
  if (!initialized) {
    // CHECK FOR A NUMBER KEY PRESS ON THE MENU SCREEN    
    if ((key >= '0') && (key <= '9')) { 
      int input = key - '0';
      if (input == 0) {
        initializeMovieMode();
      }
      else if ((input >= 1) && (input <= 9)) {
        initializeLiveCameraMode(input);
      }
    }
  }
  else {
    // CHECK FOR KEYPRESSES DURING NORMAL OPERATION
    // TODO: Fill in your code to handle keypresses here..
    if (key == CODED) {
      if (keyCode == UP) {
        // up arrow key pressed
        threshold ++;
        
      }
      else if (keyCode == DOWN) {
        // down arrow key pressed
        threshold --;
        
      }
    }
    else if (key == ' ') {
      // spacebar pressed
     spacecount++;
       
    }   
  }
}




// Loads a movie from a file to simulate camera input.
void initializeMovieMode() {
  String movieFile = "TextRainInput.mov";
  println("Simulating camera input using movie file: " + movieFile);
  inputMovie = new Movie(this, movieFile);
  inputMovie.loop();
  initialized = true;
}


// Starts up a webcam to use for input.
void initializeLiveCameraMode(int cameraMode) {
  cameraDevice = new Capture(this, cameraModes[cameraMode-1]);
  cameraDevice.start();
  initialized = true;
}


// Draws a quick text-based menu to the screen
void drawMenuScreen() {
  int y=10;
  text("Press a number key to select an input mode", 20, y);
  y += 40;
  text("O: Offline mode, test with TextRainInput.mov movie file instead of live camera feed.", 20, y);
  y += 40; 
  for (int i = 0; i < min(9,cameraModes.length); i++) {
    text(i+1 + ": " + cameraModes[i], 20, y);
    y += 40;
  } 
}
  
color thresholdPixel(color inputPixel) {
   if (brightness(inputPixel) < threshold) {
      return color(0);
   } else {
     return color(255);
   }
}

//Function to flip the inputImage
PImage flip(PImage inputImage) {
  inputImage.loadPixels();
  if (inputImage.width % 2 == 0) {
    for (int i = 0; i < inputImage.width/2; i++) {
      for (int j = 0; j < inputImage.height; j++) {
        
        finalImage.pixels[finalImage.width * j + i] = inputImage.pixels[inputImage.width * j + inputImage.width/2-1 + inputImage.width/2 - i];
        finalImage.pixels[inputImage.width * j + inputImage.width/2-1 + inputImage.width/2 - i] = inputImage.pixels[inputImage.width * j + i];
      }
    }
  } else {
      for (int i = 0; i < inputImage.width/2-1; i++) {
        for (int j = 0; j < inputImage.height; j++) {
          inputImage.pixels[inputImage.width * j + i] = inputImage.pixels[inputImage.width * j + inputImage.width/2 + inputImage.width/2 - i];
          inputImage.pixels[inputImage.width * j + inputImage.width/2 + inputImage.width/2 - i] = inputImage.pixels[inputImage.width * j + i];
        }
       }
  }
  finalImage.updatePixels();
  return finalImage;
}

//Function to create debugger view
PImage debugger(PImage flipImage) {
  flipImage.loadPixels();
  for (int i = 0; i < flipImage.width * flipImage.height; i++) {
         if (thresholdPixel(flipImage.pixels[i]) == color(0)) 
             debuggerImage.pixels[i] = color(0);
         else
             debuggerImage.pixels[i] = color(255);
   }
   debuggerImage.updatePixels();
   return debuggerImage;
}

//Function to change the video image to its grayscale value
PImage grayscale(PImage flipImage) {
  flipImage.loadPixels();
  for (int i = 0; i < flipImage.width * flipImage.height; i++) {
       int c = flipImage.pixels[i];
       int r=(c&0x00FF0000)>>16; // red part
       int g=(c&0x0000FF00)>>8; // green part
       int b=(c&0x000000FF); // blue part
       int grey=(r+b+g)/3; 
       finalImage.pixels[i] =color(grey);
   }
   finalImage.updatePixels();
   return finalImage;
}

// Take care of rains in debugger mode
void debuggerRains(String message) {
   debuggerImage.loadPixels();
   for (int j = 0; j < message.length(); j++) {
     int textwidth = (int)textWidth(message.charAt(j));
     for (int i = 0; i < variation[j]; i++) {
       if(y[j] > debuggerImage.height -1) {
         y[j] = 0;
       } 
       for(int k = 0; k < textwidth; k++) {
         if (y[j] >= 0  && debuggerImage.pixels[y[j] * debuggerImage.width + x[j]+k] == color(0)) {
           while (y[j] >= 0 && debuggerImage.pixels[y[j] * debuggerImage.width + x[j]+k] == color(0)) {
                y[j] --;
           }
          break;
        }
       }
       y[j] ++;
     }
     fill(colors[j]);
     text(message.charAt(j), x[j], y[j]); 
  }
}
     
     
void finalRains(String message) {
   finalImage.loadPixels();
   for (int j = 0; j < message.length(); j++) {
     int textwidth = (int)textWidth(message.charAt(j));
     for (int i = 0; i < variation[j]; i++) {
       if(y[j] > finalImage.height -1) {
         y[j] = 0;
       } 
       for(int k = 0; k < textwidth; k++) {
         if (y[j] >= 0  && thresholdPixel(finalImage.pixels[y[j] * finalImage.width + x[j]+k]) == color(0)) {
           while (y[j] >= 0 && thresholdPixel(finalImage.pixels[y[j] * finalImage.width + x[j]+k]) == color(0)) {
                y[j] --;
           }
          break;
        }
       }
       y[j] ++;
     }
     fill(colors[j]);
     text(message.charAt(j), x[j], y[j]); 
  }
}    
      

       
         




   
