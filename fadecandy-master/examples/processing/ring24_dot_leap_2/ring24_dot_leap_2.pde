OPC opc;
PImage dot;
PImage dot_sharp;
import com.leapmotion.leap.CircleGesture;
import com.leapmotion.leap.Gesture.State;
import com.leapmotion.leap.Gesture.Type;
import com.leapmotion.leap.Gesture;
import com.leapmotion.leap.Hand;
import com.leapmotion.leap.Finger;
import com.leapmotion.leap.KeyTapGesture;
import com.leapmotion.leap.ScreenTapGesture;
import com.leapmotion.leap.SwipeGesture;
import com.onformative.leap.LeapMotionP5;

boolean Auffindleuchte;
boolean Ladezeitanzeige;
boolean SOCanzeige;
boolean Wartezeit;
boolean Laden;
boolean calibration;

int istSOC;
int sollSOC;

//float pi = 3.1415926535897932384626433832795028841971693993751058;
float angleLED = -2*PI/24;
float currentTime;
float dotSize = 2;
float atmenLED = -0.0025; //0.0025 => langsam/Ladeende 0.05 => schnell/Ladebegin



LeapMotionP5 leap;
 String lastGesture;

//Setup values and data
void setup()
{
  size(500, 500);
  textSize(17);
  // Load a sample image
  dot = loadImage("dot.png");
  dot_sharp = loadImage("dot_sharp.png");
  
  // Connect to the local instance of fcserver
  opc = new OPC(this, "127.0.0.1", 7890);

  // Map one 24-LED ring to the center of the window
  opc.ledRing(0, 24, width/2, height/1.3, width*0.045, 0);
  
  lastGesture =
"1 Auffindleuchte\n2 Ladezeitraum\n3 SOC einstellen\n4 Wartezeit\n5 Laden";
  leap = new LeapMotionP5(this);
  calibration = false;
  currentTime = millis();
  istSOC = 5;
  sollSOC = 15;
  

}

// function to draw the dots
void drawDot(float angle, float distance, float size)
{
  image(dot, width/2-size/2 - distance * sin(angle),//size/2),
    height/1.3-size/2   - distance * cos(angle), size, size);
  //image(dot, (int)(width/2 - distance * sin(angle) + 0.5),//size/2),
    //(int)(height/1.3 - distance * cos(angle) + 0.5), size, size);
}

// function to draw the sharp dots
void drawDot_sharp(float angle, float distance, float size)
{
  image(dot_sharp, 500/2-size/4 - distance * cos(angle),
    500/1.3-size/4 - distance * sin(angle) , size, size);
  //image(dot_sharp, (int)(width/2 - distance * sin(angle) + 0.5),
    //(int)(height/1.3 - distance * cos(angle) + 0.5), size, size);
}


void draw()
{
  background(0);
  currentTime = millis();
  for (Finger finger : leap.getFingerList()) {
    PVector fingerPos = leap.getTip(finger);
    ellipse(fingerPos.x, fingerPos.y, 10, 10);
  }
  //text("radius : ", 100,60 );
  text(lastGesture, 30, 30);
  //text("fingerPos.x: " , 200, 100);// fingerPos.x\n "fingerPos.y: " fingerPos.y, 50,50);
  
  if (Auffindleuchte == true) AuffindleuchteRecognized();
  if (Ladezeitanzeige == true) LadezeitanzeigeRecognized();
  if (SOCanzeige == true) SOCanzeigeRecognized();
  if (Wartezeit == true) WartezeitRecognized();
  if (Laden == true) LadenRecognized();
  if (calibration == true) calibrationRecognized();
  
  // Draw the image, centered at the mouse location
  
  //image(dot, mouseX - dotSize/2, mouseY - dotSize/2, dotSize, dotSize);
  
  //tint(0,127,0);
  //for (Finger finger : leap.getFingerList()) {
    //PVector fingerPos = leap.getTip(finger);
    //ellipse(fingerPos.x, fingerPos.y, 20, 20);
    //image(dot, fingerPos.x - dotSize/2, fingerPos.y - dotSize/2, dotSize, dotSize); 
    //System.out.println("fingerPos.x : ");// fingerPos.x \n "fingerPos.y : " fingerPos.y);
}


public void stop() {
  leap.stop();
}


