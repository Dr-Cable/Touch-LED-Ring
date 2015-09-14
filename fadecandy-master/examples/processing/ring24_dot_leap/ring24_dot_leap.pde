OPC opc;
PImage dot;
import com.onformative.leap.LeapMotionP5;
import com.leapmotion.leap.Finger;

LeapMotionP5 leap;

void setup()
{
  size(500, 500);

  // Load a sample image
  dot = loadImage("dot.png");

  // Connect to the local instance of fcserver
  opc = new OPC(this, "127.0.0.1", 7890);

  // Map one 24-LED ring to the center of the window
  opc.ledRing(0, 24, width/2, height/1.3, width*0.045, 0);
  
  leap = new LeapMotionP5(this);
}

void draw()
{
  background(0);

  // Draw the image, centered at the mouse location
  float dotSize = width * 0.08;
  //image(dot, mouseX - dotSize/2, mouseY - dotSize/2, dotSize, dotSize);
  
  tint(0,127,0);
  for (Finger finger : leap.getFingerList()) {
    PVector fingerPos = leap.getTip(finger);
    //ellipse(fingerPos.x, fingerPos.y, 20, 20);
    image(dot, fingerPos.x - dotSize/2, fingerPos.y - dotSize/2, dotSize, dotSize); 
    //System.out.println("fingerPos.x : ");// fingerPos.x \n "fingerPos.y : " fingerPos.y);
}

}

public void stop() {
  leap.stop();
}
