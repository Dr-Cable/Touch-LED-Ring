OPC opc;
PImage dot;
PImage dot_color;
PImage dot_sharp;
PImage dot_soft;

import com.leapmotion.leap.Finger;
import com.leapmotion.leap.KeyTapGesture;
import com.leapmotion.leap.ScreenTapGesture;
import com.leapmotion.leap.SwipeGesture;
import com.onformative.leap.LeapMotionP5;

LeapMotionP5 leap;
String value;



void setup()
{
  size(1200, 300);
  textSize(18);

  // Load a sample images
  dot = loadImage("dot.png");
  dot_color = loadImage("dot_color.png");
  dot_sharp = loadImage("dot_sharp.png");
  dot_soft = loadImage("dot_soft.png");

  // Connect to the local instance of fcserver
  opc = new OPC(this, "127.0.0.1", 7890);

  // Map one 64-LED strip to the center of the window
  opc.ledStrip(0, 113, width/2, height/2, width / 120.0, 0, false);
  //opc.ledStrip(65, 115, width/2, height/4, width / 70.0, 0, false);
}



void draw()
{
  background(0);

  // Draw the image, centered at the mouse location
  //float dotSize = height * 0.1;
  //image(dot, mouseX - dotSize/2, mouseY - dotSize/2, dotSize, dotSize);
  
  
  // Change color
  tint(0, 127, 127); //türkis
  //tint(255,0,0);
  //tint(127,127,127);
  
  // Move dot on x Axes
  float speed1 = 0.0025;
  float speed2 = 0.0025;
  float w1 = 0.45;
  float w2 = 0.45;
  Lauflicht1(speed1, w1);
  //Lauflicht2(speed2, w2);
  
   
}



public void Lauflicht1(float speed, float w) {
  float dotSize = 550;
  float x = (width/2-dotSize/2)+((450)*sin(millis()*speed));
  
  // Draw floating dot
  image(dot_color, x, (height/2 - dotSize/2), dotSize, dotSize);
  
  value = Float.toString(x); 
  text(value, 30, 30);
}



public void Lauflicht2(float speed, float w) {
  float dotSize = 400;
  float x1 = (width-75-dotSize)+250*sin(millis()*speed);
  float x2 = (0+75)-250*sin(millis()*speed);
  
  
  // Draw floating dot
  image(dot_soft, x1, (height/2 - dotSize/2), dotSize, dotSize);
  image(dot_soft, x2, (height/2 - dotSize/2), dotSize, dotSize);
  
  value = Float.toString(x1); 
  text(value, 30, 30);


}



/*public void keyPressed() {
//Auffindleuchte
  if (key == '1') {
    if (lastGesture != "Auffindleuchte disabled. " && lastGesture != "1 Auffindleuchte\n2 Ladezeitraum\n3 SOC einstellen\n4 Wartezeit\n5 Laden") {
      Auffindleuchte = false;
      lastGesture = "Auffindleuchte disabled. ";
    } 
    else {
      Auffindleuchte = true;
      lastGesture = "Auffindleuchte enabled. ";
    }
  }

//Ladezeit einstellen Uhr
  if (key == '2') {
    if (lastGesture != "Ladezeitanzeige disabled. " && lastGesture != "1 Auffindleuchte\n2 Ladezeitraum\n3 SOC einstellen\n4 Wartezeit\n5 Laden") {
      Ladezeitanzeige = false;
      lastGesture = "Ladezeitanzeige disabled. ";
    } 
    else {
      Ladezeitanzeige = true;
      lastGesture = "Ladezeitanzeige enabled. ";
    }
  }

//SOC einstellen + Range Mode
  if (key == '3') {
    if (lastGesture != "SOCanzeige disabled. " && lastGesture != "1 Auffindleuchte\n2 Ladezeitraum\n3 SOC einstellen\n4 Wartezeit\n5 Laden") {
      SOCanzeige = false;
      lastGesture = "SOCanzeige disabled. ";
    } 
    else {
      SOCanzeige = true;
      lastGesture = "SOCanzeige enabled. ";
    }
  }

//Wartezeit
  if (key == '4') {
    if (lastGesture != "Wartezeit disabled. " && lastGesture != "1 Auffindleuchte\n2 Ladezeitraum\n3 SOC einstellen\n4 Wartezeit\n5 Laden") {
      Wartezeit = false;
      lastGesture = "Wartezeit disabled. ";
    } 
    else {
      Wartezeit = true;
      lastGesture = "Wartezeit enabled. ";
    }
  }

//Laden  
  if (key == '5') {
    if (lastGesture != "Laden disabled. " && lastGesture != "1 Auffindleuchte\n2 Ladezeitraum\n3 SOC einstellen\n4 Wartezeit\n5 Laden") {
      Laden = false;
      lastGesture = "Laden disabled. ";
    } 
    else {
      Laden = true;
      lastGesture = "Laden enabled. ";
    }
  }

//tbd  
  if (key == '6') {
    if (leap.isEnabled(Type.TYPE_SCREEN_TAP)) {
      leap.disableGesture(Type.TYPE_SCREEN_TAP);
      lastGesture = "ScreenTap Gesture disabled. ";
    } 
    else {
      leap.enableGesture(Type.TYPE_SCREEN_TAP);
      lastGesture = "ScreenTap Gesture enabled. ";
    }
  }

//tbd  
  if (key == '7') {
    if (leap.isEnabled(Type.TYPE_SCREEN_TAP)) {
      leap.disableGesture(Type.TYPE_SCREEN_TAP);
      lastGesture = "ScreenTap Gesture disabled. ";
    } 
    else {
      leap.enableGesture(Type.TYPE_SCREEN_TAP);
      lastGesture = "ScreenTap Gesture enabled. ";
    }
  }

//tbd  
  if (key == '8') {
    if (leap.isEnabled(Type.TYPE_SCREEN_TAP)) {
      leap.disableGesture(Type.TYPE_SCREEN_TAP);
      lastGesture = "ScreenTap Gesture disabled. ";
    } 
    else {
      leap.enableGesture(Type.TYPE_SCREEN_TAP);
      lastGesture = "ScreenTap Gesture enabled. ";
    }
  }

//calibration  
  if (key == '9') {
    if (lastGesture != "Calibration disabled. " && lastGesture != "1 Auffindleuchte\n2 Ladezeitraum\n3 SOC einstellen\n4 Wartezeit\n5 Laden") {
      calibration = false;
      lastGesture = "Calibration disabled. ";
    } 
    else {
      //leap.enableGesture(Type.TYPE_SCREEN_TAP);
      calibration = true;
      lastGesture = "Calibration enabled. ";
    }
  }
}
*/