public void circleGestureRecognized(CircleGesture gesture, String clockwiseness) {
  if (gesture.state() == State.STATE_STOP) {
    System.out.println("//////////////////////////////////////");
    System.out.println("Gesture type: " + gesture.type().toString());
    System.out.println("ID: " + gesture.id());
    System.out.println("Radius: " + gesture.radius());
    System.out.println("Normal: " + gesture.normal());
    System.out.println("Clockwiseness: " + clockwiseness);
    System.out.println("Turns: " + gesture.progress());
    System.out.println("Center: " + leap.vectorToPVector(gesture.center()));
    System.out.println("Duration: " + gesture.durationSeconds() + "s");
    System.out.println("//////////////////////////////////////");
    lastGesture = "Gesture type: " + gesture.type().toString() + "\n";
    lastGesture += "ID: " + gesture.id() + "\n";
    lastGesture += "Radius: " + gesture.radius() + "\n";
    lastGesture += "Normal: " + gesture.normal() + "\n";
    lastGesture += "Clockwiseness: " + clockwiseness + "\n";
    lastGesture += "Turns: " + gesture.progress() + "\n";
    lastGesture += "Center: " + leap.vectorToPVector(gesture.center()) + "\n";
    lastGesture += "Duration: " + gesture.durationSeconds() + "s" + "\n";
  } 
  else if (gesture.state() == State.STATE_START) {
  } 
  else if (gesture.state() == State.STATE_UPDATE) {
  }
}


public void swipeGestureRecognized(SwipeGesture gesture) {
  if (gesture.state() == State.STATE_STOP) {
    System.out.println("//////////////////////////////////////");
    System.out.println("Gesture type: " + gesture.type());
    System.out.println("ID: " + gesture.id());
    System.out.println("Position: " + leap.vectorToPVector(gesture.position()));
    System.out.println("Direction: " + gesture.direction());
    System.out.println("Duration: " + gesture.durationSeconds() + "s");
    System.out.println("Speed: " + gesture.speed());
    System.out.println("//////////////////////////////////////");
    lastGesture = "Gesture type: " + gesture.type().toString() + "\n";
    lastGesture += "ID: " + gesture.id() + "\n";
    lastGesture += "Position: " + leap.vectorToPVector(gesture.position()) + "\n";
    lastGesture += "Direction: " + gesture.direction() + "\n";
    lastGesture += "Speed: " + gesture.speed() + "\n";
    lastGesture += "Duration: " + gesture.durationSeconds() + "s" + "\n";
  } 
  else if (gesture.state() == State.STATE_START) {
  } 
  else if (gesture.state() == State.STATE_UPDATE) {
  }
}


public void screenTapGestureRecognized(ScreenTapGesture gesture) {
  if (gesture.state() == State.STATE_STOP) {
    System.out.println("//////////////////////////////////////");
    System.out.println("Gesture type: " + gesture.type());
    System.out.println("ID: " + gesture.id());
    System.out.println("Position: " + leap.vectorToPVector(gesture.position()));
    System.out.println("Direction: " + gesture.direction());
    System.out.println("Duration: " + gesture.durationSeconds() + "s");
    System.out.println("//////////////////////////////////////");
    lastGesture = "Gesture type: " + gesture.type().toString() + "\n";
    lastGesture += "ID: " + gesture.id() + "\n";
    lastGesture += "Position: " + leap.vectorToPVector(gesture.position()) + "\n";
    lastGesture += "Direction: " + gesture.direction() + "\n";
    lastGesture += "Duration: " + gesture.durationSeconds() + "s" + "\n";
  } 
  else if (gesture.state() == State.STATE_START) {
  } 
  else if (gesture.state() == State.STATE_UPDATE) {
  }
}


public void KeyTapGestureRecognized(KeyTapGesture gesture) {
  if (gesture.state() == State.STATE_STOP) {
    System.out.println("//////////////////////////////////////");
    System.out.println("Gesture type: " + gesture.type());
    System.out.println("ID: " + gesture.id());
    System.out.println("Position: " + leap.vectorToPVector(gesture.position()));
    System.out.println("Direction: " + gesture.direction());
    System.out.println("Duration: " + gesture.durationSeconds() + "s");
    System.out.println("//////////////////////////////////////");
    lastGesture = "Gesture type: " + gesture.type().toString() + "\n";
    lastGesture += "ID: " + gesture.id() + "\n";
    lastGesture += "Position: " + leap.vectorToPVector(gesture.position()) + "\n";
    lastGesture += "Direction: " + gesture.direction() + "\n";
    lastGesture += "Duration: " + gesture.durationSeconds() + "s" + "\n";
  } 
  else if (gesture.state() == State.STATE_START) {
  } 
  else if (gesture.state() == State.STATE_UPDATE) {
  }
}

public void AuffindleuchteRecognized() {
  tint(204,204,204); //weiß
  for (int i = 0; i < 24; i++){
    drawDot_sharp(angleLED*i,width*0.045, 5); 
  }
}

public void LadezeitanzeigeRecognized() {
  Stefan_clk_1();
}

public void SOCanzeigeRecognized() {
  //Stefan_soc_1(); //Vollkreis farbig
  //Stefan_soc_2(); //Vollkreis einfarbig
  Stefan_soc_3(); //Hablkreis einfarbig + Range
}

public void WartezeitRecognized() {
  tint(255, 200, 51); //orange
      //tint(0, 0, 255); //blau
      drawDot(angleLED*currentTime*0.01, width*0.045, 40); //width*0.045, 2
}

public void LadenRecognized() {
  tint(51,255,51); //grün
    //tint(255, 51, 51); //rot
    //tint(255, 200, 51); //orange
   //drawDot(0, width*0, 750*(1.0+0.15*asin(sin(atmenLED*currentTime))));
   drawDot(0, width*0, 130*(1.0+0.2*sin(atmenLED*currentTime)));
}

public void calibrationRecognized() {
  for (int i = 0; i <= 24; i++){
    switch (i) {
    case 24: tint(255, 0, 0); //rot
            break;
    case 6: tint(0, 255, 0); //grün
            break;
    case 12: tint(255, 200, 51); //orange
            break;
    case 18: tint(0, 0, 255); //orange
            break;
    default:tint(0, 0, 0); //schwarz
            break; 
    }
    drawDot_sharp(angleLED*i, width*0.045, 2);
  }  
  for (Finger finger : leap.getFingerList()) {
    tint(255,255,255);
    PVector fingerPos = leap.getTip(finger);
    image(dot_sharp, fingerPos.x - dotSize/2, fingerPos.y - dotSize/2, dotSize, dotSize);
  }
  
  //Stefan_soc_1();
  /*if (gesture.state() == State.STATE_STOP) {
    System.out.println("//////////////////////////////////////");
    System.out.println("Gesture type: " + gesture.type());
    System.out.println("ID: " + gesture.id());
    System.out.println("Position: " + leap.vectorToPVector(gesture.position()));
    System.out.println("Direction: " + gesture.direction());
    System.out.println("Duration: " + gesture.durationSeconds() + "s");
    System.out.println("Speed: " + gesture.speed());
    System.out.println("//////////////////////////////////////");
    lastGesture = "Gesture type: " + gesture.type().toString() + "\n";
    lastGesture += "ID: " + gesture.id() + "\n";
    lastGesture += "Position: " + leap.vectorToPVector(gesture.position()) + "\n";
    lastGesture += "Direction: " + gesture.direction() + "\n";
    lastGesture += "Speed: " + gesture.speed() + "\n";
    lastGesture += "Duration: " + gesture.durationSeconds() + "s" + "\n";
  } 
  else if (gesture.state() == State.STATE_START) {
  } 
  else if (gesture.state() == State.STATE_UPDATE) {
  }*/
}

public void keyPressed() {
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

//Uhr anzeige
void Stefan_clk_1(){
    for (int i = 1; i <= 24; i++){
    switch (i) {
    /*case 1: tint(0, 20, 0); //grün
            break;
    case 2: tint(0, 40, 0); //grün
            break;
    case 3: tint(0, 60, 0); //grün
            break;
    case 4: tint(0, 80, 0); //grün
            break;
            */
    case 5: tint(0, 100, 0); //grün
            break;
    case 7: tint(0, 140, 0); //grün
            break;
    case 8: tint(0, 160, 0); //grün
            break;
    case 9: tint(0, 180, 0); //grün
            break;
    case 10: tint(0, 200, 0); //grün
            break;
    case 11: tint(0, 220, 0); //grün
            break;
    case 13: tint(24, 255, 24); //grün
            break;
    case 14: tint(51, 255, 51); //grün
            break;
    case 6: tint(51, 0, 102); //violett
            break;
    case 12: tint(51, 0, 102); //violett
            break;
    case 18: tint(51, 0, 102); //violett
            break;
    case 24: tint(51, 0, 102); //violett
            break;
    default:tint(51, 51, 51); //weiß
            break; 
    }
    drawDot_sharp(angleLED*i, width*0.045, 2);
    }
    
    /*tint(51, 255, 51); //grün
    drawDot(a*16, width*0.18, width*0.1);
    //Ende
    tint(0, 255, 0); //blau
    for (int i = 5; i <= 5; i++){
       drawDot(a*i*0.003*currentTime, width*0.18, width*0.1); 
    }*/
}


//SOC Anzeige Vollkreis
void Stefan_soc_1(){
  
  currentTime = millis();  
  for (int i = 0; i <= istSOC; i++){
    switch (i) {
    case 0: tint(255, 51, 51); //rot
            break;
    case 1: tint(255, 51, 51); //rot
            break;
    case 2: tint(255, 200, 51); //orange
            break;
    case 3: tint(255, 200, 51); //orange
            break;
    default:tint(51, 255, 51); //grün
            break; 
    }
    drawDot(angleLED*i, width*0.3, width*0.05);
  }
  for (int i = istSOC+1; i < sollSOC; i++){
    switch (i) {
    case 0: tint(255, 51, 51); //rot
            break;
    case 1: tint(255, 51, 51); //rot
            break;
    case 2: tint(255, 200, 51); //orange
            break;
    case 3: tint(255, 200, 51); //orange
            break;
    default:tint(51, 255, 51); //grün
            break; 
    }
    drawDot(angleLED*i, width*0.3, 0.05*width*(asin(sin(-0.0025*currentTime))));
  }
}


// SOC Statusanzeige Vollkreis
void Stefan_soc_2(){
  currentTime = millis();  
  for (int i = 1; i <= istSOC; i++){
      switch (i) {
      case 1: tint(255, 51, 51); //rot
              break;
      case 2: tint(255, 51, 51); //rot
              break;
      case 3: tint(255, 200, 51); //orange
              break;
      case 4: tint(255, 200, 51); //orange
              break;
      default:tint(51, 255, 51); //grün
              break; 
      }
      drawDot(angleLED*i, width*0.3, width*0.03);
  }
    //SollSOC Anzeige
  for (int i = istSOC+1; i <= sollSOC; i++){
    switch (i) {
    case 1: tint(255, 51, 51); //rot
            break;
    case 2: tint(255, 51, 51); //rot
            break;
    case 3: tint(255, 200, 51); //orange
            break;
    case 4: tint(255, 200, 51); //orange
            break;
    default:tint(51, 255, 51); //grün
            break; 
    }
    
      //drawDot(a*i, width*0.35, width*0.06*(sin(0.001*currentTime)));
      //drawDot(a*i, width*0.3, width*0.01); // schwach beleuchtet der SollSOC
      //drawDot(a*i, width*0.3, width*0.03*min(0,(sin(0.003*currentTime)))); 
      drawDot_sharp(angleLED*i, width*0.31, width*0.1*min(1,(sin(0.002*currentTime)))); 
  }
}

// SOC Anzeige Halbkreis
void Stefan_soc_3(){
  currentTime = millis();  
  for (int i = 19; i <= 19+istSOC; i++){
      switch (i) {
      /*case 19: tint(255, 51, 51); //rot
              break;
      case 20: tint(255, 51, 51); //rot
              break;
      case 21: tint(255, 200, 51); //orange
              break;
      case 22: tint(255, 200, 51); //orange
              break;*/
      default:tint(51, 255, 51); //grün
              break; 
      }
      drawDot_sharp(angleLED*i, width*0.045, 2);
  }
    //SollSOC Anzeige mit Range Mode Halbkreis
  for (int i = 19+istSOC+1; i < 19+sollSOC; i++){
    switch (i) {
    case 7+24: tint(0, 204, 204); //türkis
            break;
    case 8+24: tint(0, 204, 204); //tükis
            break;
    case 9+24: tint(0, 204, 204); //türkis
            break;
      /* case 19: tint(255, 51, 51); //rot
            break;
    case 20: tint(255, 51, 51); //rot
            break;
    case 21: tint(255, 200, 51); //orange
            break;
    case 22: tint(255, 200, 51); //orange
            break;*/
    default:tint(51, 255, 51); //grün
            break; 
    }
    
      //drawDot(a*i, width*0.35, width*0.06*(sin(0.001*currentTime)));
      //drawDot(a*i, width*0.3, width*0.01); // schwach beleuchtet der SollSOC
      //drawDot(a*i, width*0.3, width*0.03*min(0,(sin(0.003*currentTime)))); 
      drawDot_sharp(angleLED*i, width*0.045, 2*0.1*min(1,(sin(0.002*currentTime)))); 
  }
   for (int i = 19+12; i < 19+24; i++){
      tint(51, 51, 51);
      drawDot_sharp(angleLED*i, width*0.045, 2); //width*0.045, 2
  }
}

